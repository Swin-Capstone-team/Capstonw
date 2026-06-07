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

    private float targetTimeRatio = 1f;
    private float currentDisplayedScore = 0f;
    private int targetScore = 0;
    private Vector3 originalScoreScale;
    private bool isPulsing = false;
    
    private Coroutine scoreAddedCoroutine;
    private Vector2 scoreAddedOriginalPos;

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
        
        UpdateLevelsBeatenDisplay(0);
        UpdateScoreDisplay(0);
    }

    private void Update()
    {
        if (timeImage != null)
        {
            // Smoothly move the fill amount towards the target ratio
            timeImage.fillAmount = Mathf.Lerp(timeImage.fillAmount, targetTimeRatio, Time.deltaTime * fillLerpSpeed);
            
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
        }
    }

    /// <summary>
    /// Updates the levels beaten display. Called by GameTimer.
    /// </summary>

    public void UpdateLevelsBeatenDisplay(int totalLevelsBeaten)
    {
        if (levelsBeatenText != null)
        {
            levelsBeatenText.text = "Levels Cleared: " + totalLevelsBeaten.ToString();
        }
    }

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
    }

    public void ShowGameOverScreen(int score)
    {
        if (gameOverPanel != null)
        {
            gameOverDetails.text = "Out of time!\nFinal Score: " + score.ToString() + "\nLevels Cleared: " + levelsBeatenText.text.Split(':')[1].Trim() + "\nPress R to Restart";
            gameOverPanel.SetActive(true);
        }
    }
}
