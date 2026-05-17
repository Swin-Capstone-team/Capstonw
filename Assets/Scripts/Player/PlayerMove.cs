using UnityEngine;

[RequireComponent(typeof(Rigidbody), typeof(CapsuleCollider))]
[DisallowMultipleComponent]
public class PlayerMove : MonoBehaviour
{
    [Header("Movement Settings")]
    public bool grappling { get;  set; }
    public bool slingshotting { get; set; }
    public float walkSpeed = 7f;
    public float sprintSpeed = 12f;
    public float acceleration = 1f;
    public float jumpForce = 15.5f;
    public float upwardMultiplier = 2f;
    public float fallMultiplier = 3.5f;
    public float lowJumpMultiplier = 4.5f;
    public float groundFriction = 12f;
    public float groundCheckDistance = 0.5f;
    public LayerMask groundMask;
    public float currentSpeed { get;  set; }
    public bool canMove = true;

    [Header("Air Strafing Settings")]
    public float airMaxSpeed = 7f;
    public float airAcceleration = 15f;

    [Header("Slide Settings")]
    public float slideSpeedBoost = 1f;
    public float slideMinSlopeAngle = 10f;
    private bool isSliding = false;
    private float slideRefresh = 0f;
    public float slideCooldown = 2.5f;
    private float currentSlopeAngle = 0f;
    private bool downhillSlide = false;
    public float slideDecayDuration = 2.5f;
    private float slideDecayElapsed = 0f;
    private float slideStartHorizontalSpeed = 0f;
    public float slideStopSpeed = 0.05f;
    public float slideStopSurfaceAngle = 60f;
    public float slideStopUphillAngle = 25f;
    private bool queuedSlideOnLand = false;
    public float slideRequireSpeed = 0f; // if <=0, defaults to walkSpeed at Start()
    private bool sprintLatched = false;
    public float autoSprintSpeed = 0f; // if <=0, defaults to walkSpeed at Start()

    [Header("Wall Run Settings")]
    private Vector3 wallRunDirection;
    bool isWallRunning = false;
    private float wallrunSpeed = 5f;
    private float wallmaxSpeed = 10f;

    [Header("Wall Jump Settings")]
    [SerializeField] private float wallStickForce = 10f;
    public WallDetector wallDetector;
    public float wallPushAwayForce = 5f;
    public float wallPushUpForce = 3f;

    [Header("Look Settings")]
    public Transform orientation;
    public Transform playerCamera;
    
    [Header("Animation Settings")]
    public Animator animator;
    private float lastYaw;
    [SerializeField] private CameraShake cameraShake;

    private PlayerInputState _input;
    
    private Rigidbody rb;
    private float xRotation = 0f;
    private float targetXRotation = 0f;
    private float yawRotation = 0f;
    private float targetYawRotation = 0f;
    public bool grounded { get; private set; }
    private bool wasGrounded;
    private float lowestAirVelocityY;
    private bool jumpedThisAir = false;
    private Vector3 inputDir;

    void Awake()
    {
        _input ??= GetComponentInParent<PlayerInputState>();

        if (_input != null) return;

        Debug.LogError("PlayerMove requires PlayerInputState on this object or a parent.", this);
        enabled = false;
    }

    void Start()
    {
        if (!enabled) return;

        rb = GetComponent<Rigidbody>();

        rb.freezeRotation = true;
        if (cameraShake == null)
        {
            cameraShake = playerCamera.GetComponent<CameraShake>();
        }

        Cursor.lockState = CursorLockMode.Locked;
        slideRefresh = 0f;
        if (slideRequireSpeed <= 0f) slideRequireSpeed = walkSpeed;
        if (autoSprintSpeed <= 0f) autoSprintSpeed = walkSpeed;
    }
    
    void Update()
    {
        GroundCheck();
        
        UpdateTimers();
        ParseInputDirection();
        
        HandleCrouchInput();
        HandleJumpInput();
        
        UpdatePhysicsStates();
        UpdateSlideState();
        UpdateAnimations();
    }

    void FixedUpdate()
    {
        if (isWallRunning)
        {
            HandleWallRunMovement();
        }
        else if (isSliding)
        {
            HandleSlideMovement();
            HandleGravityModifiers();
        }
        else
        {
            HandleStandardMovement();
            HandleGravityModifiers();
        }
    }

    private void HandleGravityModifiers()
    {
        if (!rb.useGravity) return;

        if (rb.linearVelocity.y < 0)
        {
            rb.AddForce(Vector3.up * Physics.gravity.y * (fallMultiplier - 1f), ForceMode.Acceleration);
        }
        else if (rb.linearVelocity.y > 0)
        {
            if (!_input.JumpHeld)
            {
                rb.AddForce(Vector3.up * Physics.gravity.y * (lowJumpMultiplier - 1f), ForceMode.Acceleration);
            }
            else
            {
                rb.AddForce(Vector3.up * Physics.gravity.y * (upwardMultiplier - 1f), ForceMode.Acceleration);
            }
        }
    }

