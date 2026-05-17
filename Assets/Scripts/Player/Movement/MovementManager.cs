using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
[RequireComponent(typeof(MovementSettings))]
[RequireComponent(typeof(GroundMovement))]
[RequireComponent(typeof(AirMovement))]
[RequireComponent(typeof(SlideController))]
[DisallowMultipleComponent]
public class MovementManager : MonoBehaviour
{
    [System.Serializable]
    private struct RuntimeDebugData
    {
        public float configuredSpeed;
        public float horizontalSpeed;
        public float verticalSpeed;
        public float slopeAngle;
        public bool grounded;
        public bool inAir;
        public bool sliding;
        public bool queuedSlideOnLand;
        public string currentState;
    }

    public bool grappling { get; set; }
    public bool slingshotting { get; set; }
    public float currentSpeed { get; set; }
    public bool grounded { get; private set; }
    public bool sprintLatched { get; set; }

    private readonly MovementAnimationDriver animationDriver = new();

    private Rigidbody rb;
    private PlayerInputState input;
    private MovementSettings settings;
    private bool wasGrounded = false;

    private CapsuleCollider capsuleCollider;
    private RaycastHit groundHit;
    private bool hasGroundHit;

    private GroundMovement groundState;
    private AirMovement airState;
    private SlideController slideState;

    [Header("Runtime Debug")]
    [SerializeField] private RuntimeDebugData runtimeDebug;

    private bool queuedSlideOnLand = false;
    private IMovementState currentState;

    public Rigidbody Rb => rb;
    public PlayerInputState Input => input;
    public MovementSettings Settings => settings;
    public Transform Orientation => settings != null && settings.orientation != null ? settings.orientation : transform;
    public float CurrentGroundSlopeAngle => hasGroundHit ? GetSignedSlopeAngle(groundHit.normal) : 0f;

    void Awake()
    {
        rb ??= GetComponent<Rigidbody>();
        input ??= GetComponentInParent<PlayerInputState>();
        settings ??= GetComponent<MovementSettings>();
        capsuleCollider ??= GetComponent<CapsuleCollider>();
        groundState ??= GetComponent<GroundMovement>();
        airState ??= GetComponent<AirMovement>();
        slideState ??= GetComponent<SlideController>();

        if (rb != null)
        {
            rb.freezeRotation = true;
        }
    }

    void Start()
    {
        if (settings == null)
        {
            Debug.LogError("MovementManager requires MovementSettings on the same GameObject.", this);
            enabled = false;
            return;
        }

        if (groundState != null)
        {
            ChangeState(groundState);
        }

        animationDriver.ResetYaw(Orientation);
    }

    void Update()
    {
        if (slideState != null)
        {
            slideState.TickCooldown(Time.deltaTime);
        }

        GroundCheck();
        HandleJumpInput();
        currentState?.HandleInput();
        HandleAirborneSlideQueue();
        HandleSlideCancellation();
        UpdateSlideState();
        animationDriver.Sync(this);
    }

    void FixedUpdate()
    {
        currentState?.FixedUpdateState();
        ApplyGravityModifiers();
    }

    void LateUpdate()
    {
        SyncRuntimeDebug();
    }

    public void ChangeState(IMovementState next)
    {
        if (currentState != null)
        {
            currentState.Exit();
        }

        currentState = next;
        currentState?.Enter(this);
    }

    public bool HasMeaningfulMoveInput(Vector2 move)
    {
        float threshold = settings != null ? settings.moveInputThreshold : 0.1f;
        return move.sqrMagnitude > threshold * threshold;
    }

    public Vector3 GetMoveDirection(Vector2 move)
    {
        Vector3 direction = Orientation.right * move.x + Orientation.forward * move.y;
        return direction.sqrMagnitude > 0f ? direction.normalized : Vector3.zero;
    }

    // Small helper to set velocity safely
    public void SetHorizontalVelocity(Vector3 horizontalVel)
    {
        rb.linearVelocity = new Vector3(horizontalVel.x, rb.linearVelocity.y, horizontalVel.z);
    }

    public bool IsSliding()
    {
        return slideState != null && slideState.IsSliding;
    }

