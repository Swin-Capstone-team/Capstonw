using UnityEngine;

public sealed class VerticalMovementController
{
    public void HandleJumpInput(MovementManager manager)
    {
        if (manager == null || manager.Input == null || !manager.Input.JumpPressedThisFrame)
        {
            return;
        }

        if (manager.IsGrounded)
        {
            Jump(manager, Vector3.up);
        }
        else if (manager.Settings.wallDetector != null && manager.Settings.wallDetector.nearWall)
        {
            WallJump(manager);
        }
    }

    public void ApplyGravityModifiers(MovementManager manager)
    {
        if (manager == null || manager.Rb == null || !manager.Rb.useGravity)
        {
            return;
        }

        if (manager.Rb.linearVelocity.y < 0f)
        {
            manager.Rb.AddForce(Vector3.up * Physics.gravity.y * (manager.Settings.fallMultiplier - 1f), ForceMode.Acceleration);
        }
        else if (manager.Rb.linearVelocity.y > 0f)
        {
            if (manager.Input != null && !manager.Input.JumpHeld)
            {
                manager.Rb.AddForce(Vector3.up * Physics.gravity.y * (manager.Settings.lowJumpMultiplier - 1f), ForceMode.Acceleration);
            }
            else
            {
                manager.Rb.AddForce(Vector3.up * Physics.gravity.y * (manager.Settings.upwardMultiplier - 1f), ForceMode.Acceleration);
            }
        }
    }

    private void Jump(MovementManager manager, Vector3 direction)
    {
        Rigidbody rb = manager.Rb;
        rb.linearVelocity = new Vector3(rb.linearVelocity.x, 0f, rb.linearVelocity.z);
        rb.AddForce(direction * manager.Settings.jumpForce, ForceMode.Impulse);
        manager.OnJumpExecuted();
    }

    private void WallJump(MovementManager manager)
    {
        Vector3 wallNormal = manager.Settings.wallDetector.wallNormal;
        if (wallNormal == Vector3.zero)
        {
            return;
        }

        Vector3 jumpDir = (wallNormal * manager.Settings.wallPushAwayForce + Vector3.up * manager.Settings.wallPushUpForce).normalized;
        Jump(manager, jumpDir * manager.Settings.wallJumpDirectionMultiplier);
    }
}
