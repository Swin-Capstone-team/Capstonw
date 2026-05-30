using UnityEngine;

public interface IMovementState
{
    void Enter(MovementManager manager);
    void Exit();
    void HandleInput();
    void FixedUpdateState();
}
