using UnityEngine;

public sealed class GroundProbe
{
    private const float MinCapsuleRadius = 0.01f;
    private const float CapsuleRadiusScale = 0.9f;
    private const float CapsuleBottomOffset = 0.05f;
    private const float MinDirectionMagnitude = 0.0001f;

    private readonly Transform origin;
    private readonly CapsuleCollider capsuleCollider;
    private readonly MovementSettings settings;

    public GroundProbe(Transform origin, CapsuleCollider capsuleCollider, MovementSettings settings)
    {
        this.origin = origin;
        this.capsuleCollider = capsuleCollider;
        this.settings = settings;
    }

    public bool IsGrounded { get; private set; }

    public bool WasGrounded { get; private set; }

    public bool HasGroundHit { get; private set; }

    public RaycastHit GroundHit { get; private set; }

    public float CurrentSlopeAngle { get; private set; }

    public void Refresh(Transform orientation)
    {
        WasGrounded = IsGrounded;
        IsGrounded = CheckGrounded();
        HasGroundHit = Physics.Raycast(origin.position, Vector3.down, out RaycastHit hit, settings.groundCheckDistance * 2f, settings.groundMask);
        GroundHit = hit;
        CurrentSlopeAngle = HasGroundHit ? GetSignedSlopeAngle(hit.normal, orientation) : 0f;
    }

    public void ForceUngrounded()
    {
        WasGrounded = IsGrounded;
        IsGrounded = false;
        HasGroundHit = false;
        GroundHit = default;
        CurrentSlopeAngle = 0f;
    }

    private bool CheckGrounded()
    {
        if (capsuleCollider == null)
        {
            return Physics.Raycast(origin.position, Vector3.down, settings.groundCheckDistance, settings.groundMask);
        }

        Bounds bounds = capsuleCollider.bounds;
        float radius = Mathf.Max(MinCapsuleRadius, bounds.extents.x * CapsuleRadiusScale);
        Vector3 bottom = new Vector3(bounds.center.x, bounds.min.y + CapsuleBottomOffset, bounds.center.z);
        Vector3 top = new Vector3(bounds.center.x, bounds.max.y - radius, bounds.center.z);

        return Physics.CheckCapsule(bottom, top, radius, settings.groundMask, QueryTriggerInteraction.Ignore);
    }

    private float GetSignedSlopeAngle(Vector3 groundNormal, Transform orientation)
    {
        float angle = Vector3.Angle(Vector3.up, groundNormal);
        if (angle <= settings.flatGroundAngleThreshold)
        {
            return 0f;
        }

        Vector3 downslopeDirection = Vector3.ProjectOnPlane(Vector3.down, groundNormal).normalized;
        if (downslopeDirection.sqrMagnitude <= MinDirectionMagnitude)
        {
            return 0f;
        }

        return Vector3.Dot(orientation.forward, downslopeDirection) >= 0f ? angle : -angle;
    }
}
