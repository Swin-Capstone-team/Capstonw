using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Enemy : MonoBehaviour, IDamageable, IMoveable
{
    [field: SerializeField] public float MaxHealth { get; set; } = 100f;
    public float CurrentHealth { get; set; }
    public Rigidbody RB { get; set; }

    public EnemyStateMachine StateMachine { get; set; }
    public EnemyIdle IdleState { get; set; }
    public EnemyChase ChaseState { get; set; }
    public EnemyAttack AttackState { get; set; }

    public float RandomMovementRadius = 5f;
    public float MovementSpeed = 1f;

    public void Awake()
    {
        StateMachine = new EnemyStateMachine();
        IdleState = new EnemyIdle(this, StateMachine);
        ChaseState = new EnemyChase(this, StateMachine);
        AttackState = new EnemyAttack(this, StateMachine);
    }

    private void Start()
    {
        CurrentHealth = MaxHealth;
        RB = GetComponent<Rigidbody>();
        StateMachine.Initialize(IdleState);
    }

    public virtual void Damage(float damageAmount)
    {
        CurrentHealth -= damageAmount;
        if (CurrentHealth <= 0f)
        {
            Die();
        } 
    }
    public virtual void Die()
    {
        Destroy(gameObject);
    }

    public virtual void Move(Vector3 velocity)
    {
        RB.linearVelocity = velocity;
    }

    private void AnimationTriggerEvent(AnimationTriggerType triggerType)
    {
        StateMachine.CurrentState.AnimationTriggerEvent(triggerType);
    }

    public enum AnimationTriggerType
    {
        Damage,
        Footstep,
        Attack
    }

    private void Update()
    {
        StateMachine.CurrentState.Update();
    }

    private void FixedUpdate()
    {
        StateMachine.CurrentState.PhysicsUpdate();
    }
}
