using UnityEngine;

[DisallowMultipleComponent]
public class PlayerHealth : Health
{
    public Animator animator;
    public float hitStunTime = 0.25f;
    public float currentHealth;
    private float hitTimer = 0f;

    protected override void Start()
    {
        base.Start();
    }

    void Update()
    {
        if (hitTimer > 0f)
        {
            hitTimer -= Time.deltaTime;
            // Restore movement control after hitstun ends
        }
        if (currentHealth <= 0f && !isDead)
        {
            Die();
        }
    }

    public override void TakeDamage(DamageInfo info)
    {
        if (isDead) return;

        // Trigger the Hit animation
        if (animator != null) animator.SetTrigger("Hit");

        // Disable movement for a short duration
        hitTimer = hitStunTime;

        base.TakeDamage(info);
    }

    protected override void Die()
    {
        if (isDead) return;
        isDead = true;

        if (animator != null) animator.SetTrigger("Die");
    }
}
