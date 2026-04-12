using UnityEngine;
using System.Collections; // Required for Coroutines

[RequireComponent(typeof(Renderer))]
public class EnemyHealth : Health
{
    [Header("Enemy Feedback")]
    public float flashDuration = 0.25f;
    private Renderer rend;
    private Color originalColor;
    private float flashTimer;
    private Rigidbody rb;
    
    private UnityEngine.AI.NavMeshAgent agent;

    protected override void Start()
    {
        base.Start(); 
        rend = GetComponentInChildren<Renderer>();
        rb = GetComponent<Rigidbody>();
        agent = GetComponent<UnityEngine.AI.NavMeshAgent>();

        if (rend != null) originalColor = rend.material.color;
        
        if (rb != null) rb.isKinematic = true;
    }

    public void TakeHit(float damage, Vector3 dir, float force)
    {
        TakeDamage(damage); 

        if (rend != null)
        {
            rend.material.color = Color.red;
            flashTimer = flashDuration;
        }

        if (rb != null && agent != null)
        {
            StopAllCoroutines(); 
            StartCoroutine(HandleKnockback(dir, force));
        }
    }

    private IEnumerator HandleKnockback(Vector3 dir, float force)
    {
        agent.enabled = false;
        rb.isKinematic = false;

        Vector3 finalDir = dir + Vector3.up * 0.5f;
        rb.AddForce(finalDir.normalized * force, ForceMode.VelocityChange);

        yield return new WaitForFixedUpdate();

        while (rb.linearVelocity.magnitude > 0.2f)
        {
            yield return null;
        }

        rb.isKinematic = true;
        agent.enabled = true;
    }

    void Update()
    {
        if (flashTimer > 0f)
        {
            flashTimer -= Time.deltaTime;
            if (flashTimer <= 0f && rend != null) rend.material.color = originalColor;
        }
    }
}