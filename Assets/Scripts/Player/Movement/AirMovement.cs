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

        if (mgr.IsGrappling && !mgr.IsSlingshotting && !mgr.IsGrounded)
        {
            mgr.SetCurrentSpeed(Mathf.Min(mgr.Rb.linearVelocity.magnitude, mgr.Settings.airMaxSpeed));
            return;
        }

        Vector3 currentHorizontal = new Vector3(mgr.Rb.linearVelocity.x, 0f, mgr.Rb.linearVelocity.z);

        // Air strafing: add acceleration in input direction if below max
        if (lastInputDir.sqrMagnitude > 0.01f)
        {
            float projVel = Vector3.Dot(currentHorizontal, lastInputDir);
            float addSpeed = mgr.Settings.airMaxSpeed - projVel;

            if (addSpeed > 0)
            {
                mgr.Rb.AddForce(lastInputDir * mgr.Settings.airAcceleration, ForceMode.Acceleration);
            }
        }
    }
}
