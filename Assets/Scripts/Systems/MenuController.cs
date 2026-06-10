
using UnityEngine;
using UI.Menus.OptionsMenu;
using UnityEngine.SceneManagement;

public class MenuController : MonoBehaviour, IMenu
{
    [Header("Flow")]
    [SerializeField] private string mainMenuSceneName = "MainMenu";
    private PlayerInputState _input;
    public GameObject pauseMenu;
    public OptionsMenuEvents _optionsMenu;
    public bool isPaused = false;
    private bool inOptions = false;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        pauseMenu.SetActive(false);
        isPaused = false;
        _input ??= GetComponentInParent<PlayerInputState>();
    }

    // Update is called once per frame
    void Update()
    {
        if (_input.RestartPressedThisFrame)
        {
            Time.timeScale = 1f; // Ensure time is running before restarting
            UnityEngine.SceneManagement.SceneManager.LoadScene(UnityEngine.SceneManagement.SceneManager.GetActiveScene().buildIndex);
        }

        if (_input.PausePressedThisFrame)
        {
            //Toggle pause state
            TogglePause();
        }

    }

    public void TogglePause()
    {
        if(inOptions) return;

        isPaused = !isPaused;
        
        if (!isPaused)
        {
            Time.timeScale = 1f; // Resume the game
            pauseMenu.SetActive(false); // Hide the pause menu
            Cursor.visible = false; // Hide the cursor
            Cursor.lockState = CursorLockMode.Locked; // Lock the cursor to the center of the screen
        }

        else if (isPaused)
        {
            pauseMenu.SetActive(true); // Show the pause menu
            Time.timeScale = 0.0001f; // Pause the game
            Cursor.visible = true; // Lock the cursor
            Cursor.lockState = CursorLockMode.None;
        }
    }

    public void ShowOptions()
    {
        inOptions = true;
        _optionsMenu.Show(this);
        
    }

    public void ToMainMenu()
    { 
        isPaused = false;
        Time.timeScale = 1f;
        SceneManager.LoadSceneAsync(mainMenuSceneName);
    }

    public void Show()
    {
        inOptions = false;
        //pauseMenu.SetActive(true);
    }

    public void Hide()
    {
        //pauseMenu.SetActive(false);
    }

    

   
}

