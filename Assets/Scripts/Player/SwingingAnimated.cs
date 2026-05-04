using System;
using System.Collections;
using UnityEngine;
using UnityEngine.UIElements;
using UnityEngine.UI;
using Quaternion = UnityEngine.Quaternion;
using Vector3 = UnityEngine.Vector3;
using Image = UnityEngine.UI.Image;

[RequireComponent(typeof(Rigidbody), typeof(CapsuleCollider))]
[DisallowMultipleComponent]
public class SwingingAnimated : MonoBehaviour
{
    private PlayerMove playermove;
    private PlayerInputState inputState;
    private Rigidbody rb;

    [Header("References")]
    public LineRenderer llr;
    public LineRenderer rlr;
    public Transform leftGunTip, rightGunTip, cam, player;
    public LayerMask Grappleable;
    private Vector3 leftGrapplePosition;
    private Vector3 rightGrapplePosition;

    private float leftShortestDistance;
    private float rightShortestDistance;
    private float minLeeway = 0.2f;
    private float leewayFraction = 0.05f;
    private float adaptiveLeeway;

    [Header("Swinging")]
    public bool IsUsingGrappleAnchor = true;
    public float jointSpring = 2f;
    public float jointDamper = 0.5f;
    public float jointMassScale = 1f;
    private float maxSwingDistance = 25f;
    private Vector3 leftSwingPoint;
    private Vector3 rightSwingPoint;
    private Vector3 avgSwingPoint;
    private SpringJoint leftJoint;
    private SpringJoint rightJoint;
    public float maxSpeed;

    [Header("Reel Settings")]
    public bool automaticReelIn = false;
    public float reelStrength, reelRate;

    [Range(0.9f, 1f)]
    public float gravityEffect = 0.98f;

    [Header("Targeting")]
    public float maxTargetDistance = 25f;
    public float maxTargetAngle = 20f;
    public float targetingSpread = 20f;

    private Vector3 currentTargetPointRight;
    private Vector3 currentTargetPointLeft;
    private bool hasTarget;

    [Header("Thrust")]
    public float sideThrust;
    public float upThrust;
    public float releaseBoost;

    [Header("Indicator")]
    public GameObject grappleIndicatorPrefab;
    private GameObject grappleIndicatorInstanceRed;
    private GameObject grappleIndicatorInstanceBlue;

    [Header("Rope Animation")]
    public float ropeShootDuration = 0.35f;
    public float failedGrappleDistance = 12f;
    public float failedRetractDuration = 0.25f;
    public AudioSource grappleAudioSource;
    public AudioClip failedGrappleSound;

    private bool leftRopeBusy;
    private bool rightRopeBusy;

    bool wHeld, aHeld, sHeld, dHeld, spaceheld;

    void Awake()
    {
        inputState ??= GetComponentInParent<PlayerInputState>();

        if (inputState != null) return;

        Debug.LogError("SwingingAnimated requires PlayerInputState on this object or a parent.", this);
        enabled = false;
    }

    void Start()
    {
        playermove = GetComponent<PlayerMove>();

        if (!enabled) return;

        rb = GetComponent<Rigidbody>();

        if (llr != null) llr.positionCount = 0;
        if (rlr != null) rlr.positionCount = 0;

        if (grappleIndicatorPrefab != null)
        {
            grappleIndicatorInstanceRed = Instantiate(grappleIndicatorPrefab);
            grappleIndicatorInstanceBlue = Instantiate(grappleIndicatorPrefab);

            Image image = grappleIndicatorInstanceBlue.GetComponent<Image>();

            if (image != null)
                image.color = new Color32(62, 62, 203, 196);

            grappleIndicatorInstanceRed.SetActive(false);
            grappleIndicatorInstanceBlue.SetActive(false);
        }
    }