    public bool TryStartSlide()
    {
        if (slideState == null || !grounded || input == null || slideState.IsSliding || slideState.IsOnCooldown)
        {
            return false;
        }

        float horizSpeed = new Vector3(rb.linearVelocity.x, 0f, rb.linearVelocity.z).magnitude;
        bool canSlide = input.SprintHeld || sprintLatched || horizSpeed >= EffectiveSlideRequireSpeed();
        if (!canSlide)
        {
            return false;
        }

        float slopeAngle = CurrentGroundSlopeAngle;
        if (slopeAngle < -settings.slideStopUphillAngle)
        {
            return false;
        }

        ChangeState(slideState);
        slideState.StartSlide(slopeAngle);
        queuedSlideOnLand = false;
        return true;
    }

    private void HandleAirborneSlideQueue()
    {
        if (input == null || slideState == null || slideState.IsSliding || grounded)
        {
            return;
        }

        if (input.CrouchPressedThisFrame)
        {
            float horizSpeed = new Vector3(rb.linearVelocity.x, 0f, rb.linearVelocity.z).magnitude;
            bool canQueueSlide = input.SprintHeld || sprintLatched || horizSpeed >= EffectiveSlideRequireSpeed();
            if (canQueueSlide)
            {
                queuedSlideOnLand = true;
            }
        }

        if (input.CrouchReleasedThisFrame)
        {
            queuedSlideOnLand = false;
        }
    }

    private void HandleSlideCancellation()
    {
        if (slideState == null || input == null || !slideState.IsSliding)
        {
            return;
        }

        if (input.CrouchReleasedThisFrame)
        {
            StopActiveSlide();
        }
    }

    private void UpdateSlideState()
    {
        if (slideState == null || !slideState.IsSliding)
        {
            return;
        }

        float slopeAngle = CurrentGroundSlopeAngle;
        if (slopeAngle < -settings.slideStopUphillAngle)
        {
            StopActiveSlide();
            return;
        }

        float horizontalSpeedSqr = rb.linearVelocity.x * rb.linearVelocity.x + rb.linearVelocity.z * rb.linearVelocity.z;
        if (horizontalSpeedSqr <= settings.slideStopSpeed * settings.slideStopSpeed)
        {
            StopActiveSlide();
        }
    }

    private void StopActiveSlide()
    {
        if (slideState == null || !slideState.IsSliding)
        {
            return;
        }

        slideState.StopSlide();

        if (grounded && groundState != null)
        {
            ChangeState(groundState);
        }
        else if (!grounded && airState != null)
        {
            ChangeState(airState);
        }
    }

    private void HandleJumpInput()
    {
        if (input == null || !input.JumpPressedThisFrame) return;

        if (grounded)
        {
            Jump(Vector3.up);
        }
        else if (settings.wallDetector != null && settings.wallDetector.nearWall)
        {
            WallJump();
        }
    }

    private void Jump(Vector3 direction)
    {
        rb.linearVelocity = new Vector3(rb.linearVelocity.x, 0f, rb.linearVelocity.z);
        rb.AddForce(direction * settings.jumpForce, ForceMode.Impulse);
        grounded = false;

        animationDriver.TriggerJump(settings);

        if (slideState != null && slideState.IsSliding)
        {
            slideState.StopSlide();
        }

        if (airState != null)
        {
            ChangeState(airState);
        }
    }

    private void WallJump()
    {
        if (settings.wallDetector == null || settings.wallDetector.wallNormal == Vector3.zero) return;

        Vector3 jumpDir = (settings.wallDetector.wallNormal * settings.wallPushAwayForce + Vector3.up * settings.wallPushUpForce).normalized;
        Jump(jumpDir * settings.wallJumpDirectionMultiplier);
    }

