using System.Numerics;
using UnityEngine;
using UnityEngine.AI;

public interface IBaseEnemy
{
    NavMeshAgent navMeshAgent { get; }
    Transform transform { get; }
    void ChangeVisualState(Color stateColor);
}

public interface IPatrolable : IBaseEnemy
{
    Transform waypointParent { get; }
}

public interface IMeleeAttacker : IBaseEnemy
{
    Transform target { get; }
    float attackCooldown { get; }
    void MeleeAttack();
}

public interface IShootable : IBaseEnemy
{
    Transform target { get; }
    Transform barrelEnd { get; }
    Rigidbody projectilePrefab { get; }
    float bulletSpeed { get; }
    float attackCooldown { get; }
}