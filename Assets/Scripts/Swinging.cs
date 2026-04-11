using System;
using System.Numerics;
using UnityEngine;
using UnityEngine.UIElements;
using UnityEngine.UI;
using Quaternion = UnityEngine.Quaternion;
using Vector3 = UnityEngine.Vector3;
using Image = UnityEngine.UI.Image;
using System.Diagnostics;
[RequireComponent(typeof(Rigidbody), typeof(CapsuleCollider))]

public class Swinging : MonoBehaviour
{
    private PlayerMove playermove;
    private Rigidbody rb;
    [Header("Input")]
    public KeyCode leftSwingKey = KeyCode.Mouse0;
    public KeyCode rightSwingKey = KeyCode.Mouse1;

    [Header("References")]
    public LineRenderer llr;
    public LineRenderer rlr;
    public Transform leftGunTip, rightGunTip, cam, player;
    public LayerMask Grappleable;
    private Vector3 leftGrapplePosition;
    private Vector3 rightGrapplePosition;

    //Advanced rope mechanics
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
    public float reelStrength, reelRate;

    [Header("Targeting")]
    public float maxTargetDistance = 25f;
    public float maxTargetAngle = 20f; // degrees from center of screen +/- targeting spread 
    public float targetingSpread = 20f; // angle away from the center of screen for split grapple targeting

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

    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        playermove = GetComponent<PlayerMove>();
        rb = GetComponent<Rigidbody>();

