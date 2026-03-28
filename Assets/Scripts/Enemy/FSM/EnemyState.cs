using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class EnemyState
{
    protected Enemy enemy;
    protected EnemyStateMachine stateMachine;

    public EnemyState(Enemy enemy, EnemyStateMachine stateMachine)
    {
        this.enemy = enemy;
        this.stateMachine = stateMachine;
    }

    public virtual void Enter() { }
    public virtual void Exit() { }
    public virtual void Update() { }
    public virtual void PhysicsUpdate() { }
    public virtual void AnimationTriggerEvent(Enemy.AnimationTriggerType triggerType) { }

}
