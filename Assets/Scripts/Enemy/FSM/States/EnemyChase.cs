using UnityEngine;

public class EnemyChase : EnemyState
{
    public EnemyChase(Enemy enemy, EnemyStateMachine stateMachine) : base(enemy, stateMachine)
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
