using System.Collections;
using UnityEngine;
using UnityEngine.UI;
using TMPro; // Required for TextMeshPro

public class UIManager : MonoBehaviour
{
    [Header("UI Elements")]
    public Slider timeSlider;
    public TMP_Text levelsBeatenText;
    public TMP_Text scoreText;
    public TMP_Text gameOverDetails;
    public GameObject gameOverPanel;

    [Header("Hint UI")]
    [Tooltip("Panel anchored to the bottom-centre of the canvas. Needs a CanvasGroup component.")]
    public RectTransform hintPanel;
    [Tooltip("TextMeshPro label inside the hint panel.")]
    public TMP_Text hintText;
    [Tooltip("Seconds to fade the hint in / out.")]
    public float fadeDuration = 0.35f;
    [Tooltip("Seconds the hint stays fully visible before auto-dismissing. 0 = stay until the player leaves the room.")]
    public float hintDisplayDuration = 0f;

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
        
        UpdateLevelsBeatenDisplay(0);
        UpdateScoreDisplay(0);
    }

    /// <summary>
    /// Updates the slider value. Called every frame by the GameTimer.
    /// </summary>
    public void UpdateTimerDisplay(float currentTime, float maxTime)
    {
        if (timeSlider != null)
        {
            timeSlider.maxValue = maxTime;
            timeSlider.value = currentTime;
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
            scoreText.text = "Score: " + score.ToString();
        }
    }

    public void ShowGameOverScreen(int score)
    {
        if (gameOverPanel != null)
        {
            gameOverDetails.text = "Out of time!\nFinal Score: " + score.ToString() + "\nPress R to restart";
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
