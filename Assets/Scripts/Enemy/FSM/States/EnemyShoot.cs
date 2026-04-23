using UnityEngine;

public class EnemyShoot : IState
{
    private readonly IShootable _shooter;
    private float _lastAttackTime;

    public EnemyShoot(IShootable shooter) => _shooter = shooter;

    public void OnEnter() => _shooter.navMeshAgent.isStopped = true;

    public void Tick()
    {
        if (_shooter.target == null) return;

        // Rotate toward target
        Vector3 direction = (_shooter.target.position - _shooter.transform.position).normalized;
        direction.y = 0; 
        _shooter.transform.forward = Vector3.Slerp(_shooter.transform.forward, direction, Time.deltaTime * 5f);

        if (Time.time >= _lastAttackTime + _shooter.attackCooldown)
        {
            Shoot();
            _lastAttackTime = Time.time;
        }
    }

    private void Shoot()
    {
        Vector3 targetOffset = _shooter.target.position + (Vector3.up * 1.5f);
        Vector3 fireDirection = (targetOffset - _shooter.barrelEnd.position).normalized;

        Rigidbody bullet = Object.Instantiate(_shooter.projectilePrefab, _shooter.barrelEnd.position, Quaternion.LookRotation(fireDirection));
        bullet.AddForce(fireDirection * _shooter.bulletSpeed);
    }

    public void OnExit() => _shooter.navMeshAgent.isStopped = false;
}