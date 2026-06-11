using UnityEngine;

public class SnapshotAnimator : MonoBehaviour
{
    public Animator animator;
    public CharacterController characterController;
    
    [Header("Run Settings")]
    public float stepInterval = 0.15f;
    public float sprintStepInterval = 0.1f;
    private float stepTimer;
    private bool isRightFootForward = true;
    private string currentState = "";

    private void Update()
    {
        if (characterController == null || characterController.Motor == null) return;

        bool isGrounded = characterController.Motor.GroundingStatus.IsStableOnGround;
        Vector3 horizontalVelocity = characterController.Motor.Velocity;
        horizontalVelocity.y = 0;
        bool isMoving = horizontalVelocity.magnitude > 0.1f && characterController.HasMoveInput;

        if (characterController.CurrentCharacterState == CharacterState.Grappling)
        {
            PlayGrapple();
        }
        else if (!isGrounded)
        {
            ChangeAnimation("Jump");
        }
        else if (characterController.IsSliding)
        {
            ChangeAnimation("Slide");
        }
        else if (characterController.IsCrouching)
        {
            PlayCrouch(isMoving);
        }
        else if (isMoving)
        {
            PlayRun(characterController.IsSprinting);
        }
        else
        {
            ChangeAnimation("Idle");
        }
    }

    private void ChangeAnimation(string stateName)
    {
        if (currentState == stateName) return;
        currentState = stateName;
        animator.Play(stateName);
    }

    public void PlayIdle() => ChangeAnimation("Idle");
    public void PlayJump() => ChangeAnimation("Jump");
    public void PlayCrouch() => ChangeAnimation("Crouch_Idle");
    public void PlayCrouchMove() => ChangeAnimation("Crouch_Move");
    public void PlaySlide() => ChangeAnimation("Slide");
    public void PlayShoot() => ChangeAnimation("Shoot");
    public void PlayGrapple() => ChangeAnimation("Grapple");

    private void PlayCrouch(bool isMoving)
    {
        if (isMoving) PlayCrouchMove();
        else PlayCrouch();
    }

    public void PlayRun(bool isSprinting = false)
    {
        if (isSprinting) ChangeAnimation("Sprint");
        else ChangeAnimation("Run");
    }
}