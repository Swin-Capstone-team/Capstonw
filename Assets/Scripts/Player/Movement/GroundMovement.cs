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
            mgr.SetSprintLatched(true);
        }

        if (mgr.Input.CrouchPressedThisFrame)
        {
            mgr.TryStartSlide();
        }

        // Clear latch when no input
        if (!hasMoveInput)
        {
            mgr.SetSprintLatched(false);
        }
    }

    public void FixedUpdateState()
    {
        if (mgr == null) return;

        bool isSprinting = (mgr.Input != null && mgr.Input.SprintHeld) || mgr.IsSprintLatched;
        float targetSpeed = isSprinting ? mgr.Settings.sprintSpeed : mgr.Settings.walkSpeed;

        // Drag handling (on ground)
        mgr.Rb.linearDamping = mgr.Settings.groundFriction;

        // Apply movement force
        if (lastInputDir.sqrMagnitude > 0.01f)
        {
            mgr.Rb.AddForce(lastInputDir.normalized * targetSpeed * 10f, ForceMode.Force);
        }

        // Speed Control
        Vector3 flatVel = new Vector3(mgr.Rb.linearVelocity.x, 0f, mgr.Rb.linearVelocity.z);
        if (flatVel.magnitude > targetSpeed)
        {
            Vector3 limitedVel = flatVel.normalized * targetSpeed;
            mgr.Rb.linearVelocity = new Vector3(limitedVel.x, mgr.Rb.linearVelocity.y, limitedVel.z);
        }
    }
}
