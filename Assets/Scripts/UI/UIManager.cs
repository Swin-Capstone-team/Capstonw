using System.Collections;
using UnityEngine;
using UnityEngine.UI;
using TMPro; // Required for TextMeshPro
using System.Collections;

public class UIManager : MonoBehaviour
{
    [Header("UI Elements")]
    public Image timeImage;
    public TMP_Text levelsBeatenText;
    public TMP_Text scoreText;
    public TMP_Text scoreAddedText;
    public TMP_Text gameOverDetails;
    public GameObject gameOverPanel;

    [Header("Timer Visuals")]
    public Gradient timerColorGradient;
    [Tooltip("How fast the timer image catches up to the actual time")]
    public float fillLerpSpeed = 5f;

    [Header("Score Visuals")]
    [Tooltip("How fast the score visual catches up to the real score (points per second)")]
    public float scoreUpdateSpeed = 100f;
    [Tooltip("Scale multiplier for the score text when it's increasing")]
    public float scorePulseScale = 1.3f;
    [Tooltip("How fast the pulse shrinks back to normal")]
    public float scorePulseSpeed = 8f;
    
    [Header("Score Added Animation")]
    public float scoreAddedMoveDistance = 50f;
    public float scoreAddedAnimDuration = 0.5f;
    public float scoreAddedStayDuration = 1f;

    [Header("Hint UI")]
    [Tooltip("Panel anchored to the bottom-centre of the canvas. Needs a CanvasGroup component.")]
    public RectTransform hintPanel;
    [Tooltip("TextMeshPro label inside the hint panel.")]
    public TMP_Text hintText;
    [Tooltip("Seconds to fade the hint in / out.")]
    public float fadeDuration = 0.35f;
    [Tooltip("Seconds the hint stays fully visible before auto-dismissing. 0 = stay until the player leaves the room.")]
    public float hintDisplayDuration = 0f;

    private float targetTimeRatio = 1f;
    private bool isAnimatingTimer = false;
    private float currentDisplayedScore = 0f;
    private int targetScore = 0;
    private Vector3 originalScoreScale;
    private bool isPulsing = false;
    
    private Coroutine scoreAddedCoroutine;
    private Vector2 scoreAddedOriginalPos;

    private CanvasGroup hintCanvasGroup;
    private Coroutine activeHintCoroutine;

    private void Awake()
    {
        if (hintPanel != null)
        {
            hintCanvasGroup = hintPanel.GetComponent<CanvasGroup>();
            if (hintCanvasGroup == null)
            {
                hintCanvasGroup = hintPanel.gameObject.AddComponent<CanvasGroup>();
                hintCanvasGroup.interactable   = false;
                hintCanvasGroup.blocksRaycasts = false;
            }
            hintCanvasGroup.alpha = 0f;
        }
    }

    private void Start()
    {
        // Ensure the game over panel is hidden when the game starts
        if (gameOverPanel != null)
        {
            gameOverPanel.SetActive(false);
        }
        
        if (timeImage != null)
        {
            timeImage.fillAmount = 1f;
        }

        if (scoreText != null)
        {
            originalScoreScale = scoreText.transform.localScale;
        }

        if (scoreAddedText != null)
        {
            scoreAddedOriginalPos = scoreAddedText.rectTransform.anchoredPosition;
            Color c = scoreAddedText.color;
            c.a = 0f;
            scoreAddedText.color = c;
            scoreAddedText.gameObject.SetActive(false);
        }
        UpdateScoreDisplay(0);
    }

    private void Update()
    {
        if (timeImage != null)
        {
            if (isAnimatingTimer)
            {
                // Smoothly move the fill amount towards the target ratio for animations
                timeImage.fillAmount = Mathf.Lerp(timeImage.fillAmount, targetTimeRatio, Time.deltaTime * fillLerpSpeed);

                // Stop animating once we are extremely close to the target, allowing exact time tracking to take over
                if (Mathf.Abs(timeImage.fillAmount - targetTimeRatio) < 0.005f)
                {
                    timeImage.fillAmount = targetTimeRatio;
                    isAnimatingTimer = false;
                }
            }
            
            // Apply dynamic color gradient based on the current visible fill amount
            timeImage.color = timerColorGradient.Evaluate(timeImage.fillAmount);
        }

        if (scoreText != null)
        {
            if (currentDisplayedScore < targetScore)
            {
                currentDisplayedScore += scoreUpdateSpeed * Time.deltaTime;
                if (currentDisplayedScore >= targetScore)
                {
                    currentDisplayedScore = targetScore;
                }
                scoreText.text = Mathf.FloorToInt(currentDisplayedScore).ToString();

                // Apply pulse scale while increasing
                scoreText.transform.localScale = originalScoreScale * scorePulseScale;
                isPulsing = true;
            }
            else if (isPulsing)
            {
                // Smoothly return to the original scale
                scoreText.transform.localScale = Vector3.Lerp(scoreText.transform.localScale, originalScoreScale, Time.deltaTime * scorePulseSpeed);
                if (Vector3.Distance(scoreText.transform.localScale, originalScoreScale) < 0.01f)
                {
                    scoreText.transform.localScale = originalScoreScale;
                    isPulsing = false;
                }
            }
        }
    }

