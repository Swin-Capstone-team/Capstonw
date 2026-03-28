using UnityEngine;

public class EnemyIdle : EnemyState
{
    private Vector3 _targetPosition;
    private Vector3 _directionToTarget;
    public EnemyIdle(Enemy enemy, EnemyStateMachine stateMachine) : base(enemy, stateMachine)
    {
        
    }
    public override void Enter()
    {
        base.Enter();
        _targetPosition = GetRandomPointInCircle();
    }
    public override void Exit()
    {
        base.Exit();
    }
    public override void Update()
    {
        base.Update();
        _directionToTarget = (_targetPosition - enemy.transform.position).normalized;
        enemy.Move(_directionToTarget * enemy.MovementSpeed);

        if (Vector3.Distance(enemy.transform.position, _targetPosition) < 0.05f)
        {
            _targetPosition = GetRandomPointInCircle();
        }
    }
    public override void PhysicsUpdate()
    {
        base.PhysicsUpdate();
    }
    public override void AnimationTriggerEvent(Enemy.AnimationTriggerType triggerType)
    {
        base.AnimationTriggerEvent(triggerType);
    }

    private Vector3 GetRandomPointInCircle()
    {
        Vector2 randomPoint = Random.insideUnitSphere * enemy.RandomMovementRadius;
        return new Vector3(randomPoint.x, 0f, randomPoint.y) + enemy.transform.position;
    }
}
