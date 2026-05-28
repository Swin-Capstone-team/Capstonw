using UnityEngine;
using TMPro;

public class CharacterLogging : MonoBehaviour
{
    [SerializeField] private CharacterController playerController;
    [SerializeField] private TMP_Text velocityText;

    void Update()
    {
        Vector3 vel = playerController.Motor.Velocity;
        velocityText.text = $"Velocity: {vel:F2}\nSpeed: {vel.magnitude:F2}";
    }
}
