using UnityEngine;

public class Restart : MonoBehaviour
{
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
    }
}
