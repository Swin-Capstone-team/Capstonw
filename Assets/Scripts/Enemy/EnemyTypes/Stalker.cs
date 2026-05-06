using System;
using System.Collections;
using UnityEngine;
using UnityEngine.AI;

public class Stalker : EnemyBase, IMeleeAttacker
{
    [Header("Detection Settings")]
    [SerializeField] private float _detectionRange = 10f;
    [SerializeField] private float _giveUpDistance = 15f;
    [SerializeField] private float _maxLostTime = 2f;
    
    [Header("Stalker Combat")]
    [SerializeField] private float _meleeRange = 3f;
    [SerializeField] private float _attackCooldown = 1.5f;
    [SerializeField] private float _strikeDamage = 15f;
    [SerializeField] private float _lungeDistance = 2.5f;

    [Header("Floating Settings")]
    [SerializeField] private Transform _sphereVisual; 
    [SerializeField] private float _floatAmplitude = 0.3f;
    [SerializeField] private float _floatFrequency = 2f;
    private Vector3 _initialVisualLocalPos;

    public Transform target => base.target; 
    public float attackCooldown => _attackCooldown;
    public new NavMeshAgent navMeshAgent => base.navMeshAgent;

    protected override void Awake()
    {
        base.Awake(); 
        if (_sphereVisual != null) _initialVisualLocalPos = _sphereVisual.localPosition;
    }

    private void Start()
    {
        // Initialize States
        var idle = new EnemyIdle(this);
        var chase = new EnemyChase(this);
        var melee = new EnemyMelee(this);

        // helper
        void At(IState from, IState to, Func<bool> condition) => stateMachine.AddTransition(from, to, condition);


        // Idle -> Chase: Target is within detection range AND in Line of Sight
        At(idle, chase, () => target != null && 
                               Vector3.Distance(transform.position, target.position) < _detectionRange && 
                               HasLineOfSight());

        // Chase -> Idle: Target is too far away
        At(chase, idle, () => target == null || 
                               Vector3.Distance(transform.position, target.position) > _giveUpDistance);

        // Chase -> Idle: Target has been hidden/lost for too long
        At(chase, idle, () => chase.TimeSinceLastSeen > _maxLostTime);

        // Any State -> Melee: Target is within strike range
        stateMachine.AddAnyTransition(melee, () => target != null && 
                                                   Vector3.Distance(transform.position, target.position) < _meleeRange);

        // Melee -> Chase: Target moved away from strike range
        At(melee, chase, () => target != null && 
                               Vector3.Distance(transform.position, target.position) > _meleeRange + 0.5f);

        stateMachine.SetState(idle);
    }

    protected override void Update()
    {
        base.Update();
        HandleFloating();
    }

    private void HandleFloating()
    {
        if (_sphereVisual == null) return;
        float newY = _initialVisualLocalPos.y + Mathf.Sin(Time.time * _floatFrequency) * _floatAmplitude;
        _sphereVisual.localPosition = new Vector3(_initialVisualLocalPos.x, newY, _initialVisualLocalPos.z);
    }

    public void MeleeAttack()
    {
        StartCoroutine(StalkerStrikeRoutine());
    }

    private IEnumerator StalkerStrikeRoutine()
    {
        Vector3 startPos = transform.position;
        Vector3 attackDir = (target.position - transform.position).normalized;
        Vector3 lungeTarget = startPos + (attackDir * _lungeDistance);

        float elapsed = 0;
        float time = 0.1f; 
        while (elapsed < time)
        {
            transform.position = Vector3.Lerp(startPos, lungeTarget, elapsed / time);
            elapsed += Time.deltaTime;
            yield return null;
        }

        CheckHit(attackDir);

        elapsed = 0;
        time = 0.3f;
        while (elapsed < time)
        {
            transform.position = Vector3.Lerp(lungeTarget, startPos, elapsed / time);
            elapsed += Time.deltaTime;
            yield return null;
        }
        transform.position = startPos;
    }

    private void CheckHit(Vector3 dir)
    {
        Collider[] hits = Physics.OverlapSphere(transform.position + dir, 1.2f);
        foreach (var hit in hits)
        {
            if (hit.CompareTag("Player") && hit.TryGetComponent<IDamageable>(out var damageable))
            {
                damageable.TakeDamage(new DamageInfo {
                    amount = _strikeDamage,
                    direction = dir,
                    force = 8f,
                    attacker = gameObject
                });
            }
        }
    }

    private void OnDrawGizmos()
    {
        // Draw Detection Range (Yellow)
        Gizmos.color = Color.yellow;
        Gizmos.DrawWireSphere(transform.position, _detectionRange);

        // Draw Give Up Distance (Cyan)
        Gizmos.color = Color.cyan;
        Gizmos.DrawWireSphere(transform.position, _giveUpDistance);

        // Draw Melee Range (Red)
        Gizmos.color = Color.red;
        Gizmos.DrawWireSphere(transform.position, _meleeRange);
    }
}