using UnityEngine;
using UnityEngine.UI;

public class PlayerHealthUI : MonoBehaviour
{
    public Health playerHealth;
    public Slider slider;

    void Start()
    {
        if (slider == null)
            slider = GetComponentInChildren<Slider>();

        UpdateBar();
    }

    void Update()
    {
        UpdateBar();
    }

    private void UpdateBar()
    {
        if (playerHealth == null || slider == null) return;

        slider.minValue = 0f;
        slider.maxValue = playerHealth.maxHealth;
        slider.value = playerHealth.CurrentHealth;
    }
}