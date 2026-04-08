using UnityEngine;

public class EnemyChase : IState
{
    private readonly EnemyReferences _refs;
    public float TimeSinceLastSeen { get; private set; }

    public EnemyChase(EnemyReferences refs) => _refs = refs;

    public void OnEnter()
    {
        _refs.navMeshAgent.isStopped = false;
        _refs.navMeshAgent.speed = 6f; 
        TimeSinceLastSeen = 0;
    }

    public void Tick()
    {
        _refs.navMeshAgent.SetDestination(_refs.target.position);

        if (_refs.HasLineOfSight())
            TimeSinceLastSeen = 0;
        else
            TimeSinceLastSeen += Time.deltaTime;
    }

    public void OnExit() => _refs.navMeshAgent.isStopped = true;
}
