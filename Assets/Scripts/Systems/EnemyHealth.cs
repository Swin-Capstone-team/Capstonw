using UnityEngine;
using System.Collections;

public class EnemyHealth : Health
{
    [Header("Enemy Feedback")]
    public float flashDuration = 0.2f;
    private Renderer rend;
    private Rigidbody rb;
    private UnityEngine.AI.NavMeshAgent agent;
    
    private EnemyBase enemyBase; 

    protected override void Start()
    {
        base.Start();
        rend = GetComponentInChildren<Renderer>();
        rb = GetComponent<Rigidbody>();
        agent = GetComponent<UnityEngine.AI.NavMeshAgent>();
        enemyBase = GetComponent<EnemyBase>();

        if (rb != null) rb.isKinematic = true; 
    }

    public override void TakeDamage(DamageInfo info)
    {
        base.TakeDamage(info);

        if (rend != null) 
        {
            StopCoroutine(nameof(FlashRoutine)); 
            StartCoroutine(FlashRoutine());
        }

        if (rb != null && agent != null)
        {
            StartCoroutine(HandleKnockback(info.direction, info.force));
        }
    }

    private IEnumerator FlashRoutine()
    {
        rend.material.color = Color.red; 
        yield return new WaitForSeconds(flashDuration);

        if (enemyBase != null)
        {
            rend.material.color = enemyBase.CurrentStateColor;
        }
        else
        {
            rend.material.color = Color.grey;
        }
    }

    private IEnumerator HandleKnockback(Vector3 dir, float force)
    {
        agent.enabled = false;
        rb.isKinematic = false;

        Vector3 finalDir = dir + Vector3.up * 0.5f;
        rb.AddForce(finalDir.normalized * force, ForceMode.VelocityChange);

        yield return new WaitForFixedUpdate();

        while (rb.linearVelocity.magnitude > 0.2f) yield return null;

        rb.isKinematic = true;
        
        if (currentHealth > 0) agent.enabled = true; 
    }
}