// using System;
// using UnityEngine;
// using UnityEngine.AI;

// public class Goon : EnemyBase, IPatrolable, IMeleeAttacker
// {
//     [Header("Detection Settings")]
//     [SerializeField] private float _detectionRange = 15f;
//     [SerializeField] private float _giveUpDistance = 30f;
//     [SerializeField] private float _maxLostTime = 3f;

//     [Header("Combat Settings")]
//     [SerializeField] private float _meleeRange = 2.5f;
//     [SerializeField] private float _attackCooldown = 2f;

//     [Header("Patrol Setup")]
//     [SerializeField] private Transform _waypointParent;


//     public NavMeshAgent navMeshAgent => base.navMeshAgent;
//     public Transform target => base.target;

//     // IPatrolable
//     public Transform waypointParent => _waypointParent;

//     // IMeleeAttacker & IShootable shared
//     public float attackCooldown => _attackCooldown;

    
//     // --- State Machine Logic ---
//     private void Start()
//     {
//         // Initialize States
//         var patrol = new EnemyPatrol(this);
//         var chase = new EnemyChase(this);
//         var melee = new EnemyMelee(this);

//         // --- Define Transitions ---

//         // Patrol -> Chase (Target spotted)
//         At(patrol, chase, InRangeAndHasLOS());

//         // Chase -> Patrol (Target lost or too far)
//         At(chase, patrol, TargetTooFar());
//         At(chase, patrol, TargetLost());

//         // Any State -> Melee (Target is in face)
//         stateMachine.AddAnyTransition(melee, () => Vector3.Distance(transform.position, target.position) < _meleeRange);

//         // Melee -> Chase (Target backed off)
//         At(melee, chase, TargetBackedOff());

//         // Set Initial State
//         stateMachine.SetState(patrol);

//         // Local helper for cleaner syntax
//         void At(IState from, IState to, Func<bool> condition) => stateMachine.AddTransition(from, to, condition);

//         Func <bool> InRangeAndHasLOS() => () => Vector3.Distance(transform.position, target.position) < _detectionRange && HasLineOfSight();
//         Func <bool> TargetTooFar() => () => Vector3.Distance(transform.position, target.position) > _giveUpDistance;
//         Func <bool> TargetLost() => () => chase.TimeSinceLastSeen > _maxLostTime;
//         Func <bool> TargetBackedOff() => () => Vector3.Distance(transform.position, target.position) > _meleeRange + 1f;

//     }

//     // --- Visual Debugging ---
//     private void OnDrawGizmos()
//     {
//         if (_waypointParent == null || _waypointParent.childCount < 2) return;

//         Gizmos.color = Color.cyan;
//         for (int i = 0; i < _waypointParent.childCount; i++)
//         {
//             Vector3 current = _waypointParent.GetChild(i).position;
//             Gizmos.DrawSphere(current, 0.3f);

//             Vector3 next = _waypointParent.GetChild((i + 1) % _waypointParent.childCount).position;
//             Gizmos.DrawLine(current, next);
//         }

//         // Draw Detection Range
//         Gizmos.color = Color.red;
//         Gizmos.DrawWireSphere(transform.position, _detectionRange);

//         Gizmos.color = Color.yellow;
//         Gizmos.DrawWireSphere(transform.position, _meleeRange);
//     }

    
// }