using UnityEngine;
using Cinemachine;

public class SprintCameraZoom : MonoBehaviour
{
    [Header("Camera")]
    public CinemachineFreeLook freeLookCam;

    [Header("Player")]
    public Rigidbody playerRigidbody;
    public KeyCode sprintKey = KeyCode.LeftShift;

    [Header("Zoom")]
    public float normalRadius = 5f;
    public float sprintRadius = 4f;

    [Header("Settings")]
    public float speedThreshold = 1f;
    public float zoomSpeed = 5f;

    void Update()
    {
        if (freeLookCam == null || playerRigidbody == null)
            return;

        bool isMoving = playerRigidbody.linearVelocity.magnitude > speedThreshold;
        bool isSprinting = Input.GetKey(sprintKey) && isMoving;

        float targetRadius = isSprinting ? sprintRadius : normalRadius;

        for (int i = 0; i < 3; i++)
        {
            var orbit = freeLookCam.m_Orbits[i];
            orbit.m_Radius = Mathf.Lerp(
                orbit.m_Radius,
                targetRadius,
                Time.deltaTime * zoomSpeed
            );
            freeLookCam.m_Orbits[i] = orbit;
        }

        Debug.Log("Sprint Zoom: " + isSprinting + " Radius: " + freeLookCam.m_Orbits[1].m_Radius);
    }
}