    float GetTangentialSpeed()
    {
        Vector3 ropeDir = GetRopeDir();
        Vector3 v = rb.linearVelocity;
        Vector3 tangential = Vector3.ProjectOnPlane(v, ropeDir);
        return tangential.magnitude;
    }

    void Update()
    {
        Vector2 moveInput = inputState.Move;

        bool hasLeftTarget;
        bool hasRightTarget;

        if (IsUsingGrappleAnchor)
        {
            hasLeftTarget = FindBestGrapplePoint(-targetingSpread, out currentTargetPointLeft);
            hasRightTarget = FindBestGrapplePoint(targetingSpread, out currentTargetPointRight);
        }
        else
        {
            RaycastHit hit;

            hasLeftTarget = Physics.Raycast(
                cam.position,
                Quaternion.AngleAxis(-targetingSpread, Vector3.up) * cam.forward,
                out hit,
                maxSwingDistance,
                Grappleable
            );

            currentTargetPointLeft = hasLeftTarget ? hit.point : Vector3.zero;

            hasRightTarget = Physics.Raycast(
                cam.position,
                Quaternion.AngleAxis(targetingSpread, Vector3.up) * cam.forward,
                out hit,
                maxSwingDistance,
                Grappleable
            );

            currentTargetPointRight = hasRightTarget ? hit.point : Vector3.zero;
        }

        hasTarget = hasLeftTarget || hasRightTarget;

        UpdateIndicator(hasLeftTarget, currentTargetPointLeft, grappleIndicatorInstanceBlue, leftJoint);
        UpdateIndicator(hasRightTarget, currentTargetPointRight, grappleIndicatorInstanceRed, rightJoint);

        if (inputState.LeftSwingPressedThisFrame && leftJoint == null && !leftRopeBusy)
        {
            if (hasLeftTarget)
            {
                StartCoroutine(StartSwingAnimatedRoutine(currentTargetPointLeft, true));
            }
            else
            {
                StartCoroutine(FailedGrappleAnimated(leftGunTip, llr, true));
            }
        }

        if (inputState.RightSwingPressedThisFrame && rightJoint == null && !rightRopeBusy)
        {
            if (hasRightTarget)
            {
                StartCoroutine(StartSwingAnimatedRoutine(currentTargetPointRight, false));
            }
            else
            {
                StartCoroutine(FailedGrappleAnimated(rightGunTip, rlr, false));
            }
        }

        wHeld = moveInput.y > 0.1f;
        aHeld = moveInput.x < -0.1f;
        sHeld = moveInput.y < -0.1f;
        dHeld = moveInput.x > 0.1f;
        spaceheld = inputState.JumpHeld;

        if (inputState.LeftSwingReleasedThisFrame)
        {
            StopSwing(ref leftJoint, ref llr);

            if (inputState.RightSwingHeld) return;

            playermove.grappling = false;
        }

        if (inputState.RightSwingReleasedThisFrame)
        {
            StopSwing(ref rightJoint, ref rlr);

            if (inputState.LeftSwingHeld) return;

            playermove.grappling = false;
        }
    }

    void OnDrawGizmos()
    {
        if (hasTarget)
        {
            Gizmos.color = Color.red;
            Gizmos.DrawSphere(currentTargetPointRight, 0.3f);

            Gizmos.color = Color.blue;
            Gizmos.DrawSphere(currentTargetPointLeft, 0.3f);
        }
    }

    void LateUpdate()
    {
        DrawRope();
    }

