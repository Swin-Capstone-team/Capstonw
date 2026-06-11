using UnityEngine;

public class EnemyMelee : IState
{
    private readonly IMeleeAttacker _attacker;
    private float _lastAttackTime;

    public EnemyMelee(IMeleeAttacker attacker) => _attacker = attacker;

    public void OnEnter()
    {
        _attacker.ChangeVisualState(Color.orange);
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
            _attacker.MeleeAttack();
            _lastAttackTime = Time.time;
        }
    }


    public void OnExit() => _attacker.navMeshAgent.isStopped = false;
}