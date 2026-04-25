using UnityEngine;

public class PlayerHealth : Health
{
    public Animator animator;
    public float hitStunTime = 0.25f;
    private PlayerMove move;
    private float hitTimer = 0f;

    protected override void Start()
    {
        base.Start();
        move = GetComponent<PlayerMove>();
    }

    void Update()
    {
        if (hitTimer > 0f)
        {
            hitTimer -= Time.deltaTime;
            // Restore movement control after hitstun ends
            if (hitTimer <= 0f && move != null && !isDead) move.enabled = true;
        }
    }

    public override void TakeDamage(DamageInfo info)
    {
        if (isDead) return;

        // Trigger the Hit animation
        if (animator != null) animator.SetTrigger("Hit");

        // Disable movement for a short duration
        hitTimer = hitStunTime;
        if (move != null) move.enabled = false;

        base.TakeDamage(info);
    }

    protected override void Die()
    {
        if (isDead) return;
        isDead = true;

        if (animator != null) animator.SetTrigger("Die");
        if (move != null) move.enabled = false;
    }
}