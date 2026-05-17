using UnityEngine;

[DisallowMultipleComponent]
public class SlideController : MonoBehaviour, IMovementState
{
    private const float MinDirectionSpeed = 0.1f;
    private const float MinHorizontalSpeed = 0.0001f;

    private MovementManager manager;

    private bool isSliding = false;
    private bool queuedSlideOnLand = false;
    private float cooldownRemaining = 0f;
    private float slideDecayElapsed = 0f;
    private float slideStartHorizontalSpeed = 0f;

    public bool HasQueuedSlideOnLand => queuedSlideOnLand;

    public bool IsOnCooldown => cooldownRemaining > 0f;

    public bool IsSliding => isSliding;

    public void Initialize(MovementManager movementManager)
    {
        manager = movementManager;
    }

    public void Enter(MovementManager manager)
    {
        this.manager = manager;
    }

    public void Exit()
    {
        StopSlide();
    }

    public void HandleInput()
    {
    }

    public void FixedUpdateState()
    {
        if (!isSliding || manager == null) return;

        Vector3 horizontalVel = new Vector3(manager.Rb.linearVelocity.x, 0f, manager.Rb.linearVelocity.z);
        float horizontalMagnitude = horizontalVel.magnitude;

        slideDecayElapsed += Time.fixedDeltaTime;
        float decayT = Mathf.Clamp01(slideDecayElapsed / manager.Settings.slideDecayDuration);
        float targetHorizontalSpeed = Mathf.Lerp(slideStartHorizontalSpeed, 0f, decayT);

        if (targetHorizontalSpeed <= manager.Settings.slideStopSpeed || horizontalMagnitude < MinHorizontalSpeed)
        {
            StopAndReturnToLocomotion();
            return;
        }

        float clampedSpeed = Mathf.Min(horizontalMagnitude, targetHorizontalSpeed);
        Vector3 horizontalDirection = horizontalVel / horizontalMagnitude;

        manager.SetHorizontalVelocity(horizontalDirection * clampedSpeed);
        manager.SetCurrentSpeed(clampedSpeed);
    }

    public bool TryStartSlide()
    {
        if (!CanStartSlide())
        {
            return false;
        }

        float slopeAngle = manager.CurrentGroundSlopeAngle;
        if (slopeAngle < -manager.Settings.slideStopUphillAngle)
        {
            return false;
        }

        manager.ChangeState(this);
        StartSlide(slopeAngle);
        queuedSlideOnLand = false;
        return true;
    }

    public bool TryConsumeQueuedSlideOnLanding()
    {
        if (!queuedSlideOnLand)
        {
            return false;
        }

        queuedSlideOnLand = false;
        return TryStartSlide();
    }

    public void HandleAirborneQueue()
    {
        if (manager == null || manager.Input == null || isSliding || manager.IsGrounded)
        {
            return;
        }

        if (manager.Input.CrouchPressedThisFrame && HasSlideIntentOrSpeed())
        {
            queuedSlideOnLand = true;
        }

        if (manager.Input.CrouchReleasedThisFrame)
        {
            queuedSlideOnLand = false;
        }
    }

    public void UpdateActiveSlide()
    {
        if (manager == null || !isSliding)
        {
            return;
        }

        if (manager.Input != null && manager.Input.CrouchReleasedThisFrame)
        {
            StopAndReturnToLocomotion();
            return;
        }

        float slopeAngle = manager.CurrentGroundSlopeAngle;
        if (slopeAngle < -manager.Settings.slideStopUphillAngle)
        {
            StopAndReturnToLocomotion();
            return;
        }

        float horizontalSpeedSqr = manager.Rb.linearVelocity.x * manager.Rb.linearVelocity.x + manager.Rb.linearVelocity.z * manager.Rb.linearVelocity.z;
        if (horizontalSpeedSqr <= manager.Settings.slideStopSpeed * manager.Settings.slideStopSpeed)
        {
            StopAndReturnToLocomotion();
        }
    }

    public void StartSlide(float slopeAngle)
    {
        if (manager == null || slopeAngle < -manager.Settings.slideStopUphillAngle)
        {
            return;
        }

        isSliding = true;
        cooldownRemaining = manager.Settings.slideCooldown;
        slideDecayElapsed = 0f;

        Vector3 currentVel = manager.Rb.linearVelocity;
        Vector3 horizontalVel = new Vector3(currentVel.x, 0f, currentVel.z);
        float currentHorizontalSpeed = horizontalVel.magnitude;
        slideStartHorizontalSpeed = Mathf.Max(currentHorizontalSpeed * manager.Settings.slideSpeedBoost, manager.EffectiveSlideRequireSpeed);

        if (currentHorizontalSpeed > MinDirectionSpeed)
        {
            Vector3 direction = horizontalVel.normalized;
            manager.SetHorizontalVelocity(direction * slideStartHorizontalSpeed);
        }
        else
        {
            manager.Rb.AddForce(manager.transform.forward * slideStartHorizontalSpeed, ForceMode.Impulse);
        }

        manager.SetCurrentSpeed(slideStartHorizontalSpeed);
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

    private void OnCollisionEnter(Collision collision)
    {
        if (manager == null || !isSliding)
        {
            return;
        }

        foreach (ContactPoint contact in collision.contacts)
        {
            float surfaceAngle = Vector3.Angle(contact.normal, Vector3.up);
            if (surfaceAngle >= manager.Settings.slideStopSurfaceAngle)
            {
                StopAndReturnToLocomotion();
                break;
            }
        }
    }

    private bool CanStartSlide()
    {
        if (manager == null || !manager.IsGrounded || manager.Input == null || isSliding || IsOnCooldown)
        {
            return false;
        }

        return HasSlideIntentOrSpeed();
    }

    private bool HasSlideIntentOrSpeed()
    {
        return (manager.Input != null && manager.Input.SprintHeld) || manager.IsSprintLatched || manager.HorizontalSpeed >= manager.EffectiveSlideRequireSpeed;
    }

    private void StopAndReturnToLocomotion()
    {
        if (!isSliding)
        {
            return;
        }

        StopSlide();
        manager.ReturnToDefaultMovementState();
    }
}