        if (grappleIndicatorPrefab != null)
        {
            grappleIndicatorInstanceRed = Instantiate(grappleIndicatorPrefab);
            grappleIndicatorInstanceBlue = Instantiate(grappleIndicatorPrefab);
            Image image = grappleIndicatorInstanceBlue.GetComponent<Image>();
            image.color = new Color32(62, 62, 203, 196);
            grappleIndicatorInstanceRed.SetActive(false);
            grappleIndicatorInstanceBlue.SetActive(false);
        }
    }

    float GetTangentialSpeed()
    {
        Vector3 ropeDir = GetRopeDir();
        Vector3 v = rb.linearVelocity; // if on Unity 2022/2023 use rb.velocity instead
        Vector3 tangential = Vector3.ProjectOnPlane(v, ropeDir);
        return tangential.magnitude;
    }

    // Update is called once per frame

    bool wHeld, aHeld, sHeld, dHeld, spaceheld;
    void Update()
    {
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
            hasLeftTarget = Physics.Raycast(cam.position, Quaternion.AngleAxis(-targetingSpread, Vector3.up) * cam.forward, out hit, maxSwingDistance, Grappleable);
            currentTargetPointLeft = hit.point;
            hasRightTarget = Physics.Raycast(cam.position, Quaternion.AngleAxis(targetingSpread, Vector3.up) * cam.forward, out hit, maxSwingDistance, Grappleable);
            currentTargetPointRight = hit.point;
        }
        hasTarget = hasLeftTarget || hasRightTarget;
        UpdateIndicator(hasLeftTarget, currentTargetPointLeft, grappleIndicatorInstanceBlue, leftJoint);
        UpdateIndicator(hasRightTarget, currentTargetPointRight, grappleIndicatorInstanceRed, rightJoint);

       

        if (Input.GetKeyDown(leftSwingKey))
        {
            StartSwing(currentTargetPointLeft, ref leftJoint, leftGunTip, ref llr);
            playermove.grappling = true;
            leftSwingPoint = currentTargetPointLeft;
        }
        if (Input.GetKeyDown(rightSwingKey))
        {
            StartSwing(currentTargetPointRight, ref rightJoint, rightGunTip, ref rlr);
            playermove.grappling = true;
            rightSwingPoint = currentTargetPointRight;
        }
        wHeld = Input.GetKey(KeyCode.W);
        aHeld = Input.GetKey(KeyCode.A);
        sHeld = Input.GetKey(KeyCode.S);
        dHeld = Input.GetKey(KeyCode.D);
        spaceheld = Input.GetKey(KeyCode.Space);

        if (Input.GetKeyUp(leftSwingKey))
        {
            StopSwing(ref leftJoint, ref llr);
            if(Input.GetKey(rightSwingKey)) return;
            playermove.grappling = false;
        }
        if (Input.GetKeyUp(rightSwingKey))
        {
            StopSwing(ref rightJoint, ref rlr);
            if(Input.GetKey(leftSwingKey)) return;
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
        if (spaceheld && IsSwinging())
        {
            int grappleCount = 0;
            if (leftJoint != null) grappleCount++;
            if (rightJoint != null) grappleCount++;

            float forceScale = grappleCount > 0 ? 1f / grappleCount : 0f;

            if (leftJoint != null) GrappleReel(ref leftJoint, forceScale);
            if (rightJoint != null) GrappleReel(ref rightJoint, forceScale);
        }

        if (rightJoint == null && leftJoint == null) return;

        if (leftJoint != null && rightJoint != null) avgSwingPoint = (leftSwingPoint + rightSwingPoint) / 2f;
        else if (leftJoint != null) avgSwingPoint = leftSwingPoint;
        else if (rightJoint != null) avgSwingPoint = rightSwingPoint;

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

        // Adaptive leeway: scales with how close you've reeled in
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



        // Advanced rope mechanics
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

                if (Physics.Raycast(camPos, toPoint.normalized, out RaycastHit hit, distance))
                {
                    float penetrationAllowance = 0.35f;

                    if (hit.distance < distance - penetrationAllowance)
                        continue;
                }

                if (distance > maxTargetDistance)
                    continue;

                Vector3 dir = toPoint.normalized;

                float angle = Vector3.Angle(Quaternion.AngleAxis(offsetAngle, Vector3.up) * camForward, dir);
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

    

    void StartSwing(Vector3 currentTargetPoint, ref SpringJoint joint, Transform gunTip, ref LineRenderer lr)
    {
        if (currentTargetPoint == Vector3.zero)
            return;
         
        joint = player.gameObject.AddComponent<SpringJoint>();
        joint.autoConfigureConnectedAnchor = false;
        joint.connectedAnchor = currentTargetPoint;

        float distanceFromPoint = Vector3.Distance(player.position, currentTargetPoint);
        if (IsUsingGrappleAnchor) //This was the only difference between raycast and grapple points. Do they need to be different?
        {
            joint.minDistance = distanceFromPoint * 0.05f;
        } 
        else 
        {
            joint.minDistance = distanceFromPoint * 0.25f;
        }

        if (gunTip == leftGunTip)
        {
            leftShortestDistance = distanceFromPoint;
            leftGrapplePosition = gunTip.position;
        }
        else
        {
            rightShortestDistance = distanceFromPoint;
             rightGrapplePosition = gunTip.position;
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
        if (leftJoint != null)
        {
            leftGrapplePosition = Vector3.Lerp(leftGrapplePosition, leftSwingPoint, Time.deltaTime * 8f);
            llr.SetPosition(0, leftGunTip.position);
            llr.SetPosition(1, leftSwingPoint);
        } 
        if (rightJoint != null)
        {
            rightGrapplePosition = Vector3.Lerp(rightGrapplePosition, rightSwingPoint, Time.deltaTime * 8f);
            rlr.SetPosition(0, rightGunTip.position);
            rlr.SetPosition(1, rightSwingPoint);
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

        // Use camera's right as your intended control direction,
        // BUT remove any component along the rope so it's purely tangential.
        Vector3 intended = right ? cam.right : -cam.right;

        Vector3 sideDir = Vector3.ProjectOnPlane(intended, ropeDir);

        // Safety: if ropeDir is almost parallel to intended, sideDir can be near zero.
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
        float hardMin = joint.minDistance + 0.01f;

        Vector3 toAnchor = joint.connectedAnchor - player.position;
        float distance = toAnchor.magnitude;

        if (distance > 0.01f)
        {
            Vector3 dir = toAnchor / distance;

            float pullForce = reelStrength * (distance / joint.maxDistance);
            pullForce *= forceScale;

            rb.AddForce(dir * pullForce, ForceMode.Acceleration);
        }

        joint.maxDistance = Mathf.Max(hardMin, joint.maxDistance - reelRate * Time.fixedDeltaTime);
    }

    bool IsSwinging()
    {
        return leftJoint != null || rightJoint != null;
    }
}
