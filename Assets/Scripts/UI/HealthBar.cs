using UnityEngine;
using UnityEngine.UI;

public class HealthBar : MonoBehaviour
{
    public Health targetHealth;
    public Slider slider;
    public bool isWorldSpace = true;
    public Vector3 offset = new Vector3(0, 2f, 0);

    private Camera cam;

    void Start()
    {
        cam = Camera.main;

        if (targetHealth != null && slider != null)
        {
            // Set initial values
            UpdateSlider(targetHealth.CurrentHealth);
        }
    }

    void LateUpdate()
    {
        if (!isWorldSpace || targetHealth == null) return;

        transform.position = targetHealth.transform.position + offset;

        if (cam != null)
        {
            transform.forward = cam.transform.forward;
        }

    }

    public void UpdateSlider(float currentHP)
    {
        if (slider != null && targetHealth != null)
        {
            slider.maxValue = targetHealth.maxHealth;
            slider.value = currentHP;
        }
    }
}