using UnityEngine;
using UnityEngine.UI;

public class EnemyHealthBar : MonoBehaviour
{
    public Health targetHealth;
    public Slider slider;
    public Vector3 offset = new Vector3(0, 2f, 0);

    private Camera cam;

    void Awake()
    {
        if (slider == null)
            slider = GetComponentInChildren<Slider>();
    }

    void Start()
    {
        cam = Camera.main;
    }

    void LateUpdate()
    {
        if (targetHealth == null)
        {
            Destroy(gameObject);
            return;
        }

        if (slider == null) return;

        transform.position = targetHealth.transform.position + offset;

        if (cam != null)
            transform.forward = cam.transform.forward;

        slider.minValue = 0f;
        slider.maxValue = targetHealth.maxHealth;
        slider.value = targetHealth.CurrentHealth;
    }

    public void Setup(Health health)
    {
        targetHealth = health;
    }
}