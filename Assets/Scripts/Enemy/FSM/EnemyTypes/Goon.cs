using System;
using UnityEngine;
using UnityEngine.AI;

public class Goon : MonoBehaviour
{

    [Header("Detection Settings")]
    [SerializeField] private float _detectionRange = 15f;
    [SerializeField] private float _giveUpDistance = 30f;
    [SerializeField] private float _maxLostTime = 3f;

    private EnemyReferences _enemyReferences;
    private StateMachine _stateMachine;

    private void Start()
    {
        _enemyReferences = GetComponent<EnemyReferences>();
        _stateMachine = new StateMachine();

        var patrol = new EnemyPatrol(_enemyReferences);
        var chase = new EnemyChase(_enemyReferences);
        var shoot = new EnemyShoot(_enemyReferences);

        At(patrol, chase, CanSeeTarget());
        At(chase, patrol, TargetTooFar());
        At(chase, patrol, LostTarget());
        At(chase, shoot, InAttackRange());
        At(shoot, chase, OutOfAttackRange());
        void At(IState to, IState from, Func<bool> condition) => _stateMachine.AddTransition(to, from, condition);
        void Any(IState to, Func<bool> condition) => _stateMachine.AddAnyTransition(to, condition);

        Func<bool> CanSeeTarget() => () => Vector3.Distance(transform.position, _enemyReferences.target.position) < _detectionRange && _enemyReferences.HasLineOfSight();

        // TargetTooFar: Simple distance check
        Func<bool> TargetTooFar() => () => Vector3.Distance(transform.position, _enemyReferences.target.position) > _giveUpDistance;

        // LostTarget: Check the timer inside the ChaseState
        Func<bool> LostTarget() => () => chase.TimeSinceLastSeen > _maxLostTime;

        Func<bool> InAttackRange() => () => 
            Vector3.Distance(transform.position, _enemyReferences.target.position) < 10f;

        Func<bool> OutOfAttackRange() => () => 
            Vector3.Distance(transform.position, _enemyReferences.target.position) > 15f;

        _stateMachine.SetState(patrol);
    }

    private void Update() => _stateMachine.Tick();

}
