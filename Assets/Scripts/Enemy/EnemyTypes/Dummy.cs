using System;
using UnityEngine;
using UnityEngine.AI;

public class Dummy : EnemyBase, IMeleeAttacker
{
    [Header("Combat Settings")]
    [SerializeField] private float _meleeRange = 2.5f;
    [SerializeField] private float _attackCooldown = 2f;


    public NavMeshAgent navMeshAgent => base.navMeshAgent;
    public Transform target => base.target;


    // IMeleeAttacker
    public float attackCooldown => _attackCooldown;

    
    // --- State Machine Logic ---
    private void Start()
    {
        // Initialize States
        var idle = new EnemyIdle(this);
        var melee = new EnemyMelee(this);

        // --- Define Transitions ---
        At(idle, melee, () => target != null && Vector3.Distance(transform.position, target.position) < _meleeRange);
        At(melee, idle, () => target == null || Vector3.Distance(transform.position, target.position) >= _meleeRange);    

        // Set Initial State
        stateMachine.SetState(idle);

        // Local helper for cleaner syntax
        void At(IState from, IState to, Func<bool> condition) => stateMachine.AddTransition(from, to, condition);
    }

    // --- Visual Debugging ---
    private void OnDrawGizmos()
    {
        // Draw Melee Range
        Gizmos.color = Color.red;
        Gizmos.DrawWireSphere(transform.position, _meleeRange);

    }
}