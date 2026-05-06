using UnityEngine;

public class SprintSpeedLines : MonoBehaviour
{
    public ParticleSystem speedLines;
    public Rigidbody playerRigidbody;
    public float speedThreshold = 10f;

    private bool wasFast = false;

    void Update()
    {
        if (speedLines == null || playerRigidbody == null) return;

        bool fastNow = playerRigidbody.linearVelocity.magnitude >= speedThreshold;

        if (fastNow && !wasFast)
        {
            speedLines.Clear(true);
            speedLines.Play(true);
        }
        else if (!fastNow && wasFast)
        {
            speedLines.Stop(true, ParticleSystemStopBehavior.StopEmittingAndClear);
        }

        wasFast = fastNow;
    }
}