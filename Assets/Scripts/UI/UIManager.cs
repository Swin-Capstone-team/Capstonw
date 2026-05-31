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
}
