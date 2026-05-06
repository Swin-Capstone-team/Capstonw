using UnityEngine;
using Cinemachine;

public class SprintCameraZoom : MonoBehaviour
{
    public CinemachineVirtualCamera vcam;
    public Rigidbody playerRigidbody;

    private Cinemachine3rdPersonFollow follow;

    [Header("Zoom Settings")]
    public float normalDistance = 5f;
    public float sprintDistance = 3f;
    public float speedThreshold = 10f;
    public float zoomSpeed = 5f;

    void Start()
    {
        follow = vcam.GetCinemachineComponent<Cinemachine3rdPersonFollow>();
    }

    void Update()
    {
        bool isFast = playerRigidbody != null && playerRigidbody.linearVelocity.magnitude >= speedThreshold;

        float targetDistance = isFast ? sprintDistance : normalDistance;

        follow.CameraDistance = Mathf.Lerp(
            follow.CameraDistance,
            targetDistance,
            Time.deltaTime * zoomSpeed
        );
    }
}