using UnityEngine;

public class EnemyChase : IState
{
    private readonly EnemyBase _enemy;
    public float TimeSinceLastSeen { get; private set; }

    public EnemyChase(EnemyBase enemy) => _enemy = enemy;

    public void OnEnter()
    {
        _enemy.navMeshAgent.isStopped = false;
        _enemy.navMeshAgent.speed = 6f;
        TimeSinceLastSeen = 0;
    }

    public void Tick()
    {
        if (_enemy.target == null) return;

        _enemy.navMeshAgent.SetDestination(_enemy.target.position);

        // Use the utility method in EnemyBase to check sight
        if (_enemy.HasLineOfSight())
            TimeSinceLastSeen = 0;
        else
            TimeSinceLastSeen += Time.deltaTime;
    }

    public void OnExit() => _enemy.navMeshAgent.isStopped = true;
}