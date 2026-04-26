using UnityEngine;
using UnityEngine.InputSystem;

[DisallowMultipleComponent]
public class PlayerInputState : MonoBehaviour
{
    [Header("Debug")]
    [SerializeField] private bool logActionPresses = false;

    private InputSystem_Actions _actions;

    public Vector2 Move => _actions.Player.Move.ReadValue<Vector2>();
    public Vector2 Look => _actions.Player.Look.ReadValue<Vector2>();

    public bool JumpHeld => _actions.Player.Jump.IsPressed();
    public bool JumpPressedThisFrame => _actions.Player.Jump.WasPressedThisFrame();

    public bool SprintHeld => _actions.Player.Sprint.IsPressed();

    public bool CrouchPressedThisFrame => _actions.Player.Crouch.WasPressedThisFrame();
    public bool CrouchReleasedThisFrame => _actions.Player.Crouch.WasReleasedThisFrame();

    public bool LeftSwingHeld => _actions.Player.LeftSwing.IsPressed();
    public bool LeftSwingPressedThisFrame => _actions.Player.LeftSwing.WasPressedThisFrame();
    public bool LeftSwingReleasedThisFrame => _actions.Player.LeftSwing.WasReleasedThisFrame();

    public bool RightSwingHeld => _actions.Player.RightSwing.IsPressed();
    public bool RightSwingPressedThisFrame => _actions.Player.RightSwing.WasPressedThisFrame();
    public bool RightSwingReleasedThisFrame => _actions.Player.RightSwing.WasReleasedThisFrame();

    public bool AttackPressedThisFrame => _actions.Player.Attack.WasPressedThisFrame();


    private void LogActionPress(InputAction action, string actionName)
    {
        if (!logActionPresses || !action.WasPressedThisFrame()) return;
        Debug.Log($"Input pressed: {actionName}", this);
    }

    private void Awake()
    {
        _actions = new InputSystem_Actions();
    }

    private void OnEnable()
    {
        _actions.Player.Enable();
    }

    private void OnDisable()
    {
        _actions.Player.Disable();
    }

    private void Update()
    {
        LogActionPress(_actions.Player.Move, "Move");
        LogActionPress(_actions.Player.Look, "Look");
        LogActionPress(_actions.Player.Jump, "Jump");
        LogActionPress(_actions.Player.Sprint, "Sprint");
        LogActionPress(_actions.Player.Crouch, "Crouch");
        LogActionPress(_actions.Player.LeftSwing, "LeftSwing");
        LogActionPress(_actions.Player.RightSwing, "RightSwing");
        LogActionPress(_actions.Player.Attack, "Attack");
    }
}

