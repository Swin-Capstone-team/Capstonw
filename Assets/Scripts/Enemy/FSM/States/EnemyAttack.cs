using UnityEngine;

public class EnemyAttack : EnemyState
{
    public EnemyAttack(Enemy enemy, EnemyStateMachine stateMachine) : base(enemy, stateMachine)
    {
        
    }
    public override void Enter()
    {
        base.Enter();
    }
    public override void Exit()
    {
        base.Exit();
    }
    public override void Update()
    {
        base.Update();
    }
    public override void PhysicsUpdate()
    {
        base.PhysicsUpdate();
    }
    public override void AnimationTriggerEvent(Enemy.AnimationTriggerType triggerType)
    {
        base.AnimationTriggerEvent(triggerType);
    }
}
