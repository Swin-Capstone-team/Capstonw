using UnityEngine;

public class EnemyPatrol : IState
{
    private readonly IPatrolable _entity;
    private int _currentWaypointIndex;

    public EnemyPatrol(IPatrolable entity) => _entity = entity;

    public void OnEnter()
    {
        _entity.navMeshAgent.isStopped = false;
        _entity.navMeshAgent.speed = 3f;
        MoveToNextWaypoint();
    }

    public void Tick()
    {
        if (!_entity.navMeshAgent.pathPending && _entity.navMeshAgent.remainingDistance < 0.5f)
        {
            MoveToNextWaypoint();
        }
    }

    public void OnExit() => _entity.navMeshAgent.isStopped = true;

    private void MoveToNextWaypoint()
    {
        if (_entity.waypointParent == null || _entity.waypointParent.childCount == 0) return;

        Vector3 nextPos = _entity.waypointParent.GetChild(_currentWaypointIndex).position;
        _entity.navMeshAgent.SetDestination(nextPos);
        _currentWaypointIndex = (_currentWaypointIndex + 1) % _entity.waypointParent.childCount;
    }
}