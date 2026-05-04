using UnityEngine;
using UnityEngine.InputSystem;

public class CameraMove : MonoBehaviour
{
    public float sensitivity = 0.12f;
    public float minPitch = -20f;
    public float maxPitch = 45f;

    private float yaw;
    private float pitch;

    private PlayerInputState _input;

    void Awake()
    {
        _input ??= GetComponentInParent<PlayerInputState>();

        if (_input != null) return;

        Debug.LogError("PlayerMove requires PlayerInputState on this object or a parent.", this);
        enabled = false;
    }

    void Start()
    {
        Vector3 angles = transform.localEulerAngles;
        yaw = angles.y;
        pitch = 10f;

        Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false;
    }

    void LateUpdate()
    {
        yaw += _input.Look.x * sensitivity;
        pitch -= _input.Look.y * sensitivity;
        pitch = Mathf.Clamp(pitch, minPitch, maxPitch);

        // transform.localRotation = Quaternion.Euler(pitch, yaw, 0f);
        transform.localRotation = Quaternion.Euler(pitch, 0f, 0f);
    }
}