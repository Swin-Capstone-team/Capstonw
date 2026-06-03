using UnityEngine;

public class GameController : MonoBehaviour
{
    private PlayerInputState _input;
    private PlayerInputState _pause;
    public GameObject pauseMenu; // Reference to the pause menu UI
    private bool isPaused = false;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        pauseMenu.SetActive(false);

        _input ??= GetComponentInParent<PlayerInputState>();
        _pause ??= GetComponentInParent<PlayerInputState>();  

    }

    private InputSystem_Actions _actions;

    private void Awake()
    {
        _actions = new InputSystem_Actions();
    }

    private void OnEnable()
    {
        _actions.Player.Enable();
    }

    private void OnDisable()
    {
        _actions.Player.Disable();
    }

    // Update is called once per frame
    void Update()
    {
        if (_actions.Player.Restart.WasPressedThisFrame())
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
            Cursor.visible = false; // Hide the cursor
            Cursor.lockState = CursorLockMode.Locked; // Lock the cursor to the center of the screen
        }

        else if (isPaused)
        {
            Debug.Log("Pausing game...");
            Time.timeScale = 0f; // Pause the game
            Cursor.visible = true; // Lock the cursor
            Cursor.lockState = CursorLockMode.None;
            pauseMenu.SetActive(true); // Show the pause menu

        }
    }
    
    public void Resume()
    {
        Debug.Log("Resume called on: " + gameObject.name + " ID: " + GetInstanceID());
        Debug.Log("Resuming game...");
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

