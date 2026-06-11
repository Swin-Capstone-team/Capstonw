using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class GameTimer : MonoBehaviour
{
    [Header("References")]
    public UIManager uiManager;

    private float currentTime;
    private float decayMultiplier;
    private float maxTimeForCurrentLevel;
    private bool isTimerRunning = false;

    // Dictionary to track how many times the player has completed specific rooms
    private Dictionary<string, int> roomCompletionCounts = new Dictionary<string, int>();

    private int score;

    private void Update()
    {
        if (!isTimerRunning) return;

        currentTime -= Time.deltaTime;
        
        // Update the UI every frame
        uiManager.UpdateTimerDisplay(currentTime, maxTimeForCurrentLevel);

        if (currentTime <= 0f)
        {
            TriggerGameOver();
        }
    }

    /// <summary>
    /// Called by the LevelManager when the player enters a new room.
    /// </summary>
    public void StartTimerForLevel(Level level)
    {
        if (level.isHallway)
        {
            // Pause the timer in hallways to give the player a breather
            isTimerRunning = false;
            return;
        }

        // Check how many times this specific room has been completed
        int timesCompleted = 0;
        if (roomCompletionCounts.ContainsKey(level.levelID))
        {
            timesCompleted = roomCompletionCounts[level.levelID];
        }

        // Calculate the decayed time: defaultTime / (decayRate ^ timesCompleted)
        decayMultiplier = Mathf.Pow(level.decayRate, timesCompleted);
        maxTimeForCurrentLevel = level.defaultTime / decayMultiplier;
        
        currentTime = maxTimeForCurrentLevel;
        isTimerRunning = true;
    }

    /// <summary>
    /// Called by the LevelManager when a room is successfully exited.
    /// </summary>
    public void RecordLevelCompletion(Level level)
    {
        if (level.isHallway) return;

        isTimerRunning = false; // Stop the timer so it doesn't immediately overwrite the drain animation

        // Increment the completion count for this specific room
        if (roomCompletionCounts.ContainsKey(level.levelID))
        {
            roomCompletionCounts[level.levelID]++;
        }
        else
        {
            roomCompletionCounts.Add(level.levelID, 1);
        }

        int addedScore = Mathf.RoundToInt(100 * currentTime/maxTimeForCurrentLevel * decayMultiplier);
        score += addedScore;
        
        uiManager.UpdateLevelsBeatenDisplay(roomCompletionCounts.Values.Sum());
        uiManager.UpdateScoreDisplay(score);
        uiManager.ShowScoreAdded(addedScore);
        uiManager.DrainTimer();

    }

    private void TriggerGameOver()
    {
        isTimerRunning = false;
        uiManager.ShowGameOverScreen(score);
        
        // Add your logic here to freeze the player or stop game time
        Time.timeScale = 0f;
    }
}