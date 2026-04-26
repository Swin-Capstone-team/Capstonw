using UnityEngine;

[RequireComponent(typeof(Rigidbody), typeof(CapsuleCollider))]
[DisallowMultipleComponent]
public class PlayerMove : MonoBehaviour
{
    [Header("Movement Settings")]
    public bool grappling = false;
    public float walkSpeed = 7f;
    public float sprintSpeed = 12f;
    public float acceleration = 1f;
    public float jumpForce = 7f;
    public float groundFriction = 12f;
    public float airControl = 0.5f;
    public float groundCheckDistance = 0.5f;
    public LayerMask groundMask;
    public float currentSpeed = 0;
    private KeyCode SprintKey = KeyCode.LeftShift;

    [Header("Slide Settings")]
    public float slideFrictionAdjustment = 0.2f;
    private float slideDuration = 1f;
    private float wallrunTimer; // how long the slide lasts when initiated in air near wall
    public float slideHeight = 0.5f;       // how short the collider gets while sliding
    private bool isSliding = false;
    private float slideTimer = 0f;
    private float slideRefresh = 0f;
    private float slideCooldown = 2f;

    [Header("Wall Run Settings")]
    private Vector3 wallRunDirection;
    private float wallrunDuration = 1.5f; // how long the wallrun lasts
    bool isWallRunning = false;
    private float wallrunSpeed = 5f;
    private float wallmaxSpeed = 10f;

    [Header("Wall Jump Settings")]
    [SerializeField] private float wallStickForce = 10f;
    public WallDetector wallDetector;
    public float wallPushAwayForce = 5f;
    public float wallPushUpForce = 3f;

    [Header("Look Settings")]
    public float mouseSensitivity = 100f;
    public Transform playerCamera;
    public float cameraSlideHeightAdjust = -0.5f;
    public float lookDamping = 0.15f;  // Lower = smoother, 0-1 range
    
    private PlayerInputState _input;
    
    
    private Rigidbody rb;
    private CapsuleCollider capsule;
    private float xRotation = 0f;
    private float targetXRotation = 0f;
    private float yawRotation = 0f;
    private float targetYawRotation = 0f;
    public bool grounded { get; private set; }
    private Vector3 inputDir;

    // store original collider + camera info
    private float originalColliderHeight;
    private Vector3 originalColliderCenter;
    private Vector3 originalCameraLocalPos;

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
        capsule = GetComponent<CapsuleCollider>();

        rb.freezeRotation = true;

        originalColliderHeight = capsule.height;
        originalColliderCenter = capsule.center;
        originalCameraLocalPos = playerCamera.localPosition;

        Cursor.lockState = CursorLockMode.Locked;

