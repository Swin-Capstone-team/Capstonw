using UnityEngine;
using Cinemachine;

public class SprintCameraZoom : MonoBehaviour
{
    public CinemachineVirtualCamera vcam;

    private Cinemachine3rdPersonFollow follow;

    [Header("Zoom Settings")]
    public float normalDistance = 5f;
    public float sprintDistance = 3f;
    public float zoomSpeed = 5f;

    void Start()
    {
        follow = vcam.GetCinemachineComponent<Cinemachine3rdPersonFollow>();
    }

    void Update()
    {
        bool isSprinting = Input.GetKey(KeyCode.LeftShift);

        float targetDistance = isSprinting ? sprintDistance : normalDistance;

        follow.CameraDistance = Mathf.Lerp(
            follow.CameraDistance,
            targetDistance,
            Time.deltaTime * zoomSpeed
        );
    }
}