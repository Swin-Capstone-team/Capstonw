using System.Collections;
using UnityEngine;

public class PlayerGrapple : MonoBehaviour
{
    [Header("References")]
    public Camera playerCamera;
    public Transform grappleFirePoint;
    public GameObject grappleIndicator;
    public LineRenderer grappleLine;

    [Header("Grapple Detection")]
    public float maxGrappleDistance = 25f;
    public float aimAssistRadius = 1.5f;

    [Header("Failed Grapple")]
    public float failedGrappleDistance = 12f;
    public float failedGrappleDuration = 0.6f;
    public AudioSource audioSource;
    public AudioClip failedGrappleSound;

    private bool hasValidTarget;
    private Vector3 currentTargetPoint;
    private bool isGrappling;

    void Start()
    {
        if (grappleIndicator != null)
            grappleIndicator.SetActive(false);

        if (grappleLine != null)
        {
            grappleLine.enabled = false;
            grappleLine.positionCount = 2;
        }
    }

    void Update()
    {
        FindGrappleTarget();

        // Right click to grapple
        if (Input.GetMouseButtonDown(1))
        {
            TryGrapple();
        }
    }

    void FindGrappleTarget()
    {
        hasValidTarget = false;

        if (playerCamera == null)
            return;

        Ray aimRay = new Ray(playerCamera.transform.position, playerCamera.transform.forward);

        float bestScore = Mathf.Infinity;
        Vector3 bestPoint = Vector3.zero;

        foreach (GrappleAnchor anchor in GrappleAnchor.AllAnchors)
        {
            if (anchor == null)
                continue;

            for (int i = 0; i < anchor.GetPointCount(); i++)
            {
                Vector3 point = anchor.GetWorldPoint(i);

                Vector3 toPoint = point - aimRay.origin;

                float forwardDistance = Vector3.Dot(toPoint, aimRay.direction);

                // Behind camera
                if (forwardDistance < 0f)
                    continue;

                // Too far away
                if (forwardDistance > maxGrappleDistance)
                    continue;

                // How far the point is from the middle of the screen
                float distanceFromAim = Vector3.Cross(aimRay.direction, toPoint).magnitude;

                // Not close enough to crosshair
                if (distanceFromAim > aimAssistRadius)
                    continue;

                float score = distanceFromAim;

                if (score < bestScore)
                {
                    bestScore = score;
                    bestPoint = point;
                    hasValidTarget = true;
                }
            }
        }

        if (hasValidTarget)
        {
            currentTargetPoint = bestPoint;

            if (grappleIndicator != null)
            {
                grappleIndicator.SetActive(true);
                grappleIndicator.transform.position = currentTargetPoint;
                grappleIndicator.transform.LookAt(playerCamera.transform);
            }
        }
        else
        {
            if (grappleIndicator != null)
                grappleIndicator.SetActive(false);
        }
    }

    void TryGrapple()
    {
        if (isGrappling)
            return;

        if (hasValidTarget)
        {
            StartCoroutine(SuccessfulGrapple(currentTargetPoint));
        }
        else
        {
            StartCoroutine(FailedGrapple());
        }
    }

    IEnumerator SuccessfulGrapple(Vector3 targetPoint)
    {
        isGrappling = true;

        if (grappleLine != null)
        {
            grappleLine.enabled = true;
            grappleLine.SetPosition(0, grappleFirePoint.position);
            grappleLine.SetPosition(1, targetPoint);
        }

        // TODO:
        // Add your real pull/movement logic here later.
        // This currently only shows the grapple line.

        yield return new WaitForSeconds(0.2f);

        if (grappleLine != null)
            grappleLine.enabled = false;

        isGrappling = false;
    }

    IEnumerator FailedGrapple()
    {
        isGrappling = true;

        if (audioSource != null && failedGrappleSound != null)
        {
            audioSource.PlayOneShot(failedGrappleSound);
        }

        Vector3 startPoint = grappleFirePoint.position;
        Vector3 endPoint = startPoint + playerCamera.transform.forward * failedGrappleDistance;

        if (grappleLine != null)
            grappleLine.enabled = true;

        float halfDuration = failedGrappleDuration / 2f;
        float timer = 0f;

        // Shoot out
        while (timer < halfDuration)
        {
            timer += Time.deltaTime;
            float t = timer / halfDuration;

            if (grappleLine != null)
            {
                grappleLine.SetPosition(0, startPoint);
                grappleLine.SetPosition(1, Vector3.Lerp(startPoint, endPoint, t));
            }

            yield return null;
        }

        timer = 0f;

        // Retract
        while (timer < halfDuration)
        {
            timer += Time.deltaTime;
            float t = timer / halfDuration;

            if (grappleLine != null)
            {
                grappleLine.SetPosition(0, startPoint);
                grappleLine.SetPosition(1, Vector3.Lerp(endPoint, startPoint, t));
            }

            yield return null;
        }

        if (grappleLine != null)
            grappleLine.enabled = false;

        isGrappling = false;
    }
}