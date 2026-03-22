using System;
using UnityEngine;
[RequireComponent(typeof(Rigidbody), typeof(CapsuleCollider))]

public class Swinging : MonoBehaviour
{
    private PlayerMove playermove;
    private Rigidbody rb;
    [Header("Input")]
    public KeyCode leftSwingKey = KeyCode.Mouse0;
    public KeyCode rightSwingKey = KeyCode.Mouse1;

    [Header("References")]
    public PlayerMove playerController;
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

    [Header("Thrust")]
    public float sideThrust;
    public float upThrust;

    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        playermove = GetComponent<PlayerMove>();
        rb = GetComponent<Rigidbody>();
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
        if (Input.GetKeyDown(leftSwingKey))
        {
            StartSwing(ref leftSwingPoint, ref leftJoint, ref leftGunTip, ref llr);
            playerController.grappling = true;
        }
        if (Input.GetKeyDown(rightSwingKey))
        {
            StartSwing(ref rightSwingPoint, ref rightJoint, ref rightGunTip, ref rlr);
            playerController.grappling = true;
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
            playerController.grappling = false;
        }
        if (Input.GetKeyUp(rightSwingKey))
        {
            StopSwing(ref rightJoint, ref rlr);
            if(Input.GetKey(leftSwingKey)) return;
            playerController.grappling = false;
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
            if (leftJoint != null) GrappleReel(ref leftJoint);
            if (rightJoint != null) GrappleReel(ref rightJoint);
            
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

        // Ratchet: only ever decrease
        float currentDistLeft = Vector3.Distance(player.position, leftSwingPoint);
        if (currentDistLeft < leftShortestDistance) 
        {
            leftShortestDistance = currentDistLeft;
        }
        
        float currentDistRight = Vector3.Distance(player.position, rightSwingPoint);
        if (currentDistRight < rightShortestDistance) 
        {
            rightShortestDistance = currentDistRight;
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
        }

    }

    void StartSwing(ref Vector3 swingPoint, ref SpringJoint joint, ref Transform gunTip, ref LineRenderer lr)
    {
        RaycastHit hit;
        if (Physics.Raycast(cam.position, cam.forward, out hit, maxSwingDistance, Grappleable))
        {
            swingPoint = hit.point;
            joint = player.gameObject.AddComponent<SpringJoint>();
            joint.autoConfigureConnectedAnchor = false;
            joint.connectedAnchor = swingPoint;

            float distanceFromPoint = Vector3.Distance(player.position, swingPoint);
            if (joint == leftJoint) leftShortestDistance = distanceFromPoint;
            else rightShortestDistance = distanceFromPoint;

            joint.maxDistance = distanceFromPoint;
            joint.minDistance = distanceFromPoint * 0.25f;

            joint.spring = 80f;
            joint.damper = 25f;
            joint.massScale = 1f;

            lr.positionCount = 2;
            if (joint == leftJoint) 
            {
                leftGrapplePosition = gunTip.position;
            }
            else 
            {
                rightGrapplePosition = gunTip.position;
            }
        }
    }

    void StopSwing(ref SpringJoint joint, ref LineRenderer lr)
    {
        lr.positionCount = 0;
        Destroy(joint);
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
        // From player to grapple point
        return (avgSwingPoint - player.position).normalized;
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
    
     void GrappleReel(ref SpringJoint joint)
    {
        float g = Mathf.Abs(Physics.gravity.y);
        float hardMin = joint.minDistance + 0.01f;
        Vector3 toAnchor = (avgSwingPoint - player.position).normalized;
        rb.AddForce(Vector3.up * (g * (1f - 0.5f)), ForceMode.Acceleration); // counteract gravity partially

        rb.AddForce(toAnchor * reelStrength, ForceMode.Acceleration);
        joint.maxDistance = Mathf.Max(hardMin, joint.maxDistance - reelRate * Time.fixedDeltaTime);

    }

    bool IsSwinging()
    {
        return leftJoint != null || rightJoint != null;
    }
}