    private void UpdateTimers()
    {
        slideRefresh -= Time.deltaTime;
    }

    private void ParseInputDirection()
    {
        float moveX = _input.Move.x;
        float moveZ = _input.Move.y;
        
        if (orientation != null)
        {
            inputDir = (orientation.right * moveX + orientation.forward * moveZ).normalized;
        }
        else
        {
            inputDir = (transform.right * moveX + transform.forward * moveZ).normalized;
        }

        // Latch sprint when player holds sprint while moving; clear when movement stops
        if (_input.SprintHeld && inputDir.sqrMagnitude > 0.01f)
        {
            sprintLatched = true;
        }

        if (inputDir.sqrMagnitude <= 0.01f)
        {
            sprintLatched = false;
        }
    }

    private void HandleCrouchInput()
    {
        float horizSpeed = new Vector3(rb.linearVelocity.x, 0f, rb.linearVelocity.z).magnitude;

        if (_input.CrouchPressedThisFrame && !isSliding && slideRefresh <= 0f && (_input.SprintHeld || sprintLatched || horizSpeed >= slideRequireSpeed))
        {
            if (!grounded && wallDetector.nearWall)
            {
                isWallRunning = true;
                if(isWallRunning) { WallRun(); }
            }
            else if (grounded)
            {
                float slopeAngle = GetGroundSlopeAngle();
                if (CanStartSlide(slopeAngle))
                {
                    StartSlide(slopeAngle);
                }
            }
            else
            {
                // Player pressed crouch while airborne -> queue slide on landing if moving fast enough or sprinting (latched)
                if (_input.SprintHeld || sprintLatched || horizSpeed >= slideRequireSpeed)
                {
                    queuedSlideOnLand = true;
                }
            }
        }

        // Cancel queued slide if crouch released before landing
        if (_input.CrouchReleasedThisFrame)
        {
            queuedSlideOnLand = false;
        }
    }

    private void HandleJumpInput()
    {
        if (_input.JumpPressedThisFrame)
        {
            if (grounded)
            {
                Jump(Vector3.up);
            }
            else if (wallDetector != null && wallDetector.nearWall)
            {
                WallJump();
            }
        }
    }

    private void UpdatePhysicsStates()
    {
        if (isWallRunning)
        {
            if (!wallDetector.nearWall) { isWallRunning = false; }
        }

        rb.useGravity = !isWallRunning;
    }

    void HandleStandardMovement()
    {
        if (HandleGrappleMovement()) return;

        if (inputDir.sqrMagnitude > 0.01f)
        { 
            Vector3 currentVelocity = new Vector3(rb.linearVelocity.x, 0f, rb.linearVelocity.z);
            
            if (!grounded && !(grappling && wallDetector != null && wallDetector.nearWall))
            {
                HandleAirStrafing(currentVelocity);
                return;
            }

            if (grounded)
            {
                HandleGroundAcceleration(currentVelocity);
            }

            ApplyMovementForce(currentVelocity);
        }
        else if (grounded)
        {
            ApplyFriction(); 
        }
    }

    private bool HandleGrappleMovement()
    {
        if (grappling && !slingshotting && !grounded)
        {
            currentSpeed = Mathf.Min(rb.linearVelocity.magnitude, sprintSpeed);
            return true;
        }
        return false;
    }

    private void HandleAirStrafing(Vector3 currentVelocity)
    {
        float projVel = Vector3.Dot(currentVelocity, inputDir);
        float addSpeed = airMaxSpeed - projVel;
        
        if (addSpeed > 0)
        {
            rb.AddForce(inputDir * airAcceleration, ForceMode.Acceleration);
        }
    }

    private void HandleGroundAcceleration(Vector3 currentVelocity)
    {
        bool isSprinting = _input.SprintHeld || sprintLatched;
        float targetSpeed = isSprinting ? sprintSpeed : walkSpeed;
        if(currentSpeed < targetSpeed) 
        {
            currentSpeed += acceleration * (targetSpeed/walkSpeed);
        }

        if (new Vector2(currentVelocity.x, currentVelocity.z).sqrMagnitude > targetSpeed*targetSpeed) 
        {
            ApplyFriction();
        }
    }

    private void ApplyMovementForce(Vector3 currentVelocity)
    {
        float modifier = grounded || (grappling && wallDetector != null && wallDetector.nearWall) ? 10 : 1f;
        Vector3 desiredVel = inputDir * currentSpeed;
        Vector3 forceDir = desiredVel - currentVelocity;
        
        rb.AddForce(forceDir * modifier, ForceMode.Force);
    }
    
