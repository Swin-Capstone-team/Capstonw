using UnityEngine;

public sealed class MovementAnimationDriver
{
    private const float MinDeltaTime = 0.0001f;
    private const float MinSpeedNormalization = 0.01f;

    private static readonly int IsMovingHash = Animator.StringToHash("IsMoving");
    private static readonly int VelocityXHash = Animator.StringToHash("VelocityX");
    private static readonly int VelocityZHash = Animator.StringToHash("VelocityZ");
    private static readonly int IsGroundedHash = Animator.StringToHash("IsGrounded");
    private static readonly int VerticalVelocityHash = Animator.StringToHash("VerticalVelocity");
    private static readonly int IsTurningHash = Animator.StringToHash("IsTurning");
    private static readonly int TurnHash = Animator.StringToHash("Turn");
    private static readonly int JumpHash = Animator.StringToHash("Jump");

    private float lastYaw;
    private bool hasLastYaw;

    public void ResetYaw(Transform referenceTransform)
    {
        if (referenceTransform == null)
        {
            hasLastYaw = false;
            lastYaw = 0f;
            return;
        }

        lastYaw = referenceTransform.eulerAngles.y;
        hasLastYaw = true;
    }

    public void TriggerJump(MovementSettings settings)
    {
        settings?.animator?.SetTrigger(JumpHash);
    }

    public void Sync(MovementManager manager)
    {
        if (manager == null || manager.Settings == null || manager.Settings.animator == null || manager.Rb == null)
        {
            return;
        }

        Animator animator = manager.Settings.animator;
        Transform referenceTransform = manager.Orientation;
        Vector3 localVelocity = referenceTransform.InverseTransformDirection(manager.Rb.linearVelocity);
        float speedNormalization = Mathf.Max(MinSpeedNormalization, manager.Settings.sprintSpeed);
        float dampTime = manager.Settings.animationDampTime;
        bool isMoving = manager.Input != null && manager.HasMeaningfulMoveInput(manager.Input.Move);

        animator.SetBool(IsMovingHash, isMoving);
        animator.SetFloat(VelocityXHash, localVelocity.x / speedNormalization, dampTime, Time.deltaTime);
        animator.SetFloat(VelocityZHash, localVelocity.z / speedNormalization, dampTime, Time.deltaTime);
        animator.SetBool(IsGroundedHash, manager.IsGrounded);
        animator.SetFloat(VerticalVelocityHash, manager.Rb.linearVelocity.y);

        float currentYaw = referenceTransform.eulerAngles.y;
        if (!hasLastYaw)
        {
            lastYaw = currentYaw;
            hasLastYaw = true;
        }

        float rawTurnRate = Mathf.DeltaAngle(lastYaw, currentYaw) / Mathf.Max(Time.deltaTime, MinDeltaTime);
        animator.SetBool(IsTurningHash, Mathf.Abs(rawTurnRate) > manager.Settings.animationTurnRateThreshold);
        animator.SetFloat(TurnHash, Mathf.Clamp(rawTurnRate / 180f, -1f, 1f), dampTime, Time.deltaTime);

        lastYaw = currentYaw;
    }
}