    void FixedUpdate()
    {
        bool shouldReel = (automaticReelIn || spaceheld) && IsSwinging();

        if (shouldReel)
        {
            int grappleCount = 0;

            if (leftJoint != null) grappleCount++;
            if (rightJoint != null) grappleCount++;

            float forceScale = grappleCount > 0 ? 1f / grappleCount : 0f;

            if (leftJoint != null) GrappleReel(ref leftJoint, forceScale);
            if (rightJoint != null) GrappleReel(ref rightJoint, forceScale);
        }

        if (rightJoint == null && leftJoint == null) return;

        if (leftJoint != null && rightJoint != null)
            avgSwingPoint = (leftSwingPoint + rightSwingPoint) / 2f;
        else if (leftJoint != null)
            avgSwingPoint = leftSwingPoint;
        else if (rightJoint != null)
            avgSwingPoint = rightSwingPoint;

        if (leftJoint != null)
        {
            float leftCurrentDist = Vector3.Distance(player.position, leftSwingPoint);

            if (leftCurrentDist < leftShortestDistance)
                leftShortestDistance = leftCurrentDist;
        }

        if (rightJoint != null)
        {
            float rightCurrentDist = Vector3.Distance(player.position, rightSwingPoint);

            if (rightCurrentDist < rightShortestDistance)
                rightShortestDistance = rightCurrentDist;
        }

        float baseDistance;

        if (leftJoint != null && rightJoint != null)
            baseDistance = Mathf.Min(leftShortestDistance, rightShortestDistance);
        else if (leftJoint != null)
            baseDistance = leftShortestDistance;
        else
            baseDistance = rightShortestDistance;

        adaptiveLeeway = Mathf.Max(minLeeway, baseDistance * leewayFraction);

        if (leftJoint != null)
        {
            float hardMin = leftJoint.minDistance + 0.01f;
            float targetMax = Mathf.Max(leftShortestDistance + adaptiveLeeway, hardMin);
            leftJoint.maxDistance = targetMax;
        }

        if (rightJoint != null)
        {
            float hardMin = rightJoint.minDistance + 0.01f;
            float targetMax = Mathf.Max(rightShortestDistance + adaptiveLeeway, hardMin);
            rightJoint.maxDistance = targetMax;
        }

        Vector3 vAll = rb.linearVelocity;
        Vector3 vHoriz = new Vector3(vAll.x, 0f, vAll.z);

        if (!playermove.grounded)
        {
            if (aHeld && vHoriz.magnitude < maxSpeed)
            {
                ReelLeft();
            }
            else if (aHeld && vHoriz.magnitude > maxSpeed)
            {
                ReelLeftSpeed();
            }

            if (dHeld && vHoriz.magnitude < maxSpeed)
            {
                ReelRight();
            }
            else if (dHeld && vHoriz.magnitude > maxSpeed)
            {
                ReelRightSpeed();
            }

            Vector3 ropeDir = GetRopeDir();
            Vector3 forwardDir = Vector3.ProjectOnPlane(cam.forward, ropeDir).normalized;

            if (wHeld && forwardDir != Vector3.zero)
                rb.AddForce(forwardDir * sideThrust, ForceMode.Acceleration);

            if (sHeld && forwardDir != Vector3.zero)
                rb.AddForce(-forwardDir * sideThrust, ForceMode.Acceleration);
        }

        rb.linearVelocity = Vector3.ClampMagnitude(rb.linearVelocity, maxSpeed);
    }

    bool FindBestGrapplePoint(float offsetAngle, out Vector3 currentTargetPoint)
    {
        currentTargetPoint = Vector3.zero;
        bool foundTarget = false;

        float bestScore = float.MaxValue;

        Vector3 camPos = cam.position;
        Vector3 camForward = cam.forward;

        foreach (var anchor in GrappleAnchor.AllAnchors)
        {
            if (anchor == null) continue;

            float anchorDist = Vector3.Distance(camPos, anchor.transform.position);

            if (anchorDist > maxTargetDistance + anchor.boundingRadius)
                continue;

            int count = anchor.GetPointCount();

            for (int i = 0; i < count; i++)
            {
                Vector3 point = anchor.GetWorldPoint(i);

                Vector3 toPoint = point - camPos;
                float distance = toPoint.magnitude;

                if (Physics.Raycast(camPos, toPoint.normalized, out RaycastHit hit, distance, Grappleable))
                {
                    float penetrationAllowance = 0.35f;

                    if (hit.distance < distance - penetrationAllowance)
                        continue;
                }

                if (distance > maxTargetDistance)
                    continue;

                Vector3 dir = toPoint.normalized;

                float angle = Vector3.Angle(
                    Quaternion.AngleAxis(offsetAngle, Vector3.up) * camForward,
                    dir
                );

                if (angle > maxTargetAngle)
                    continue;

                float score = angle + distance;

                if (score < bestScore)
                {
                    bestScore = score;
                    currentTargetPoint = point;
                    foundTarget = true;
                }
            }
        }

        return foundTarget;
    }

