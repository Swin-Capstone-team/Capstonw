using UnityEngine;
using Cinemachine;

public class SprintCameraZoom : MonoBehaviour
{
    public CinemachineFreeLook follow;
    public Rigidbody playerRigidbody;

    [Header("Zoom Settings")]
    public float normalDistance = 5f;
    public float sprintDistance = 3f;
    public float speedThreshold = 10f;
    public float zoomSpeed = 5f;

    void Update()
    {
        bool isFast = playerRigidbody != null && playerRigidbody.linearVelocity.magnitude >= speedThreshold;

        float targetDistance = isFast ? sprintDistance : normalDistance;

        follow.m_Orbits[0].m_Radius = Mathf.Lerp(
            follow.m_Orbits[0].m_Radius,
            targetDistance,
            Time.deltaTime * zoomSpeed
        );
        follow.m_Orbits[1].m_Radius = Mathf.Lerp(
            follow.m_Orbits[1].m_Radius,
            targetDistance,
            Time.deltaTime * zoomSpeed
        );
        follow.m_Orbits[2].m_Radius = Mathf.Lerp(
            follow.m_Orbits[2].m_Radius,
            targetDistance,
            Time.deltaTime * zoomSpeed
        );
        follow.m_Orbits[2].m_Radius = Mathf.Lerp(
            follow.m_Orbits[2].m_Radius,
            targetDistance,
            Time.deltaTime * zoomSpeed
        );
    }
}