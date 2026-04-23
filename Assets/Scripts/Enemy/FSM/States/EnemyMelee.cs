using UnityEngine;

public class EnemyMelee : IState
{
    private readonly IMeleeAttacker _attacker;
    private float _lastAttackTime;

    public EnemyMelee(IMeleeAttacker attacker) => _attacker = attacker;

    public void OnEnter()
    {
        _attacker.navMeshAgent.isStopped = true;
        _attacker.navMeshAgent.velocity = Vector3.zero;
    }

    public void Tick()
    {
        if (_attacker.target == null) return;

        // Face target
        Vector3 direction = (_attacker.target.position - _attacker.transform.position).normalized;
        direction.y = 0;
        _attacker.transform.forward = Vector3.Slerp(_attacker.transform.forward, direction, Time.deltaTime * 10f);

        if (Time.time >= _lastAttackTime + _attacker.attackCooldown)
        {
            PerformAttack();
            _lastAttackTime = Time.time;
        }
    }

    private void PerformAttack()
    {
        Debug.Log($"{_attacker.transform.name} performed a melee attack!");
        // Trigger animation or damage logic here
    }

    public void OnExit() => _attacker.navMeshAgent.isStopped = false;
}