    /// <summary>
    /// Updates the radial timer image. Called every frame by the GameTimer.
    /// </summary>
    public void UpdateTimerDisplay(float currentTime, float maxTime)
    {
        if (maxTime > 0)
        {
            targetTimeRatio = currentTime / maxTime;

            if (timeImage != null)
            {
                // If there's a significant jump upwards in time (like starting a new level), animate the refill
                if (targetTimeRatio > timeImage.fillAmount + 0.05f)
                {
                    isAnimatingTimer = true;
                }

                // If not currently running an animation (draining or refilling), exactly match the real time
                if (!isAnimatingTimer)
                {
                    timeImage.fillAmount = targetTimeRatio;
                }
            }
        }
    }

    /// <summary>
    /// Updates the levels beaten display. Called by GameTimer.
    /// </summary>


    public void UpdateScoreDisplay(int score)
    {
        if (scoreText != null)
        {
            targetScore = score;
        }
    }

    public void ShowScoreAdded(int addedScore)
    {
        if (scoreAddedText != null)
        {
            if (scoreAddedCoroutine != null)
            {
                StopCoroutine(scoreAddedCoroutine);
            }
            scoreAddedText.text = "+" + addedScore.ToString();
            scoreAddedCoroutine = StartCoroutine(AnimateScoreAdded());
        }
    }

    private IEnumerator AnimateScoreAdded()
    {
        scoreAddedText.gameObject.SetActive(true);
        Vector2 startPos = scoreAddedOriginalPos;
        Vector2 endPos = startPos + Vector2.up * scoreAddedMoveDistance;
        Color c = scoreAddedText.color;
        
        // Fade in & move up
        float t = 0;
        while (t < scoreAddedAnimDuration)
        {
            t += Time.deltaTime;
            float normalizedTime = t / scoreAddedAnimDuration;
            
            c.a = Mathf.Lerp(0f, 1f, normalizedTime);
            scoreAddedText.color = c;
            
            scoreAddedText.rectTransform.anchoredPosition = Vector2.Lerp(startPos, endPos, normalizedTime);
            
            yield return null;
        }

        // Ensure we hit the exact target
        c.a = 1f;
        scoreAddedText.color = c;
        scoreAddedText.rectTransform.anchoredPosition = endPos;

        // Stay
        yield return new WaitForSeconds(scoreAddedStayDuration);

        // Fade out & move down (reverse)
        t = 0;
        while (t < scoreAddedAnimDuration)
        {
            t += Time.deltaTime;
            float normalizedTime = t / scoreAddedAnimDuration;
            
            c.a = Mathf.Lerp(1f, 0f, normalizedTime);
            scoreAddedText.color = c;
            
            scoreAddedText.rectTransform.anchoredPosition = Vector2.Lerp(endPos, startPos, normalizedTime);
            
            yield return null;
        }

        c.a = 0f;
        scoreAddedText.color = c;
        scoreAddedText.rectTransform.anchoredPosition = startPos;
        scoreAddedText.gameObject.SetActive(false);
    }

    /// <summary>
    /// Forces the timer target to 0 to make it disappear smoothly when a level is completed.
    /// </summary>
    public void DrainTimer()
    {
        targetTimeRatio = 0f;
        isAnimatingTimer = true;
    }

    public void ShowGameOverScreen(int score, int totalLevelsBeaten)
    {
        if (gameOverPanel != null)
        {
            // gameOverDetails.text = "Out of time!\nFinal Score: " + score.ToString() + "\nLevels Cleared: " + totalLevelsBeaten.ToString() + "\nPress R to Restart";
            gameOverDetails.text = "Out of time!\nLevels Cleared: " + totalLevelsBeaten.ToString() + "\nPress R to Restart";
            gameOverPanel.SetActive(true);
        }
    }

    /// <summary>
    /// Fades in the hint panel with the supplied message.
    /// Replaces any hint that is already showing.
    /// </summary>
    public void ShowHint(string message)
    {
        if (hintPanel == null || hintCanvasGroup == null) return;

        if (activeHintCoroutine != null)
            StopCoroutine(activeHintCoroutine);

        hintText.text       = message;
        activeHintCoroutine = StartCoroutine(FadeHint(0f, 1f, fadeDuration, hintDisplayDuration));
    }

    /// <summary>
    /// Fades out the hint panel. Called by LevelManager when the player exits a room.
    /// </summary>
    public void DismissHint()
    {
        if (hintPanel == null || hintCanvasGroup == null) return;
        if (hintCanvasGroup.alpha <= 0f) return;

        if (activeHintCoroutine != null)
            StopCoroutine(activeHintCoroutine);

        activeHintCoroutine = StartCoroutine(FadeHint(hintCanvasGroup.alpha, 0f, fadeDuration));
    }

    private IEnumerator FadeHint(float from, float to, float duration, float holdSeconds = 0f)
    {
        float elapsed = 0f;
        while (elapsed < duration)
        {
            elapsed              += Time.deltaTime;
            hintCanvasGroup.alpha = Mathf.Lerp(from, to, elapsed / duration);
            yield return null;
        }
        hintCanvasGroup.alpha = to;

        if (holdSeconds > 0f && to > 0f)
        {
            yield return new WaitForSeconds(holdSeconds);
            yield return FadeHint(1f, 0f, fadeDuration);
        }

        activeHintCoroutine = null;
    }
}
