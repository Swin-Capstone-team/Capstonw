using UnityEngine;
using Cinemachine;

[RequireComponent(typeof(CinemachineVirtualCamera), typeof(CinemachineImpulseListener))]
[DisallowMultipleComponent]
public class CameraShake : MonoBehaviour
{
    [SerializeField] private float sprintNoiseMultiplier = 0.35f;
    [SerializeField] private float noiseFadeSpeed = 12f;
    [SerializeField] private float landImpulseForce = 0.35f;
    [SerializeField] private float maxLandImpulseForce = 1.2f;
    [SerializeField] private float landingSpeedForMaxImpulse = 18f;
    [SerializeField] private AnimationCurve landingImpulseCurve = AnimationCurve.EaseInOut(0f, 0f, 1f, 1f);

    private PlayerInputState playerInput;
    private CinemachineBasicMultiChannelPerlin noise;
    private CinemachineImpulseSource impulseSource;
    private float baseAmplitudeGain;
    private float currentAmplitudeGain;

    private void Awake()
    {
        playerInput = GetComponentInParent<PlayerInputState>();
        if (playerInput == null)
        {
            Debug.LogError("CameraShake requires PlayerInputState assigned in the Inspector or as a parent.", this);
            enabled = false;
            return;
        }

        var virtualCamera = GetComponent<CinemachineVirtualCamera>();
        noise = virtualCamera.GetCinemachineComponent<CinemachineBasicMultiChannelPerlin>();
        if (noise == null)
        {
            Debug.LogError("CameraShake requires a Cinemachine Basic Multi Channel Perlin noise component.", this);
            enabled = false;
            return;
        }

        impulseSource = playerInput.GetComponent<CinemachineImpulseSource>();

        baseAmplitudeGain = noise.m_AmplitudeGain;
        currentAmplitudeGain = 0f;
        noise.m_AmplitudeGain = 0f;

    }

    private void LateUpdate()
    {
        if (!enabled) return;

        float targetAmplitudeGain = playerInput.SprintHeld ? baseAmplitudeGain * sprintNoiseMultiplier : 0f;
        currentAmplitudeGain = Mathf.MoveTowards(currentAmplitudeGain, targetAmplitudeGain, noiseFadeSpeed * Time.deltaTime);
        noise.m_AmplitudeGain = currentAmplitudeGain;
    }

    // Jump shake removed — landing-only impulses are used.

    public void PlayLandingShake(float fallSpeed)
    {
        if (!enabled)
        {
            Debug.Log("PlayLandingShake called but CameraShake is disabled.", this);
            return;
        }

        float normalizedSpeed = Mathf.Clamp01(fallSpeed / landingSpeedForMaxImpulse);
        float curveT = landingImpulseCurve.Evaluate(normalizedSpeed);
        float scaledForce = Mathf.Lerp(landImpulseForce, maxLandImpulseForce, curveT);

        Debug.Log($"PlayLandingShake: fallSpeed={fallSpeed:F2} normalized={normalizedSpeed:F2} scaledForce={scaledForce:F2}", this);

        impulseSource.GenerateImpulseWithVelocity(Vector3.down * scaledForce);
    }
    
    

}
