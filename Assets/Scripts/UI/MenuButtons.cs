using UnityEngine;

public class MenuButtons : MonoBehaviour
{
    public MenuController pauseScript; // Reference to the MenuController script
    public GameObject pauseMenu; // Reference to the pause menu UI
    public Animator buttonAnimator; // Reference to the Animator component for button animations
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
    }

    // Update is called once per frame
    void Update()
    {

    }

    public void Resume()
    {
        Debug.Log("Resuming game...");
        pauseScript.isPaused = false; // Set the pause state to false
        Time.timeScale = 1f; // Resume the game
        Cursor.visible = false; // Hide the cursor
        Cursor.lockState = CursorLockMode.Locked; // Lock the cursor to the center of the screen
        pauseMenu.SetActive(false); // Hide the pause menu
        AudioManager.Instance.PlaySFX("menuSelect");
    }
    
    public void Quit()
    {
        AudioManager.Instance.PlaySFX("menuSelect");
        pauseScript.ToMainMenu();
    }
}
