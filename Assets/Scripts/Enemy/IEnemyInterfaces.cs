using UnityEngine;
using UnityEngine.AI;

public interface IPatrolable
{
    Transform waypointParent { get; }
    NavMeshAgent navMeshAgent { get; }
}


public interface IMeleeAttacker
{
    Transform target { get; }
    Transform transform { get; }
    float attackCooldown { get; }
    NavMeshAgent navMeshAgent { get; }
}

public interface IShootable
{
    Transform target { get; }
    Transform transform { get; }
    Transform barrelEnd { get; }
    Rigidbody projectilePrefab { get; }
    float bulletSpeed { get; }
    float attackCooldown { get; }
    NavMeshAgent navMeshAgent { get; }
}