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

        Vector2 move = mgr.Input.Move;
        lastInputDir = mgr.GetMoveDirection(move);
    }

    public void FixedUpdateState()
    {
        if (mgr == null) return;

        // No air drag
        mgr.Rb.linearDamping = 0f;

        if (mgr.IsGrappling && !mgr.IsSlingshotting && !mgr.IsGrounded)
        {
            return;
        }

        if (lastInputDir.sqrMagnitude > 0.01f)
        {
            Vector3 flatVel = new Vector3(
                mgr.Rb.linearVelocity.x,
                0f,
                mgr.Rb.linearVelocity.z
            );

            // Increase this if you want even snappier air control
            float airControlStrength = mgr.Settings.walkSpeed * 25f * mgr.Settings.airMultiplier;

            Vector3 desiredVel = lastInputDir.normalized * mgr.Settings.airMaxSpeed;

            Vector3 newFlatVel = Vector3.MoveTowards(
                flatVel,
                desiredVel,
                airControlStrength * Time.fixedDeltaTime
            );

            mgr.Rb.linearVelocity = new Vector3(
                newFlatVel.x,
                mgr.Rb.linearVelocity.y,
                newFlatVel.z
            );
        }

        // Speed cap
        Vector3 currentFlatVel = new Vector3(
            mgr.Rb.linearVelocity.x,
            0f,
            mgr.Rb.linearVelocity.z
        );

        if (currentFlatVel.magnitude > mgr.Settings.airMaxSpeed)
        {
            Vector3 limitedVel = currentFlatVel.normalized * mgr.Settings.airMaxSpeed;

            mgr.Rb.linearVelocity = new Vector3(
                limitedVel.x,
                mgr.Rb.linearVelocity.y,
                limitedVel.z
            );
        }
    }
}
