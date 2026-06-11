using UnityEngine;

public class SprintSpeedLines : MonoBehaviour
{
    public ParticleSystem speedLines;

    [Header("Emission")]
    public float sprintEmission = 40f;
    public float smoothSpeed = 5f;

    private ParticleSystem.EmissionModule emission;
    private float currentEmission;

    void Start()
    {
        if (speedLines == null)
            speedLines = GetComponent<ParticleSystem>();

        emission = speedLines.emission;

        currentEmission = 0f;
        emission.rateOverTime = 0f;

        speedLines.Play();
    }

    void Update()
    {
        bool moving =
            Input.GetAxisRaw("Horizontal") != 0 ||
            Input.GetAxisRaw("Vertical") != 0;

        bool sprinting = Input.GetKey(KeyCode.LeftShift) && moving;

        float targetEmission = sprinting ? sprintEmission : 0f;

        // Smooth fade
        currentEmission = Mathf.Lerp(
            currentEmission,
            targetEmission,
            Time.deltaTime * smoothSpeed
        );

        emission.rateOverTime = currentEmission;
    }
}