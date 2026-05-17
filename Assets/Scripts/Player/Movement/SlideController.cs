using UnityEngine;

[DisallowMultipleComponent]
public class SlideController : MonoBehaviour, IMovementState
{
    private const float MinDirectionSpeed = 0.1f;
    private const float MinHorizontalSpeed = 0.0001f;

    private MovementManager mgr;

    // Slide state
    private bool isSliding = false;
    private float cooldownRemaining = 0f;
    private float slideDecayElapsed = 0f;
    private float slideStartHorizontalSpeed = 0f;

    public void Enter(MovementManager manager)
    {
        mgr = manager;
    }

    public void Exit()
    {
        StopSlide();
        mgr = null;
    }

    public void HandleInput()
    {
        if (mgr == null || mgr.Input == null) return;
    }

    public void FixedUpdateState()
    {
        if (!isSliding) return;

        Vector3 horizontalVel = new Vector3(mgr.Rb.linearVelocity.x, 0f, mgr.Rb.linearVelocity.z);
        float horizontalMagnitude = horizontalVel.magnitude;

        slideDecayElapsed += Time.fixedDeltaTime;
        float decayT = Mathf.Clamp01(slideDecayElapsed / mgr.Settings.slideDecayDuration);
        float targetHorizontalSpeed = Mathf.Lerp(slideStartHorizontalSpeed, 0f, decayT);

        if (targetHorizontalSpeed <= mgr.Settings.slideStopSpeed || horizontalMagnitude < MinHorizontalSpeed)
        {
            StopSlide();
            return;
        }

        float clampedSpeed = Mathf.Min(horizontalMagnitude, targetHorizontalSpeed);
        Vector3 horizontalDirection = horizontalVel / horizontalMagnitude;

        mgr.SetHorizontalVelocity(horizontalDirection * clampedSpeed);
        // Keep shared speed in sync for UI/other systems while sliding.
        mgr.currentSpeed = clampedSpeed;
    }

    public void StartSlide(float slopeAngle)
    {
        if (slopeAngle < -mgr.Settings.slideStopUphillAngle)
        {
            return;
        }

        isSliding = true;
        cooldownRemaining = mgr.Settings.slideCooldown;
        slideDecayElapsed = 0f;

        Vector3 currentVel = mgr.Rb.linearVelocity;
        Vector3 horizontalVel = new Vector3(currentVel.x, 0f, currentVel.z);
        float currentHorizontalSpeed = horizontalVel.magnitude;
        float minSlideStartSpeed = mgr.Settings.slideRequireSpeed > 0f ? mgr.Settings.slideRequireSpeed : mgr.Settings.walkSpeed;
        // Boost should scale current momentum; min speed prevents very slow/standstill slides.
        slideStartHorizontalSpeed = Mathf.Max(currentHorizontalSpeed * mgr.Settings.slideSpeedBoost, minSlideStartSpeed);

        if (currentHorizontalSpeed > MinDirectionSpeed)
        {
            Vector3 direction = horizontalVel.normalized;
            mgr.SetHorizontalVelocity(direction * slideStartHorizontalSpeed);
        }
        else
        {
            mgr.Rb.AddForce(mgr.transform.forward * slideStartHorizontalSpeed, ForceMode.Impulse);
        }

        mgr.currentSpeed = slideStartHorizontalSpeed;
    }

    public void StopSlide()
    {
        isSliding = false;
        slideDecayElapsed = 0f;
        slideStartHorizontalSpeed = 0f;
    }

    public void TickCooldown(float deltaTime)
    {
        if (cooldownRemaining > 0f)
        {
            cooldownRemaining = Mathf.Max(0f, cooldownRemaining - deltaTime);
        }
    }

    public bool IsOnCooldown => cooldownRemaining > 0f;

    public bool IsSliding => isSliding;
}
