using UnityEngine;
using UnityEngine.UI;

public class GrappleIndicator : MonoBehaviour
{
    [Header("References")]
    public Image indicatorImage;
    public Swinging swinging;

    [Header("Animation")]
    public float defaultScale = 0.1f;
    public float maxScale = 0.15f;
    public Color defaultColor = Color.white;
    public Color grappleColor = Color.green;
    public float animationSpeed = 0.25f;

    private Vector3 targetScale;
    private Color targetColor;
    private bool canGrapple = false;

    void Start()
    {
        if (indicatorImage == null) indicatorImage = GetComponent<Image>();
        targetScale = Vector3.one * defaultScale;
        targetColor = defaultColor;
    }

    void Update()
    {
        bool newGrappleState = swinging.CanGrapple();
        
        if (newGrappleState != canGrapple)
        {
            canGrapple = newGrappleState;
            targetScale = canGrapple ? Vector3.one * maxScale : Vector3.one * defaultScale;
            targetColor = canGrapple ? grappleColor : defaultColor;
        }

        indicatorImage.transform.localScale = Vector3.Lerp(indicatorImage.transform.localScale, targetScale, Time.deltaTime * animationSpeed);
        indicatorImage.color = Color.Lerp(indicatorImage.color, targetColor, Time.deltaTime * animationSpeed);
    }
}