    void UpdateIndicator(bool hasTarget, Vector3 currentTargetPoint, GameObject grappleIndicatorInstance, SpringJoint joint)
    {
        if (grappleIndicatorInstance == null)
            return;

        if (joint != null)
        {
            grappleIndicatorInstance.SetActive(false);
            return;
        }

        if (hasTarget)
        {
            grappleIndicatorInstance.SetActive(true);

            Vector3 offsetDir = (cam.position - currentTargetPoint).normalized;
            grappleIndicatorInstance.transform.position = currentTargetPoint + offsetDir * 0.4f;
            grappleIndicatorInstance.transform.forward = cam.forward;
        }
        else
        {
            grappleIndicatorInstance.SetActive(false);
        }
    }

    IEnumerator StartSwingAnimatedRoutine(Vector3 targetPoint, bool isLeft)
    {
        Transform gunTip = isLeft ? leftGunTip : rightGunTip;
        LineRenderer lr = isLeft ? llr : rlr;

        if (isLeft)
            leftRopeBusy = true;
        else
            rightRopeBusy = true;

        yield return StartCoroutine(AnimateRopeShoot(lr, gunTip, targetPoint, ropeShootDuration));

        bool stillHolding = isLeft ? inputState.LeftSwingHeld : inputState.RightSwingHeld;

        if (!stillHolding)
        {
            lr.positionCount = 0;

            if (isLeft)
                leftRopeBusy = false;
            else
                rightRopeBusy = false;

            yield break;
        }

        if (isLeft)
        {
            leftSwingPoint = targetPoint;
            leftGrapplePosition = targetPoint;
            StartSwing(targetPoint, ref leftJoint, leftGunTip, ref llr, true);
        }
        else
        {
            rightSwingPoint = targetPoint;
            rightGrapplePosition = targetPoint;
            StartSwing(targetPoint, ref rightJoint, rightGunTip, ref rlr, true);
        }

        playermove.grappling = true;

        if (isLeft)
            leftRopeBusy = false;
        else
            rightRopeBusy = false;
    }

    IEnumerator FailedGrappleAnimated(Transform gunTip, LineRenderer lr, bool isLeft)
    {
        if (isLeft)
            leftRopeBusy = true;
        else
            rightRopeBusy = true;

        if (grappleAudioSource != null && failedGrappleSound != null)
        {
            grappleAudioSource.PlayOneShot(failedGrappleSound);
        }

        Vector3 shootDirection;

        if (isLeft)
            shootDirection = Quaternion.AngleAxis(-targetingSpread, Vector3.up) * cam.forward;
        else
            shootDirection = Quaternion.AngleAxis(targetingSpread, Vector3.up) * cam.forward;

        Vector3 failedTargetPoint = gunTip.position + shootDirection.normalized * failedGrappleDistance;

        yield return StartCoroutine(AnimateRopeShoot(lr, gunTip, failedTargetPoint, ropeShootDuration));
        yield return StartCoroutine(AnimateRopeRetract(lr, gunTip, failedTargetPoint, failedRetractDuration));

        lr.positionCount = 0;

        if (isLeft)
            leftRopeBusy = false;
        else
            rightRopeBusy = false;
    }

