using UnityEngine;

public class Health : MonoBehaviour
{
    public float maxHealth = 100f;

    [Header("Damage Text")]
    public GameObject damageTextPrefab;
    public Transform damageTextSpawnPoint;

    [Header("Health Bar")]
    public GameObject healthBarPrefab;

    private float currentHealth;
    private GameObject healthBarInstance;

    private int lastRegisteredAttackId = -1;

    public float CurrentHealth => currentHealth;

    protected virtual void Awake()
    {
        currentHealth = maxHealth;
    }

    protected virtual void Start()
    {
        if (healthBarPrefab != null)
        {
            healthBarInstance = Instantiate(healthBarPrefab, transform.position, Quaternion.identity);

            EnemyHealthBar hpBar = healthBarInstance.GetComponentInChildren<EnemyHealthBar>();
            if (hpBar != null)
            {
                hpBar.Setup(this);
            }
        }
    }

    public virtual void TakeDamage(float damage)
    {
        currentHealth -= damage;
        currentHealth = Mathf.Max(currentHealth, 0f);

        Debug.Log(gameObject.name + " took " + damage + " damage. HP left = " + currentHealth);

        if (damageTextPrefab != null)
        {
            Vector3 spawnPos = transform.position + Vector3.up * 0.1f;

            if (damageTextSpawnPoint != null)
                spawnPos = damageTextSpawnPoint.position;

            GameObject textObj = Instantiate(damageTextPrefab, spawnPos, Quaternion.identity);

            FloatingDamage floatingDamage = textObj.GetComponent<FloatingDamage>();
            if (floatingDamage != null)
                floatingDamage.SetText(damage.ToString("0"));
        }

        if (currentHealth <= 0f)
        {
            Die();
        }
    }

    public bool TryTakeDamageFromAttack(float damage, int attackId)
    {
        if (attackId == -1) return false;

        if (attackId == lastRegisteredAttackId)
        {
            Debug.Log(gameObject.name + " ignored duplicate hit from attackId " + attackId);
            return false;
        }

        lastRegisteredAttackId = attackId;
        TakeDamage(damage);
        return true;
    }

    public void ResetHealth()
    {
        currentHealth = maxHealth;
        lastRegisteredAttackId = -1;
    }

    protected virtual void Die()
    {
        if (healthBarInstance != null)
            Destroy(healthBarInstance);

        Destroy(gameObject);
    }
}