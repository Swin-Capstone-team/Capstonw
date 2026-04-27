using UnityEngine;

public class Restart : MonoBehaviour
{
    private PlayerInputState _input;

    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        _input ??= GetComponentInParent<PlayerInputState>();

        if (_input != null) return;

        Debug.LogError("Restart requires PlayerInputState on this object or a parent.", this);
        enabled = false;
    }

    // Update is called once per frame
    void Update()
    {
        if (_input.RestartPressedThisFrame)
        {
            Debug.Log("Restarting level...");
            UnityEngine.SceneManagement.SceneManager.LoadScene(UnityEngine.SceneManagement.SceneManager.GetActiveScene().buildIndex);
        }
    }
}