    void ApplyFriction()
    {
        Vector3 horizontalVel = new Vector3(rb.linearVelocity.x, 0f, rb.linearVelocity.z);
        Vector3 frictionForce = -horizontalVel * groundFriction;
        rb.AddForce(frictionForce, ForceMode.Acceleration);
                
        currentSpeed = horizontalVel.magnitude;
    }

    void HandleSlideMovement()
    {
        Vector3 horizontalVel = new Vector3(rb.linearVelocity.x, 0f, rb.linearVelocity.z);
        float horizontalMagnitude = horizontalVel.magnitude;

        slideDecayElapsed += Time.fixedDeltaTime;
        float decayT = Mathf.Clamp01(slideDecayElapsed / slideDecayDuration);
        float targetHorizontalSpeed = Mathf.Lerp(slideStartHorizontalSpeed, 0f, decayT);

        if (targetHorizontalSpeed <= slideStopSpeed || horizontalMagnitude < 0.0001f)
        {
            StopSlide();
            return;
        }

        float clampedSpeed = Mathf.Min(horizontalMagnitude, targetHorizontalSpeed);
        Vector3 horizontalDirection = horizontalVel / horizontalMagnitude;

        rb.linearVelocity = new Vector3(
            horizontalDirection.x * clampedSpeed,
            rb.linearVelocity.y,
            horizontalDirection.z * clampedSpeed
        );
    }

    void UpdateSlideState()
    {
        if (!isSliding)
        {
            return;
        }

        currentSlopeAngle = GetGroundSlopeAngle();

        if (downhillSlide && currentSlopeAngle <= 0f && grounded)
        {
            downhillSlide = false;
        }

        if (_input.CrouchReleasedThisFrame || currentSlopeAngle < -slideStopUphillAngle)
        {
            StopSlide();
            return;
        }

        float horizontalSpeedSqr = rb.linearVelocity.x * rb.linearVelocity.x + rb.linearVelocity.z * rb.linearVelocity.z;
        if (horizontalSpeedSqr <= slideStopSpeed * slideStopSpeed)
        {
            StopSlide();
        }
    }

    bool CanStartSlide(float slopeAngle)
    {
        return slopeAngle >= -slideStopUphillAngle;
    }

    void HandleWallRunMovement()
    {
        Vector3 wallNormal = wallDetector.wallNormal;

        Vector3 wallForward = Vector3.Cross(Vector3.up, wallNormal).normalized;

        rb.AddForce(-wallDetector.wallNormal * wallStickForce, ForceMode.Force);

        if (Vector3.Dot(wallForward, transform.forward) < 0f)
        {
            wallForward = -wallForward;
        }

        wallRunDirection = wallForward;

        if (_input.Move.y > 0.1f)
        {
            float forwardSpeed = Vector3.Dot(rb.linearVelocity, wallRunDirection);

            if (forwardSpeed < wallmaxSpeed)
            {
                rb.AddForce(wallRunDirection * wallrunSpeed, ForceMode.Acceleration);
            }
        }
    }

    void OnCollisionEnter(Collision collision)
    {
        if (!isSliding) return;

        if (ShouldStopSlideForCollision(collision))
        {
            StopSlide();
        }
    }

    bool ShouldStopSlideForCollision(Collision collision)
    {
        foreach (ContactPoint contact in collision.contacts)
        {
            float surfaceAngle = Vector3.Angle(contact.normal, Vector3.up);
            if (surfaceAngle >= slideStopSurfaceAngle)
            {
                return true;
            }
        }

        return false;
    }

    void StartSlide(float slopeAngle)
    {
        currentSlopeAngle = slopeAngle;

        if (currentSlopeAngle < -slideStopUphillAngle)
        {
            return;
        }

        isSliding = true;
        slideRefresh = slideCooldown;
        slideDecayElapsed = 0f;

        Vector3 currentVel = rb.linearVelocity;
        Vector3 horizontalVel = new Vector3(currentVel.x, 0f, currentVel.z);
        float currentHorizontalSpeed = horizontalVel.magnitude;
        slideStartHorizontalSpeed = Mathf.Max(currentHorizontalSpeed, sprintSpeed * slideSpeedBoost);

        if (currentHorizontalSpeed > 0.1f)
        {
            Vector3 direction = horizontalVel.normalized;
            rb.linearVelocity = new Vector3(direction.x * slideStartHorizontalSpeed, currentVel.y, direction.z * slideStartHorizontalSpeed);
            downhillSlide = currentSlopeAngle > slideMinSlopeAngle;
        }
        else
        {
            rb.AddForce(transform.forward * slideStartHorizontalSpeed, ForceMode.Impulse);
            downhillSlide = currentSlopeAngle > slideMinSlopeAngle;
        }
        // Ensure movement systems know our current horizontal speed (preserve momentum)
        currentSpeed = slideStartHorizontalSpeed;
    }

