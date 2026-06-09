using UnityEngine;
using UnityEngine.UI;

public class GrappleIndicator : MonoBehaviour
{
    [Header("References")]
    [Tooltip("The camera or player transform this indicator should face.")]
    public Transform playerCamera;
    
    [Tooltip("The SpriteRenderers that make up the indicator (if using Sprites).")]
    public SpriteRenderer[] spriteRenderers;
    
    [Tooltip("The UI Images that make up the indicator (if using World Space Canvas).")]
    public Image[] uiImages;
    
    [Header("Distance & Range Settings")]
    [Tooltip("Distance at which the indicator begins to fade in.")]
    public float fadeStartDistance = 40f;
    [Tooltip("Distance at which the indicator is fully visible (before becoming grappleable).")]
    public float maxVisibleDistance = 30f;
    
    [Tooltip("Distance at which the player can actually grapple (should match the Character Controller).")]
    public float grappleRange = 25f;

    [Tooltip("How closely the player must look at the object to grapple to it (should match Character Controller GrappleTargetSelectionDotMeasure).")]
    public float grappleDotThreshold = 0.5f;
    
    [Tooltip("Layers that can be grappled to or block line of sight (Should be GrappableLayer + Motor CollidableLayers).")]
    public LayerMask obstacleLayers;

    [Header("Visual Settings - Inactive (Too Far)")]
    public Color inactiveColor = new Color(1f, 1f, 1f, 0.5f);
    public Vector3 inactiveScale = Vector3.one;

    [Header("Visual Settings - Active (Grappleable)")]
    public Color activeColor = new Color(0f, 1f, 0.3f, 1f);
    public Vector3 activeScale = new Vector3(1.5f, 1.5f, 1.5f);

    [Header("Visual Settings - Targeted")]
    public Color targetedColor = new Color(1f, 0f, 0.3f, 1f);

    [Header("Animation Settings")]
    [Tooltip("How fast the indicator changes color and size.")]
    public float transitionSpeed = 10f;
    public Transform canvas;

    private bool isTargeted;

    private void Start()
    {
        // Try to locate the main camera automatically if not assigned
        if (playerCamera == null && Camera.main != null)
        {
            playerCamera = Camera.main.transform;
        }
    }

    private void LateUpdate()
    {
        if (playerCamera == null) return;
        // 1. Billboard effect: Always look at the player/camera
        canvas.LookAt(canvas.position + playerCamera.rotation * Vector3.forward, playerCamera.transform.rotation * Vector3.up);
    }

    private void Update()
    {
        if (playerCamera == null) return;

        // 2. Calculate distance
        float distance = Vector3.Distance(transform.position, playerCamera.position);

        // 3. Determine base target scale and color depending on distance, angle, and line of sight
        bool isGrappleable = false;

        if (distance <= grappleRange)
        {
            Vector3 dirToIndicator = (transform.position - playerCamera.position).normalized;
            float dot = Vector3.Dot(playerCamera.forward, dirToIndicator);
            
            if (dot > grappleDotThreshold)
            {
                // Line of Sight check
                // Offset the raycast start forward slightly to avoid hitting the player's own collider
                Vector3 rayStart = playerCamera.position + (dirToIndicator * 1.5f);
                float checkDistance = distance - 1.5f;

                if (checkDistance > 0)
                {
                    if (Physics.Raycast(rayStart, dirToIndicator, out RaycastHit hit, checkDistance, obstacleLayers))
                    {
                        // We hit an obstacle. Is it the grapple anchor itself?
                        // Lenient check: Does it share the same root prefab, or is the hit point very close to the indicator?
                        if (hit.transform.root == transform.root || Vector3.Distance(hit.point, transform.position) < 3f)
                        {
                            isGrappleable = true;
                        }
                    }
                    else
                    {
                        // Path is entirely clear
                        isGrappleable = true;
                    }
                }
                else
                {
                    // Player is basically touching the indicator
                    isGrappleable = true;
                }
            }
        }

        Vector3 targetScale = isGrappleable ? activeScale : inactiveScale;
        Color targetColor;
        if (isTargeted)
        {
            targetColor = targetedColor;
        }
        else
        {
            targetColor = isGrappleable ? activeColor : inactiveColor;
        }

        // 4. Handle fade out logic when the player is far away
        if (distance > maxVisibleDistance)
        {
            if (distance >= fadeStartDistance)
            {
                // Completely invisible
                targetColor.a = 0f;
            }
            else
            {
                // Linear fade mapped between fadeStartDistance (0%) and maxVisibleDistance (100% of our target alpha)
                float t = 1f - ((distance - maxVisibleDistance) / (fadeStartDistance - maxVisibleDistance));
                targetColor.a *= t;
            }
        }

        // 5. Apply smooth lerping for scale
        transform.localScale = Vector3.Lerp(transform.localScale, targetScale, Time.deltaTime * transitionSpeed);

        // 6. Apply smooth lerping for colors (supports both Sprites and UI Images)
        if (spriteRenderers != null && spriteRenderers.Length > 0)
        {
            foreach (var sr in spriteRenderers)
            {
                if (sr != null)
                    sr.color = Color.Lerp(sr.color, targetColor, Time.deltaTime * transitionSpeed);
            }
        }

        if (uiImages != null && uiImages.Length > 0)
        {
            foreach (var img in uiImages)
            {
                if (img != null)
                    img.color = Color.Lerp(img.color, targetColor, Time.deltaTime * transitionSpeed);
            }
        }
    }

    public void SetTargeted(bool targeted)
    {
        isTargeted = targeted;
    }
}
