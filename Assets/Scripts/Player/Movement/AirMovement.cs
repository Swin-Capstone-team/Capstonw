using UnityEngine;

[DisallowMultipleComponent]
public class AirMovement : MonoBehaviour, IMovementState
{
    private MovementManager mgr;
    private Vector3 lastInputDir = Vector3.zero;

    public void Enter(MovementManager manager)
    {
        mgr = manager;
    }

    public void Exit()
    {
        mgr = null;
    }

    public void HandleInput()
    {
        if (mgr == null || mgr.Input == null) return;

        // Parse input direction for air strafing
        Vector2 move = mgr.Input.Move;
        lastInputDir = mgr.GetMoveDirection(move);
    }

    public void FixedUpdateState()
    {
        if (mgr == null) return;

        // Drag handling (in air)
        mgr.Rb.linearDamping = 0f;

        if (mgr.IsGrappling && !mgr.IsSlingshotting && !mgr.IsGrounded)
        {
            return;
        }

        // Apply air movement force
        if (lastInputDir.sqrMagnitude > 0.01f)
        {
            // Use walkSpeed as base, apply airMultiplier
            mgr.Rb.AddForce(lastInputDir.normalized * mgr.Settings.walkSpeed * 10f * mgr.Settings.airMultiplier, ForceMode.Force);
        }

        // Speed Control
        Vector3 flatVel = new Vector3(mgr.Rb.linearVelocity.x, 0f, mgr.Rb.linearVelocity.z);
        if (flatVel.magnitude > mgr.Settings.airMaxSpeed)
        {
            Vector3 limitedVel = flatVel.normalized * mgr.Settings.airMaxSpeed;
            mgr.Rb.linearVelocity = new Vector3(limitedVel.x, mgr.Rb.linearVelocity.y, limitedVel.z);
        }
    }
}
