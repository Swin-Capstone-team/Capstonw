using UnityEngine;

[DisallowMultipleComponent]
public class MovementSettings : MonoBehaviour
{
    private const float MinPositiveValue = 0.01f;

    [Header("References")]
    public Transform orientation;
    public Animator animator;
    public WallDetector wallDetector;

    [Header("Ground")]
    [Min(0f)]
    public float walkSpeed = 7f;

    [Min(0f)]
    public float sprintSpeed = 12f;

    [Min(0f)]
    public float acceleration = 1f;

    [Min(0f)]
    public float groundFriction = 12f;

    [Min(0f)]
    public float groundMoveForce = 10f;

    [Range(0f, 1f)]
    public float moveInputThreshold = 0.1f;

    [Header("Air")]
    [Min(0f)]
    public float airMaxSpeed = 7f;

    [Min(0f)]
    public float airMultiplier = 0.4f;

    [Header("Slide")]
    [Min(0f)]
    public float slideSpeedBoost = 1.5f;

    [Min(0f)]
    public float slideCooldown = 0.5f;

    [Min(0.01f)]
    public float slideDecayDuration = 1.5f;

    [Min(0f)]
    public float slideStopSpeed = 0.05f;

    [Range(0f, 90f)]
    public float slideStopSurfaceAngle = 60f;

    [Range(0f, 89f)]
    public float slideStopUphillAngle = 25f;

    [Min(0f)]
    public float slideRequireSpeed = 0f;

    [Min(0f)]
    public float autoSprintSpeed = 0f;

    [Range(0f, 45f)]
    public float flatGroundAngleThreshold = 2f;

    [Header("Jump")]
    [Min(0f)]
    public float jumpForce = 12f;

    [Min(0f)]
    public float wallPushAwayForce = 5f;

    [Min(0f)]
    public float wallPushUpForce = 3f;

    [Min(0f)]
    public float wallJumpDirectionMultiplier = 1.5f;

    [Header("Gravity")]
    [Min(0f)]
    public float fallMultiplier = 3.5f;

    [Min(0f)]
    public float lowJumpMultiplier = 4.5f;

    [Min(0f)]
    public float upwardMultiplier = 2f;

    [Header("Animation")]
    [Min(0f)]
    public float animationTurnRateThreshold = 5f;

    [Min(0f)]
    public float animationDampTime = 0.1f;

    [Header("Ground Check")]
    public LayerMask groundMask = 64;

    [Min(0.01f)]
    public float groundCheckDistance = 0.5f;

    private void OnValidate()
    {
        walkSpeed = Mathf.Max(0f, walkSpeed);
        sprintSpeed = Mathf.Max(walkSpeed, sprintSpeed);
        acceleration = Mathf.Max(0f, acceleration);
        groundFriction = Mathf.Max(0f, groundFriction);
        groundMoveForce = Mathf.Max(0f, groundMoveForce);
        moveInputThreshold = Mathf.Clamp01(moveInputThreshold);

        airMaxSpeed = Mathf.Max(0f, airMaxSpeed);
        airMultiplier = Mathf.Max(0f, airMultiplier);

        slideSpeedBoost = Mathf.Max(0f, slideSpeedBoost);
        slideCooldown = Mathf.Max(0f, slideCooldown);
        slideDecayDuration = Mathf.Max(MinPositiveValue, slideDecayDuration);
        slideStopSpeed = Mathf.Max(0f, slideStopSpeed);
        slideStopSurfaceAngle = Mathf.Clamp(slideStopSurfaceAngle, 0f, 90f);
        slideStopUphillAngle = Mathf.Clamp(slideStopUphillAngle, 0f, 89f);
        slideRequireSpeed = Mathf.Max(0f, slideRequireSpeed);
        autoSprintSpeed = Mathf.Max(0f, autoSprintSpeed);
        flatGroundAngleThreshold = Mathf.Clamp(flatGroundAngleThreshold, 0f, 45f);

        jumpForce = Mathf.Max(0f, jumpForce);
        wallPushAwayForce = Mathf.Max(0f, wallPushAwayForce);
        wallPushUpForce = Mathf.Max(0f, wallPushUpForce);
        wallJumpDirectionMultiplier = Mathf.Max(0f, wallJumpDirectionMultiplier);

        fallMultiplier = Mathf.Max(0f, fallMultiplier);
        lowJumpMultiplier = Mathf.Max(0f, lowJumpMultiplier);
        upwardMultiplier = Mathf.Max(0f, upwardMultiplier);

        animationTurnRateThreshold = Mathf.Max(0f, animationTurnRateThreshold);
        animationDampTime = Mathf.Max(0f, animationDampTime);

        groundCheckDistance = Mathf.Max(MinPositiveValue, groundCheckDistance);
    }
}