    void WallRun()
    {
        Vector3 wallNormal = wallDetector.wallNormal;
        isSliding = true;
        slideRefresh = slideCooldown;

        rb.AddForce(transform.forward * 2f, ForceMode.Impulse);

        Vector3 wallForward = Vector3.Cross(Vector3.up, wallNormal).normalized;

        if (Vector3.Dot(wallForward, transform.forward) < 0f)
        {
            wallForward = -wallForward;
        }

        wallRunDirection = wallForward;
    }

    void StopSlide()
    {
        isWallRunning = false;
        isSliding = false;
        downhillSlide = false;
        slideDecayElapsed = 0f;
        slideStartHorizontalSpeed = 0f;
        slideRefresh = slideCooldown;
    }

    void Jump(Vector3 direction)
    {
        rb.linearVelocity = new Vector3(rb.linearVelocity.x, 0f, rb.linearVelocity.z);
        rb.AddForce(direction * jumpForce, ForceMode.Impulse);

        jumpedThisAir = true;

        animator.SetTrigger("Jump");

        if (isSliding) StopSlide();
    }

    void WallJump()
    {
        if (wallDetector.wallNormal == Vector3.zero) return;

        Vector3 jumpDir = (wallDetector.wallNormal * wallPushAwayForce + Vector3.up * wallPushUpForce).normalized;
        Jump(jumpDir * 1.5f);
    }

    void GroundCheck()
    {
        wasGrounded = grounded;
        grounded = Physics.Raycast(transform.position, Vector3.down, groundCheckDistance, groundMask);

        if (!grounded)
        {
            lowestAirVelocityY = Mathf.Min(lowestAirVelocityY, rb.linearVelocity.y);
        }

        if (!wasGrounded && grounded)
        {
            if (jumpedThisAir)
            {
                cameraShake?.PlayLandingShake(Mathf.Abs(lowestAirVelocityY));
            }
            jumpedThisAir = false;
            lowestAirVelocityY = 0f;

            // Auto-latch sprint on landing if horizontal speed is high enough
            float horizSpeedLanding = new Vector3(rb.linearVelocity.x, 0f, rb.linearVelocity.z).magnitude;
            if (horizSpeedLanding >= autoSprintSpeed)
            {
                sprintLatched = true;
            }

            // If player queued a slide while airborne, try to start it on landing
            if (queuedSlideOnLand && slideRefresh <= 0f)
            {
                if (_input.SprintHeld || sprintLatched || horizSpeedLanding >= slideRequireSpeed)
                {
                    float slopeAngle = GetGroundSlopeAngle();
                    if (CanStartSlide(slopeAngle))
                    {
                        StartSlide(slopeAngle);
                    }
                }
                queuedSlideOnLand = false;
            }
        }

        if (grounded)
        {
            lowestAirVelocityY = 0f;
        }
    }
    
    float GetGroundSlopeAngle()
    {
        RaycastHit hit;
        if (!Physics.Raycast(transform.position, Vector3.down, out hit, groundCheckDistance * 2f, groundMask))
        {
            return 0f;
        }

        float angle = Vector3.Angle(Vector3.up, hit.normal);

        Vector3 slopeDir = Vector3.Cross(hit.normal, transform.right).normalized;
        bool isDownslope = Vector3.Dot(slopeDir, transform.forward) > 0f;

        if (angle < 2f) return 0f;
        return isDownslope ? angle : -angle;
    }

    void UpdateAnimations()
    {
        Transform refTransform = orientation != null ? orientation : transform;
        Vector3 localVel = refTransform.InverseTransformDirection(rb.linearVelocity);

        animator.SetBool("IsMoving", _input.Move.sqrMagnitude > 0.01f);

        animator.SetFloat("VelocityX", localVel.x / sprintSpeed, 0.1f, Time.deltaTime);
        animator.SetFloat("VelocityZ", localVel.z / sprintSpeed, 0.1f, Time.deltaTime);

        animator.SetBool("IsGrounded", grounded);
        animator.SetFloat("VerticalVelocity", rb.linearVelocity.y);

        float currentYaw = refTransform.eulerAngles.y;
        float rawTurnRate = Mathf.DeltaAngle(lastYaw, currentYaw) / Time.deltaTime;
        animator.SetBool("IsTurning", Mathf.Abs(rawTurnRate) > 5f);
        
        float normalizedTurn = Mathf.Clamp(rawTurnRate / 180f, -1f, 1f);
        animator.SetFloat("Turn", normalizedTurn, 0.1f, Time.deltaTime);

        lastYaw = currentYaw;
    }
}
