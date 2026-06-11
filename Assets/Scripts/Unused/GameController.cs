using UnityEngine;
using UnityEngine.SceneManagement;

public class GameController : MonoBehaviour
{
    public GameObject pauseMenu; // Reference to the pause menu UI
    
    private PlayerInputState _playerInput;
    private InputSystem_Actions _actions;
    private bool isPaused = false;

    private void Awake()
    {
        //_actions = new InputSystem_Actions();
    }

    private void OnEnable()
    {
        _actions.Player.Enable();
    }

    private void OnDisable()
    {
        _actions.Player.Disable();
    }

    private void Start()
    {
        if (pauseMenu != null)
        {
            pauseMenu.SetActive(false);
        }

        //_playerInput ??= GetComponentInParent<PlayerInputState>();
    }

    private void Update()
    {
        if (_actions.Player.Restart.WasPressedThisFrame())
        {
            RestartLevel();
        }

        if (_playerInput != null && _playerInput.PausePressedThisFrame)
        {
            TogglePause();
        }
    }

    public void TogglePause()
    {
        if (isPaused)
        {
            Resume();
        }
        else
        {
            Pause();
        }
    }

    public void Pause()
    {
        if (isPaused) return;

        Debug.Log("Pausing game...");
        isPaused = true;
        Time.timeScale = 0f; // Pause the game
        
        Cursor.visible = true; // Show the cursor
        Cursor.lockState = CursorLockMode.None; // Unlock the cursor
        
        if (pauseMenu != null)
        {
            pauseMenu.SetActive(true); // Show the pause menu
        }
    }
    
    public void Resume()
    {
        if (!isPaused) return;

        Debug.Log("Resume called on: " + gameObject.name + " ID: " + GetInstanceID());
        Debug.Log("Resuming game...");
        isPaused = false;
        Time.timeScale = 1f; // Resume the game
        
        Cursor.visible = false; // Hide the cursor
        Cursor.lockState = CursorLockMode.Locked; // Lock the cursor to the center of the screen

        if (pauseMenu != null)
        {
            pauseMenu.SetActive(false); // Hide the pause menu
        }
    }

    private void RestartLevel()
    {
        Debug.Log("Restarting level...");
        Time.timeScale = 1f; // Ensure time is running before restarting
        SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
    }

    public void Quit()
    {
        Application.Quit();
    }
}

