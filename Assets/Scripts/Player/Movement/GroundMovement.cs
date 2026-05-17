using UnityEngine;

[DisallowMultipleComponent]
public class GroundMovement : MonoBehaviour, IMovementState
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

        // Parse input direction for use in FixedUpdate
        Vector2 move = mgr.Input.Move;
        lastInputDir = mgr.GetMoveDirection(move);
        bool hasMoveInput = mgr.HasMeaningfulMoveInput(move);

        // Latch sprint when held while moving
        if (mgr.Input.SprintHeld && hasMoveInput)
        {
            mgr.sprintLatched = true;
        }

        if (mgr.Input.CrouchPressedThisFrame)
        {
            mgr.TryStartSlide();
        }

        // Clear latch when no input
        if (!hasMoveInput)
        {
            mgr.sprintLatched = false;
        }
    }

    public void FixedUpdateState()
    {
        if (mgr == null) return;

        Vector3 currentHorizontal = new Vector3(mgr.Rb.linearVelocity.x, 0f, mgr.Rb.linearVelocity.z);
        bool isSprinting = (mgr.Input != null && mgr.Input.SprintHeld) || mgr.sprintLatched;
        float targetSpeed = isSprinting ? mgr.Settings.sprintSpeed : mgr.Settings.walkSpeed;

        // Handle acceleration
        if (mgr.currentSpeed < targetSpeed)
        {
            mgr.currentSpeed += mgr.Settings.acceleration * (targetSpeed / mgr.Settings.walkSpeed);
        }

        // Handle friction when exceeding target speed
        float horizSpeedSqr = new Vector2(currentHorizontal.x, currentHorizontal.z).sqrMagnitude;
        if (horizSpeedSqr > targetSpeed * targetSpeed)
        {
            Vector3 frictionForce = -currentHorizontal * mgr.Settings.groundFriction;
            mgr.Rb.AddForce(frictionForce, ForceMode.Acceleration);
        }

        // Apply movement force
        if (lastInputDir.sqrMagnitude > 0.01f)
        {
            Vector3 desiredVel = lastInputDir * mgr.currentSpeed;
            Vector3 forceDir = desiredVel - currentHorizontal;
            mgr.Rb.AddForce(forceDir * mgr.Settings.groundMoveForce, ForceMode.Force);
        }
        else if (horizSpeedSqr > 0.0001f)
        {
            // No input but still moving: apply friction
            Vector3 frictionForce = -currentHorizontal * mgr.Settings.groundFriction;
            mgr.Rb.AddForce(frictionForce, ForceMode.Acceleration);
            mgr.currentSpeed = currentHorizontal.magnitude;
        }
    }
}
