using UnityEngine;
using UnityEngine.UI;
using TMPro; // Required for TextMeshPro

public class UIManager : MonoBehaviour
{
    [Header("UI Elements")]
    public Slider timeSlider;
    public TMP_Text levelsBeatenText;
    public GameObject gameOverPanel;

    private int totalLevelsBeaten = 0;

    private void Start()
    {
        // Ensure the game over panel is hidden when the game starts
        if (gameOverPanel != null)
        {
            gameOverPanel.SetActive(false);
        }
        
        UpdateLevelsBeatenDisplay();
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
    /// Increments and updates the global score. Called by LevelManager or GameTimer.
    /// </summary>
    public void IncrementLevelsBeaten()
    {
        totalLevelsBeaten++;
        UpdateLevelsBeatenDisplay();
    }

    private void UpdateLevelsBeatenDisplay()
    {
        if (levelsBeatenText != null)
        {
            levelsBeatenText.text = "Levels Cleared: " + totalLevelsBeaten.ToString();
        }
    }

    public void ShowGameOverScreen()
    {
        if (gameOverPanel != null)
        {
            gameOverPanel.SetActive(true);
        }
    }
}
