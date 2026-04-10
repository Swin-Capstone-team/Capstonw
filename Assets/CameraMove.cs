using UnityEngine;
using UnityEngine.InputSystem;

public class CameraMove : MonoBehaviour
{
    public Transform player;
    public float sensitivity = 0.12f;
    public float minPitch = -20f;
    public float maxPitch = 45f;

    private float yaw;
    private float pitch;

    void Start()
    {
        yaw = player.eulerAngles.y;
        pitch = 10f; // slight downward look
        transform.localRotation = Quaternion.Euler(pitch, 0f, 0f);

        Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false;
    }

    void LateUpdate()
    {
        if (Mouse.current == null || player == null) return;

        Vector2 mouseDelta = Mouse.current.delta.ReadValue();

        yaw += mouseDelta.x * sensitivity;
        pitch -= mouseDelta.y * sensitivity;
        pitch = Mathf.Clamp(pitch, minPitch, maxPitch);

        player.rotation = Quaternion.Euler(0f, yaw, 0f);
        transform.localRotation = Quaternion.Euler(pitch, 0f, 0f);
    }
}