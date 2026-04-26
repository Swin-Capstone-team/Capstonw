using UnityEngine;
using UnityEngine.UI;

public class SpeedBar : MonoBehaviour
{
    private Slider slider;
    public PlayerMove playerMove;
    
    void Start()
    {
        slider = GetComponent<Slider>();
    }

    void Update()
    {
        slider.value = playerMove.currentSpeed / playerMove.sprintSpeed;
    }
}
