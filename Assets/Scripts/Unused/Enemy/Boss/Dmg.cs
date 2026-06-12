using UnityEngine;
using System.Linq;
using System.Collections.Generic;


public class Dmg : MonoBehaviour
{
    public UIManager uiManager; // Reference to the UI Manager
    public GameTimer gameTimer;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        gameTimer = FindFirstObjectByType<GameTimer>();
    }

    // Update is called once per frame
    void Update()
    {

    }

    void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player")) // Check if the collided object is the player
        {
            gameTimer.TriggerGameOver();
            //Debug.Log("Player hit! Damage inflicted: " + damageAmount);
        }
    }
    // private void TriggerGameOver()
    // {
    //     isTimerRunning = false;
    //     uiManager.ShowGameOverScreen(score, roomCompletionCounts.Values.Sum());
        
    //     // Add your logic here to freeze the player or stop game time
    //     Time.timeScale = 0f;
    // }
}
