using UnityEngine;

[RequireComponent(typeof(Renderer))]
public class Enemy : MonoBehaviour
{
    public float flashDuration = 0.25f;

    private Renderer rend;
    private Color originalColor;
    private float flashTimer = 0f;

    void Start()
    {
        rend = GetComponent<Renderer>();
        originalColor = rend.material.color;
    }

    void Update()
    {
        if (flashTimer > 0f)
        {
            flashTimer -= Time.deltaTime;

            if (flashTimer <= 0f)
            {
                rend.material.color = originalColor;
            }
        }
    }

    public void TakeHit(Vector3 dir, float force)
    {
        rend.material.color = Color.red;
        flashTimer = flashDuration;

        Rigidbody rb = GetComponent<Rigidbody>();
        if (rb != null)
        {
            Vector3 finalDir = dir + Vector3.up * 0.5f;
            rb.AddForce(finalDir.normalized * force, ForceMode.VelocityChange);
        }
    }
}