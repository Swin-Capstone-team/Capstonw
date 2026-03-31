using UnityEngine;

public class Health : MonoBehaviour
{
    public float maxHealth = 100f;
    public GameObject damageTextPrefab;
    public Transform damageTextSpawnPoint;

    private float currentHealth;
    public float CurrentHealth => currentHealth;

    protected virtual void Start()
    {
        currentHealth = maxHealth;
    }

    public virtual void TakeDamage(float damage)
    {
        currentHealth -= damage;
        currentHealth = Mathf.Max(currentHealth, 0f);

        if (damageTextPrefab != null)
        {
            Vector3 spawnPos = transform.position + Vector3.up * 0.1f;

            if (damageTextSpawnPoint != null)
            {
                spawnPos = damageTextSpawnPoint.position;
            }

            GameObject textObj = Instantiate(damageTextPrefab, spawnPos, Quaternion.identity);

            FloatingDamage floatingDamage = textObj.GetComponent<FloatingDamage>();
            if (floatingDamage != null)
            {
                floatingDamage.SetText(damage.ToString("0"));
            }
        }

        if (currentHealth <= 0f)
        {
            Die();
        }
    }

    public void ResetHealth()
    {
        currentHealth = maxHealth;
    }

    protected virtual void Die()
    {
        Destroy(gameObject);
    }
}