    IEnumerator AnimateRopeShoot(LineRenderer lr, Transform gunTip, Vector3 targetPoint, float duration)
    {
        if (lr == null || gunTip == null)
            yield break;

        duration = Mathf.Min(duration, 0.5f);

        lr.positionCount = 2;

        float timer = 0f;

        while (timer < duration)
        {
            timer += Time.deltaTime;
            float t = timer / duration;

            Vector3 startPoint = gunTip.position;
            Vector3 currentEndPoint = Vector3.Lerp(startPoint, targetPoint, t);

            lr.SetPosition(0, startPoint);
            lr.SetPosition(1, currentEndPoint);

            yield return null;
        }

        lr.SetPosition(0, gunTip.position);
        lr.SetPosition(1, targetPoint);
    }

    IEnumerator AnimateRopeRetract(LineRenderer lr, Transform gunTip, Vector3 fromPoint, float duration)
    {
        if (lr == null || gunTip == null)
            yield break;

        float timer = 0f;

        while (timer < duration)
        {
            timer += Time.deltaTime;
            float t = timer / duration;

            Vector3 startPoint = gunTip.position;
            Vector3 currentEndPoint = Vector3.Lerp(fromPoint, startPoint, t);

            lr.SetPosition(0, startPoint);
            lr.SetPosition(1, currentEndPoint);

            yield return null;
        }

        lr.positionCount = 0;
    }

    void StartSwing(Vector3 currentTargetPoint, ref SpringJoint joint, Transform gunTip, ref LineRenderer lr, bool ropeAlreadyAtTarget = false)
    {
        if (currentTargetPoint == Vector3.zero)
            return;

        joint = player.gameObject.AddComponent<SpringJoint>();
        joint.autoConfigureConnectedAnchor = false;
        joint.connectedAnchor = currentTargetPoint;

        float distanceFromPoint = Vector3.Distance(player.position, currentTargetPoint);

        joint.minDistance = distanceFromPoint * 0.05f;

        if (gunTip == leftGunTip)
        {
            leftShortestDistance = distanceFromPoint;
            leftGrapplePosition = ropeAlreadyAtTarget ? currentTargetPoint : gunTip.position;
            leftSwingPoint = currentTargetPoint;
        }
        else
        {
            rightShortestDistance = distanceFromPoint;
            rightGrapplePosition = ropeAlreadyAtTarget ? currentTargetPoint : gunTip.position;
            rightSwingPoint = currentTargetPoint;
        }

        joint.maxDistance = distanceFromPoint;

        joint.spring = 80f;
        joint.damper = 25f;
        joint.massScale = 1f;

        lr.positionCount = 2;
    }

    void StopSwing(ref SpringJoint joint, ref LineRenderer lr)
    {
        lr.positionCount = 0;

        if (joint != null)
        {
            if (!playermove.grounded)
            {
                Vector3 velocity = rb.linearVelocity;
                float speed = velocity.magnitude;

                Vector3 boostDir;

                float speedThreshold = 5f;

                if (speed > speedThreshold)
                {
                    boostDir = velocity.normalized;
                    boostDir += Vector3.up * 0.3f;
                    boostDir.Normalize();
                }
                else
                {
                    boostDir = GetRopeDir();
                }

                rb.linearVelocity += boostDir * releaseBoost;
            }

            Destroy(joint);
            joint = null;
        }
    }

    void DrawRope()
    {
        if (leftJoint != null && !leftRopeBusy)
        {
            leftGrapplePosition = Vector3.Lerp(leftGrapplePosition, leftSwingPoint, Time.deltaTime * 8f);

            llr.positionCount = 2;
            llr.SetPosition(0, leftGunTip.position);
            llr.SetPosition(1, leftGrapplePosition);
        }

        if (rightJoint != null && !rightRopeBusy)
        {
            rightGrapplePosition = Vector3.Lerp(rightGrapplePosition, rightSwingPoint, Time.deltaTime * 8f);

            rlr.positionCount = 2;
            rlr.SetPosition(0, rightGunTip.position);
            rlr.SetPosition(1, rightGrapplePosition);
        }
    }

