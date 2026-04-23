using UnityEngine;

public class EnemyIdle : IState
{
    private readonly EnemyBase _enemy;

    public EnemyIdle(EnemyBase enemy)
    {
        _enemy = enemy;
    }

    public void OnEnter()
    {
        _enemy.navMeshAgent.isStopped = true;
        _enemy.navMeshAgent.velocity = Vector3.zero;
        
        Debug.Log($"{_enemy.name} entered IDLE state.");
    }

    public void Tick() {}

    public void OnExit()
    {
        _enemy.navMeshAgent.isStopped = false;
    }
}