using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using KinematicCharacterController;

public class Player : MonoBehaviour
{
    public CharacterController Character;
    public CharacterCamera CharacterCamera;

    private InputSystem_Actions _actions;

    private void Start()
    {
        _actions = GetComponent<PlayerInputState>().GetPlayerActions();
        Cursor.lockState = CursorLockMode.Locked;

        // Tell camera to follow transform
        CharacterCamera.SetFollowTransform(Character.CameraFollowPoint);

        // Ignore the character's collider(s) for camera obstruction checks
        CharacterCamera.IgnoredColliders.Clear();
        CharacterCamera.IgnoredColliders.AddRange(Character.GetComponentsInChildren<Collider>());
    }

    private void Update()
    {
        if (_actions.Player.Shoot.WasPressedThisFrame())
        {
            Cursor.lockState = CursorLockMode.Locked;
        }

        HandleCharacterInput();
    }

    private void LateUpdate()
    {
        // Handle rotating the camera along with physics movers
        if (CharacterCamera.RotateWithPhysicsMover && Character.Motor.AttachedRigidbody != null)
        {
            CharacterCamera.PlanarDirection = Character.Motor.AttachedRigidbody.GetComponent<PhysicsMover>().RotationDeltaFromInterpolation * CharacterCamera.PlanarDirection;
            CharacterCamera.PlanarDirection = Vector3.ProjectOnPlane(CharacterCamera.PlanarDirection, Character.Motor.CharacterUp).normalized;
        }

        HandleCameraInput();
    }

    private void HandleCameraInput()
    {
        Vector2 look = _actions.Player.Look.ReadValue<Vector2>();

        // Create the look input vector for the camera
        float mouseLookAxisUp = look.y;
        float mouseLookAxisRight = look.x;
        Vector3 lookInputVector = new Vector3(mouseLookAxisRight, mouseLookAxisUp, 0f);

        // Prevent moving the camera while the cursor isn't locked
        if (Cursor.lockState != CursorLockMode.Locked)
        {
            lookInputVector = Vector3.zero;
        }

        float scrollInput = 0f;

        // Apply inputs to the camera
        CharacterCamera.UpdateWithInput(Time.deltaTime, scrollInput, lookInputVector);
    }

    private void HandleCharacterInput()
    {
        PlayerCharacterInputs characterInputs = new PlayerCharacterInputs();

        Vector2 move = _actions.Player.Move.ReadValue<Vector2>();

        // Build the CharacterInputs struct
        characterInputs.MoveAxisForward = move.y;
        characterInputs.MoveAxisRight = move.x;
        characterInputs.CameraRotation = CharacterCamera.Transform.rotation;
        characterInputs.JumpDown = _actions.Player.Jump.WasPressedThisFrame();
        characterInputs.CrouchDown = _actions.Player.Crouch.WasPressedThisFrame();
        characterInputs.CrouchUp = _actions.Player.Crouch.WasReleasedThisFrame();
        characterInputs.IsSprinting = _actions.Player.Sprint.IsPressed();
        characterInputs.GrappleDown = _actions.Player.Grapple.WasPressedThisFrame();

        // Apply inputs to character
        Character.SetInputs(ref characterInputs);
    }
}