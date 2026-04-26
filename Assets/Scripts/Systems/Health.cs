using UnityEngine;
using UnityEngine.Events;

public class Health : MonoBehaviour, IDamageable
{
    [Header("Base Health Settings")]
    public float maxHealth = 100f;
    public GameObject damageTextPrefab;
    public Transform damageTextSpawnPoint;

    public float CurrentHealth => currentHealth;

    [Header("Events")]
    public UnityEvent<float> OnHealthChanged;

    protected float currentHealth;
    protected bool isDead = false;

    protected virtual void Start()
    {
        currentHealth = maxHealth;
        OnHealthChanged?.Invoke(currentHealth);
    }

    // Required by IDamageable. 'virtual' allows subclasses to add their own logic.
    public virtual void TakeDamage(DamageInfo info)
    {
        if (isDead) return;

        currentHealth -= info.amount;
        currentHealth = Mathf.Max(currentHealth, 0f);

        OnHealthChanged?.Invoke(currentHealth);

        // Spawn floating text if a prefab is assigned
        if (damageTextPrefab != null)
        {
            Vector3 spawnPos = damageTextSpawnPoint != null ? damageTextSpawnPoint.position : transform.position + Vector3.up;
            GameObject textObj = Instantiate(damageTextPrefab, spawnPos, Quaternion.identity);
            if (textObj.TryGetComponent(out FloatingDamage fd)) fd.SetText(info.amount.ToString("0"));
        }

        if (currentHealth <= 0f) Die();
    }

    protected virtual void Die()
    {
        if (isDead) return;
        isDead = true;
        Destroy(gameObject);
    }
}