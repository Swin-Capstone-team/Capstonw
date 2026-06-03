using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
[RequireComponent(typeof(MovementSettings))]
[RequireComponent(typeof(GroundMovement))]
[RequireComponent(typeof(AirMovement))]
[RequireComponent(typeof(SlideController))]
[DisallowMultipleComponent]
public class MovementManager : MonoBehaviour
{
    private readonly VerticalMovementController verticalMovement = new();
    private readonly MovementAnimationDriver animationDriver = new();

    private Rigidbody rb;
    private PlayerInputState input;
    private MovementSettings settings;
    private CapsuleCollider capsuleCollider;
    private GroundProbe groundProbe;

    private GroundMovement groundState;
    private AirMovement airState;
    private SlideController slideState;

    private bool grappling;
    private bool slingshotting;
    private float currentSpeed;
    private bool sprintLatched;
    private IMovementState currentState;

    public Rigidbody Rb => rb;
    public PlayerInputState Input => input;
    public MovementSettings Settings => settings;
    public Transform Orientation => settings != null && settings.orientation != null ? settings.orientation : transform;
    public float CurrentGroundSlopeAngle => groundProbe != null ? groundProbe.CurrentSlopeAngle : 0f;
    public bool IsGrappling => grappling;
    public bool IsSlingshotting => slingshotting;
    public float CurrentSpeed => currentSpeed;
    public bool IsGrounded => groundProbe != null && groundProbe.IsGrounded;
    public bool IsSprintLatched => sprintLatched;
    public bool JustLanded => groundProbe != null && groundProbe.IsGrounded && !groundProbe.WasGrounded;
    public bool JustLeftGround => groundProbe != null && !groundProbe.IsGrounded && groundProbe.WasGrounded;
    public bool IsSliding => slideState != null && slideState.IsSliding;
    public bool HasQueuedSlideOnLand => slideState != null && slideState.HasQueuedSlideOnLand;
    public string CurrentStateName => currentState != null ? currentState.GetType().Name : "None";
    public float HorizontalSpeed => rb != null ? new Vector3(rb.linearVelocity.x, 0f, rb.linearVelocity.z).magnitude : 0f;
    public float VerticalSpeed => rb != null ? rb.linearVelocity.y : 0f;
    public float EffectiveAutoSprintSpeed => settings == null ? 0f : settings.autoSprintSpeed > 0f ? settings.autoSprintSpeed : settings.walkSpeed;
    public float EffectiveSlideRequireSpeed => settings == null ? 0f : settings.slideRequireSpeed > 0f ? settings.slideRequireSpeed : settings.walkSpeed;

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

        if (settings != null)
        {
            groundProbe = new GroundProbe(transform, capsuleCollider, settings);
        }

        slideState?.Initialize(this);
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
        slideState?.TickCooldown(Time.deltaTime);

        GroundCheck();
        verticalMovement.HandleJumpInput(this);
        currentState?.HandleInput();
        slideState?.HandleAirborneQueue();
        slideState?.UpdateActiveSlide();
        animationDriver.Sync(this);
    }

    void FixedUpdate()
    {
        currentState?.FixedUpdateState();
        verticalMovement.ApplyGravityModifiers(this);
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

    public void SetGrappling(bool value)
    {
        grappling = value;
    }

    public void SetSlingshotting(bool value)
    {
        slingshotting = value;
    }

    public void SetCurrentSpeed(float value)
    {
        currentSpeed = value;
    }

    public void SetSprintLatched(bool value)
    {
        sprintLatched = value;
    }

    public bool TryStartSlide()
    {
        return slideState != null && slideState.TryStartSlide();
    }

    public void ReturnToDefaultMovementState()
    {
        IMovementState nextState = IsGrounded ? groundState : airState;
        if (nextState != null && currentState != nextState)
        {
            ChangeState(nextState);
        }
    }

    public void OnJumpExecuted()
    {
        groundProbe?.ForceUngrounded();

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

    private void GroundCheck()
    {
        if (groundProbe == null)
        {
            return;
        }

        groundProbe.Refresh(Orientation);

        if (JustLanded)
        {
            if (HorizontalSpeed >= EffectiveAutoSprintSpeed)
            {
                sprintLatched = true;
            }

            bool startedQueuedSlide = slideState != null && slideState.TryConsumeQueuedSlideOnLanding();
            if (!startedQueuedSlide && groundState != null && currentState != groundState && currentState != slideState)
            {
                ChangeState(groundState);
            }
        }
        else if (JustLeftGround)
        {
            SwitchToAirState();
        }
    }

    private void SwitchToAirState()
    {
        if (airState != null && currentState != airState)
        {
            ChangeState(airState);
        }
    }
}
