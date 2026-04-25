using UnityEngine;

[DisallowMultipleComponent]
public class PlayerHealth : Health
{
    public Animator animator;
    public float hitStunTime = 0.2f;

    private bool isDead = false;
    private float hitTimer = 0f;
    private PlayerMove move;

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

            if (hitTimer <= 0f && move != null && !isDead)
            {
                move.enabled = true;
            }
        }

        // Test keys
        if (Input.GetKeyDown(KeyCode.K))
        {
            TakeDamage(1000f);
        }

        if (Input.GetKeyDown(KeyCode.H))
        {
            TakeDamage(10f);
        }
    }

    public override void TakeDamage(float damage)
    {
        if (isDead) return;

        // small damage = hit animation
        if (damage < 1000f && animator != null)
        {
            animator.ResetTrigger("Hit");
            animator.SetTrigger("Hit");
        }

        hitTimer = hitStunTime;

        if (move != null)
        {
            move.enabled = false;
        }

        base.TakeDamage(damage);
    }

    protected override void Die()
    {
        if (isDead) return;
        isDead = true;

        if (animator != null)
        {
            animator.ResetTrigger("Hit");
            animator.SetTrigger("Die");
        }

        if (move != null)
        {
            move.enabled = false;
        }
    }
}
