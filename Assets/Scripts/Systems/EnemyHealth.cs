using UnityEngine;
using System.Collections;

public class EnemyHealth : Health
{
    [Header("Enemy Feedback")]
    public float flashDuration = 0.2f;
    private Renderer rend;
    private Color originalColor;
    private Rigidbody rb;
    private UnityEngine.AI.NavMeshAgent agent;

    protected override void Start()
    {
        base.Start();
        rend = GetComponentInChildren<Renderer>();
        rb = GetComponent<Rigidbody>();
        agent = GetComponent<UnityEngine.AI.NavMeshAgent>();

        if (rend != null) originalColor = rend.material.color;
        if (rb != null) rb.isKinematic = true; // Use kinematic while NavMesh is moving
    }

    public override void TakeDamage(DamageInfo info)
    {
        // Call base logic (subtracts HP, spawns text)
        base.TakeDamage(info);

        // Visual Flash
        if (rend != null) StartCoroutine(FlashRoutine());

        // Physics Knockback
        if (rb != null && agent != null)
        {
            StopAllCoroutines(); 
            StartCoroutine(HandleKnockback(info.direction, info.force));
        }
    }

    private IEnumerator FlashRoutine()
    {
        rend.material.color = Color.red;
        yield return new WaitForSeconds(flashDuration);
        rend.material.color = originalColor;
    }

    private IEnumerator HandleKnockback(Vector3 dir, float force)
    {
        agent.enabled = false;
        rb.isKinematic = false;

        // Apply force (adding a slight lift)
        Vector3 finalDir = dir + Vector3.up * 0.5f;
        rb.AddForce(finalDir.normalized * force, ForceMode.VelocityChange);

        yield return new WaitForFixedUpdate();

        // Wait until the enemy stops sliding
        while (rb.linearVelocity.magnitude > 0.2f) yield return null;

        rb.isKinematic = true;
        agent.enabled = true;
    }
}