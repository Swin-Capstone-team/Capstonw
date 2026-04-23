using UnityEngine;
using UnityEngine.AI;

[RequireComponent(typeof(NavMeshAgent))]
public abstract class EnemyBase : MonoBehaviour, IDamageable
{
    [Header("Base References")]
    public NavMeshAgent navMeshAgent;
    public Transform target;

    protected StateMachine stateMachine;

    protected virtual void Awake()
    {
        navMeshAgent = GetComponent<NavMeshAgent>();
        stateMachine = new StateMachine();
    }

    protected virtual void Update()
    {
        stateMachine?.Tick();
    }

    // Shared utility for all enemies
    public bool HasLineOfSight(float eyeHeight = 1.5f)
    {
        Vector3 start = transform.position + Vector3.up * eyeHeight;
        Vector3 end = target.position + Vector3.up * eyeHeight;

        if (Physics.Linecast(start, end, out RaycastHit hit))
        {
            return hit.transform == target;
        }
        return false;
    }

    public void TakeDamage(float damage)
    {
        if (TryGetComponent<EnemyHealth>(out var health))
            {
                health.TakeDamage(damage);
            }    
    }
}