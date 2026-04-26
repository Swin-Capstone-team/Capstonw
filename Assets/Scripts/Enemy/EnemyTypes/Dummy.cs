using System;
using UnityEngine;
using UnityEngine.AI;

public class Dummy : EnemyBase
{
    public NavMeshAgent navMeshAgent => base.navMeshAgent;
    public Transform target => base.target;

    private void Start()
    {
        // Initialize States
        var idle = new EnemyIdle(this);  

        // Set Initial State
        stateMachine.SetState(idle);

        // helper 
        void At(IState from, IState to, Func<bool> condition) => stateMachine.AddTransition(from, to, condition);
    }

}