    private void GroundCheck()
    {
        wasGrounded = grounded;
        grounded = CheckGrounded();
        hasGroundHit = Physics.Raycast(transform.position, Vector3.down, out groundHit, settings.groundCheckDistance * 2f, settings.groundMask);

        // Switch states based on grounded status
        if (grounded && !wasGrounded)
        {
            // Just landed
            float horizSpeedLanding = new Vector3(rb.linearVelocity.x, 0f, rb.linearVelocity.z).magnitude;

            // Auto-latch sprint on landing if horizontal speed is high enough
            if (horizSpeedLanding >= EffectiveAutoSprintSpeed())
            {
                sprintLatched = true;
            }

            // If player queued a slide while airborne, try to start it on landing
            if (queuedSlideOnLand && slideState != null)
            {
                if ((input != null && (input.SprintHeld || sprintLatched)) || horizSpeedLanding >= EffectiveSlideRequireSpeed())
                {
                    TryStartSlide();
                    queuedSlideOnLand = false;
                    return; // Don't switch to ground yet; slide state will handle it
                }
                queuedSlideOnLand = false;
            }

            // Switch to ground state if not already sliding
            if (groundState != null && currentState != groundState && currentState != slideState)
            {
                ChangeState(groundState);
            }
        }
        else if (!grounded && wasGrounded)
        {
            // Switch to air state
            if (airState != null && currentState != airState)
            {
                ChangeState(airState);
            }
        }
    }

    private bool CheckGrounded()
    {
        if (capsuleCollider == null)
        {
            return Physics.Raycast(transform.position, Vector3.down, settings.groundCheckDistance, settings.groundMask);
        }

        Bounds bounds = capsuleCollider.bounds;
        float radius = Mathf.Max(0.01f, bounds.extents.x * 0.9f);
        Vector3 bottom = new Vector3(bounds.center.x, bounds.min.y + 0.05f, bounds.center.z);
        Vector3 top = new Vector3(bounds.center.x, bounds.max.y - radius, bounds.center.z);

        return Physics.CheckCapsule(bottom, top, radius, settings.groundMask, QueryTriggerInteraction.Ignore);
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (slideState == null || !slideState.IsSliding)
        {
            return;
        }

        foreach (ContactPoint contact in collision.contacts)
        {
            float surfaceAngle = Vector3.Angle(contact.normal, Vector3.up);
            if (surfaceAngle >= settings.slideStopSurfaceAngle)
            {
                StopActiveSlide();
                break;
            }
        }
    }

    private void ApplyGravityModifiers()
    {
        if (!rb.useGravity) return;

        if (rb.linearVelocity.y < 0)
        {
            rb.AddForce(Vector3.up * Physics.gravity.y * (settings.fallMultiplier - 1f), ForceMode.Acceleration);
        }
        else if (rb.linearVelocity.y > 0)
        {
            if (input != null && !input.JumpHeld)
            {
                rb.AddForce(Vector3.up * Physics.gravity.y * (settings.lowJumpMultiplier - 1f), ForceMode.Acceleration);
            }
            else
            {
                rb.AddForce(Vector3.up * Physics.gravity.y * (settings.upwardMultiplier - 1f), ForceMode.Acceleration);
            }
        }
    }

    private float GetSignedSlopeAngle(Vector3 groundNormal)
    {
        float angle = Vector3.Angle(Vector3.up, groundNormal);
        if (angle <= settings.flatGroundAngleThreshold)
        {
            return 0f;
        }

        Vector3 downslopeDirection = Vector3.ProjectOnPlane(Vector3.down, groundNormal).normalized;
        if (downslopeDirection.sqrMagnitude <= 0.0001f)
        {
            return 0f;
        }

        return Vector3.Dot(Orientation.forward, downslopeDirection) >= 0f ? angle : -angle;
    }

    private float EffectiveAutoSprintSpeed()
    {
        return settings.autoSprintSpeed > 0f ? settings.autoSprintSpeed : settings.walkSpeed;
    }

    private float EffectiveSlideRequireSpeed()
    {
        return settings.slideRequireSpeed > 0f ? settings.slideRequireSpeed : settings.walkSpeed;
    }

    private void SyncRuntimeDebug()
    {
        if (rb == null)
        {
            return;
        }

        Vector3 velocity = rb.linearVelocity;
        runtimeDebug.configuredSpeed = currentSpeed;
        runtimeDebug.horizontalSpeed = new Vector3(velocity.x, 0f, velocity.z).magnitude;
        runtimeDebug.verticalSpeed = velocity.y;
        runtimeDebug.slopeAngle = CurrentGroundSlopeAngle;
        runtimeDebug.grounded = grounded;
        runtimeDebug.inAir = !grounded;
        runtimeDebug.sliding = slideState != null && slideState.IsSliding;
        runtimeDebug.queuedSlideOnLand = queuedSlideOnLand;
        runtimeDebug.currentState = currentState != null ? currentState.GetType().Name : "None";
    }
}
