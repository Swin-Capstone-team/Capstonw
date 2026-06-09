using UnityEngine;
using UnityEngine.AI;

[RequireComponent(typeof(NavMeshAgent))]
public abstract class EnemyBase : MonoBehaviour, IBaseEnemy
{
    [Header("Base References")]
    private NavMeshAgent _navMeshAgent;
    public NavMeshAgent navMeshAgent => _navMeshAgent;
    public Transform target;
    public MeshRenderer meshRenderer;
    public Color CurrentStateColor { get; private set; } = Color.grey;

    protected StateMachine stateMachine;

    protected virtual void Awake()
    {
        _navMeshAgent = GetComponent<NavMeshAgent>();
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

    public void ChangeVisualState(Color stateColor)
    {
        CurrentStateColor = stateColor;
        if (meshRenderer != null)
        {
            meshRenderer.material.color = stateColor;
        }
    }

}