        wallrunTimer = slideDuration * 1.5f; //  wallrun slide lasts 50% longer than regular slide
    }
    
    void Update()
    {
        HandleLook();
        GroundCheck();

        slideRefresh -= Time.deltaTime;


        // start slide and check for wallrun initiation
        if (_input.CrouchPressedThisFrame && !isSliding && slideRefresh <= 0f)
        {
            if (!grounded && wallDetector.nearWall) // in air & near wall = wallrun
            {
                isWallRunning = true;
                if(isWallRunning) { WallRun(); }
            }
            else { StartSlide(); }
        }
        //Check for wallrun end conditions
        if (isWallRunning)
        {
            if (!wallDetector.nearWall) { isWallRunning = false; }
        }

        if (isWallRunning)
        {
            rb.useGravity = false; // disable gravity while wallrunning
        } else if (!isWallRunning) { rb.useGravity = true; }
       

        // end slide (timer or key up)
        if (isSliding)
        {
            slideTimer -= Time.deltaTime;   //timer countdown for slide duration
            if (slideTimer <= 0f || _input.CrouchReleasedThisFrame)
            {
                StopSlide();    // stop slide when timer runs out or key is released
            }
        }

       

        // Collect input here (for FixedUpdate use)
        float moveX = _input.Move.x;
        float moveZ = _input.Move.y;
        inputDir = (transform.right * moveX + transform.forward * moveZ).normalized;

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

    void FixedUpdate()
    {
        if (isWallRunning)
        {
            HandleWallRunMovement();
        }

        else if (isSliding) // disable control while sliding
        {
            HandleSlideMovement();
        }
        else
        {
            HandleMovement();
        }
       
        
    }

    void HandleLook()
    {
        float mouseX = _input.Look.x * mouseSensitivity;
        float mouseY = _input.Look.y * mouseSensitivity;

        // Accumulate target rotations from input
        targetYawRotation += mouseX;
        targetXRotation -= mouseY;
        targetXRotation = Mathf.Clamp(targetXRotation, -90f, 90f);

        // Smoothly interpolate to target rotations
        yawRotation = Mathf.Lerp(yawRotation, targetYawRotation, lookDamping);
        xRotation = Mathf.Lerp(xRotation, targetXRotation, lookDamping);

        transform.localRotation = Quaternion.Euler(0f, yawRotation, 0f);
        playerCamera.localRotation = Quaternion.Euler(xRotation, 0f, 0f);
    }

    void HandleMovement()
    {
        if (grappling) return;
        float targetSpeed = _input.SprintHeld ? sprintSpeed : walkSpeed;

        if (inputDir.sqrMagnitude > 0.01f)
        { 
            Vector3 currentVelocity = new Vector3(rb.linearVelocity.x, 0f, rb.linearVelocity.z);
            
            if (grounded) // Can you accelerate in the air?
            {
                if(currentSpeed < targetSpeed) 
                {
                    currentSpeed += acceleration * (targetSpeed/walkSpeed); // Does sprinting increase acceleration or just max speed
                }

                if (new Vector2(currentVelocity.x, currentVelocity.z).sqrMagnitude > targetSpeed*targetSpeed) 
                {
                    ApplyFriction();
                }
            }

            // Less control in the air
            float modifier = grounded || (grappling && wallDetector != null && wallDetector.nearWall) ? 10 : airControl;
            
            Vector3 desiredVel = inputDir * currentSpeed;
            Vector3 forceDir = (desiredVel - currentVelocity) * modifier;
            rb.AddForce(forceDir, ForceMode.Force);
        }
        else if (grounded)
        {
            ApplyFriction(); 
        }
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
        // low friction → keeps momentum
        Vector3 horizontalVel = new Vector3(rb.linearVelocity.x, 0f, rb.linearVelocity.z);
        Vector3 slideFriction = -horizontalVel * groundFriction * slideFrictionAdjustment;
        rb.AddForce(slideFriction, ForceMode.Acceleration);
    }

    void HandleWallRunMovement()    //Controls when wallrunning
    {
        Vector3 wallNormal = wallDetector.wallNormal;   // get wall normal from detector

        Vector3 wallForward = Vector3.Cross(Vector3.up, wallNormal).normalized; // direction along the wall

        rb.AddForce(-wallDetector.wallNormal * wallStickForce, ForceMode.Force);    // stick to wall

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

    void StartSlide()
    {
        isSliding = true;
        slideTimer = slideDuration;
        slideRefresh = slideCooldown;

        // shrink collider
        capsule.height = slideHeight;
        capsule.center = new Vector3(originalColliderCenter.x, slideHeight / 2f, originalColliderCenter.z);

        // lower camera
        playerCamera.localPosition += new Vector3(0f, cameraSlideHeightAdjust, 0f);

        // small forward impulse
        rb.AddForce(transform.forward * 2f, ForceMode.Impulse);
    }

    void WallRun()  //Handles physics and setup for wallrunning when initiated in air near a wall
    {
        Vector3 wallNormal = wallDetector.wallNormal;
        isSliding = true;
        slideRefresh = slideCooldown;
        slideTimer = wallrunTimer; // longer slide duration for wallrun

        // shrink collider
        capsule.height = slideHeight;
        capsule.center = new Vector3(originalColliderCenter.x, slideHeight / 2f, originalColliderCenter.z);

        // lower camera
        playerCamera.localPosition = originalCameraLocalPos + new Vector3(0f, cameraSlideHeightAdjust, 0f);

        // optional small boost
        rb.AddForce(transform.forward * 2f, ForceMode.Impulse);

        // Get direction along the wall
        Vector3 wallForward = Vector3.Cross(Vector3.up, wallNormal).normalized;

        // Flip if opposite to facing direction
        if (Vector3.Dot(wallForward, transform.forward) < 0f)
        {
            wallForward = -wallForward;
        }

        wallRunDirection = wallForward;
    }

    void StopSlide()
    {
        isWallRunning = false; // stop wallrun if we were wallrunning
        isSliding = false;

        // restore collider
        capsule.height = originalColliderHeight;
        capsule.center = originalColliderCenter;

        // restore camera
        playerCamera.localPosition = originalCameraLocalPos;
    }

    void Jump(Vector3 direction)
    {
        rb.linearVelocity = new Vector3(rb.linearVelocity.x, 0f, rb.linearVelocity.z);
        rb.AddForce(direction * jumpForce, ForceMode.Impulse);

        if (isSliding) StopSlide(); // jump cancels slide
    }

    void WallJump()
    {
        if (wallDetector == null || wallDetector.wallNormal == Vector3.zero) return;

        Vector3 jumpDir = wallDetector.wallNormal * wallPushAwayForce + Vector3.up * wallPushUpForce;
        Jump(jumpDir);
    }

    

    void GroundCheck()
    {
        grounded = Physics.Raycast(transform.position, Vector3.down, groundCheckDistance, groundMask);
    }
}
