using System.Security.AccessControl;
using UnityEngine;

public class Restart : MonoBehaviour
{
    private PlayerInputState _input;
    private PlayerInputState _pause;
    public GameObject pauseMenu; // Reference to the pause menu UI
    private bool isPaused = false;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        _input ??= GetComponentInParent<PlayerInputState>();
        _pause ??= GetComponentInParent<PlayerInputState>();

        if (_input != null) return;
        if (_pause != null) return;

        Debug.LogError("Restart requires PlayerInputState on this object or a parent.", this);
        enabled = false;
    }

    // Update is called once per frame
    void Update()
    {
        if (_input.RestartPressedThisFrame)
        {
            Debug.Log("Restarting level...");
            Time.timeScale = 1f; // Ensure time is running before restarting
            UnityEngine.SceneManagement.SceneManager.LoadScene(UnityEngine.SceneManagement.SceneManager.GetActiveScene().buildIndex);
        }

        if (_pause.PausePressedThisFrame)
        {
            //Toggle pause state
            TogglePause();
        }

    }

    public void TogglePause()
    {
        isPaused = !isPaused;
        if (!isPaused)
        {
            Debug.Log("Resuming game...");
            Time.timeScale = 1f; // Resume the game
            pauseMenu.SetActive(false); // Hide the pause menu
        }

        if (isPaused)
        {
            Debug.Log("Pausing game...");
            Time.timeScale = 0f; // Pause the game
            Cursor.visible = true; // Lock the cursor

            pauseMenu.SetActive(true); // Show the pause menu

        }
    }
    
    public void Resume()
    {

        isPaused = false;

        pauseMenu.SetActive(false);

        Time.timeScale = 1f;

        Cursor.visible = false;

        Cursor.lockState = CursorLockMode.Locked;

    }

    public void Quit()
    {
        Application.Quit();
    }
}

