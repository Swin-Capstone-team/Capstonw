using UnityEngine;

public class GameSettingsManager : MonoBehaviour
{

    public static GameSettingsManager Instance { get; private set; }

    public float FieldOfView { get; set; }
    public float CameraSensitivity { get; set; }

    public Camera camera;
    public CharacterCamera cameraController;
    private void Awake()
    {
        if (Instance != null && Instance != this)
        {
            Destroy(gameObject);
            return;
        }

        Instance = this;
    }

    public void Apply()
    {
        if (camera == null || cameraController == null) return;
        camera.fieldOfView = 50f + FieldOfView * 5;
        cameraController.RotationSpeed = 0.005f + CameraSensitivity/100;
    }
}
