using UnityEngine;

public class SprintSpeedLines : MonoBehaviour
{
    public ParticleSystem speedLines;
    public PlayerInputState inputState;

    private bool wasSprinting = false;

    void Update()
    {
        if (speedLines == null || inputState == null) return;

        bool sprintingNow =
            inputState.SprintHeld &&
            inputState.Move.sqrMagnitude > 0.01f;

        if (sprintingNow && !wasSprinting)
        {
            speedLines.Clear(true);
            speedLines.Play(true);
        }
        else if (!sprintingNow && wasSprinting)
        {
            speedLines.Stop(true, ParticleSystemStopBehavior.StopEmittingAndClear);
        }

        wasSprinting = sprintingNow;
    }
}