    void ReelUp()
    {
        rb.AddForce(player.up * sideThrust, ForceMode.Acceleration);
    }

    void ReelDown()
    {
        rb.AddForce(-player.up * sideThrust, ForceMode.Acceleration);
    }

    Vector3 GetRopeDir()
    {
        if (leftJoint != null && rightJoint != null)
        {
            float leftDist = Vector3.Distance(player.position, leftSwingPoint);
            float rightDist = Vector3.Distance(player.position, rightSwingPoint);

            Vector3 target = leftDist < rightDist ? leftSwingPoint : rightSwingPoint;
            return (target - player.position).normalized;
        }
        else if (leftJoint != null)
        {
            return (leftSwingPoint - player.position).normalized;
        }
        else if (rightJoint != null)
        {
            return (rightSwingPoint - player.position).normalized;
        }

        return Vector3.zero;
    }

    Vector3 GetSideDir(bool right)
    {
        Vector3 ropeDir = GetRopeDir();
        Vector3 intended = right ? cam.right : -cam.right;
        Vector3 sideDir = Vector3.ProjectOnPlane(intended, ropeDir);

        if (sideDir.sqrMagnitude < 0.0001f)
            return Vector3.zero;

        return sideDir.normalized;
    }

    void ReelLeft()
    {
        Vector3 dir = GetSideDir(right: false);

        if (dir != Vector3.zero)
            rb.AddForce(dir * sideThrust, ForceMode.Acceleration);
    }

    void ReelLeftSpeed()
    {
        Vector3 dir = GetSideDir(right: false);

        if (dir != Vector3.zero)
            rb.AddForce(dir * (0.3f * sideThrust), ForceMode.Acceleration);
    }

    void ReelRight()
    {
        Vector3 dir = GetSideDir(right: true);

        if (dir != Vector3.zero)
            rb.AddForce(dir * sideThrust, ForceMode.Acceleration);
    }

    void ReelRightSpeed()
    {
        Vector3 dir = GetSideDir(right: true);

        if (dir != Vector3.zero)
            rb.AddForce(dir * (0.3f * sideThrust), ForceMode.Acceleration);
    }

    void GrappleReel(ref SpringJoint joint, float forceScale)
    {
        Vector3 toAnchor = joint.connectedAnchor - player.position;
        float distance = toAnchor.magnitude;

        if (distance < 0.01f) return;

        Vector3 dir = toAnchor / distance;

        rb.AddForce(dir * reelStrength * forceScale, ForceMode.Acceleration);

        bool anchorBelow = joint.connectedAnchor.y < player.position.y;

        if (gravityEffect < 1f)
        {
            float cancelFactor = 1f - gravityEffect;

            rb.AddForce(-Physics.gravity * cancelFactor, ForceMode.Acceleration);

            Vector3 v = rb.linearVelocity;

            if (!anchorBelow && v.y < 0f)
            {
                float newY = Mathf.Lerp(v.y, 0f, cancelFactor);
                rb.linearVelocity = new Vector3(v.x, newY, v.z);
            }
        }

        if (!anchorBelow)
        {
            Vector3 velocity = rb.linearVelocity;
            float alignment = Vector3.Dot(velocity, dir);

            if (alignment < 0f)
            {
                rb.linearVelocity -= dir * alignment;
            }
        }

        joint.maxDistance = Mathf.Max(
            joint.minDistance,
            joint.maxDistance - reelRate * Time.fixedDeltaTime
        );
    }

    bool IsSwinging()
    {
        return leftJoint != null || rightJoint != null;
    }

    public bool CanGrapple()
    {
        RaycastHit hit;
        return Physics.Raycast(cam.position, cam.forward, out hit, maxSwingDistance, Grappleable);
    }
}