using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class EnemyPatrol : IState
{
    private readonly EnemyReferences _refs;
    private int _currentWaypointIndex;

    public EnemyPatrol(EnemyReferences refs)
    {
        _refs = refs;
    }

    public void OnEnter()
    {
        _refs.navMeshAgent.isStopped = false;
        _refs.navMeshAgent.speed = 3f;
        MoveToNextWaypoint();
    }

    public void Tick()
    {
        if (!_refs.navMeshAgent.pathPending && _refs.navMeshAgent.remainingDistance < 0.5f)
        {
            MoveToNextWaypoint();
        }
    }

    public void OnExit() => _refs.navMeshAgent.isStopped = true;

    private void MoveToNextWaypoint()
    {
        var waypoints = _refs.GetWaypointPositions();
        if (waypoints.Length == 0) return;

        _refs.navMeshAgent.SetDestination(waypoints[_currentWaypointIndex]);
        _currentWaypointIndex = (_currentWaypointIndex + 1) % waypoints.Length;
    }
}
