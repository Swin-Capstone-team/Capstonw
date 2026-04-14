using UnityEngine;

public class EnemyShoot : IState
{
    private readonly EnemyReferences _refs;
    private float _lastAttackTime;

    public EnemyShoot(EnemyReferences refs) => _refs = refs;

    public void OnEnter() => _refs.navMeshAgent.isStopped = true;

    public void Tick()
    {
        Vector3 direction = (_refs.target.position - _refs.transform.position).normalized;
        direction.y = 0; 
        _refs.transform.forward = Vector3.Slerp(_refs.transform.forward, direction, Time.deltaTime * 5f);

        if (Time.time >= _lastAttackTime + _refs.attackCooldown)
        {
            Shoot();
            _lastAttackTime = Time.time;
        }
    }

    private void Shoot()
    {
        if (_refs.target == null) return;

        Vector3 targetOffset = _refs.target.position + (Vector3.up * 1.5f);
        Vector3 fireDirection = (targetOffset - _refs.barrelEnd.position).normalized;

        Rigidbody bulletInstance = Object.Instantiate(_refs.projectilePrefab, _refs.barrelEnd.position, Quaternion.LookRotation(fireDirection));
        
        bulletInstance.AddForce(fireDirection * _refs.bulletSpeed);
    }

    public void OnExit() => _refs.navMeshAgent.isStopped = false;
}