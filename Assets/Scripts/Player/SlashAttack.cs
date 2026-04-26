using UnityEngine;
using System.Collections;

[DisallowMultipleComponent]
public class SlashAttack : MonoBehaviour
{
    public Animator animator;
    public SwordHit swordHit;
    public float comboWindow = 1.0f; 
    public KeyCode attackKey = KeyCode.E;

    [Header("Damage Settings")]
    public float[] damageSteps = { 10f, 15f, 25f };
    public float[] forceSteps = { 1f, 1f, 5f };

    [Header("Timing")]
    public float damageDelay = 0.15f; 
    public float damageDuration = 0.2f;

    private float lastClickTime;
    private int comboStep = 0;
    private bool isAttacking = false;
    private bool didBufferNextAttack = false;

    void Awake()
    {
        inputState ??= GetComponentInParent<PlayerInputState>();

        if (inputState != null) return;

        Debug.LogError("SlashAttack requires PlayerInputState on this object or a parent.", this);
        enabled = false;
    }

    void Update()
    {
        AnimatorStateInfo state = animator.GetCurrentAnimatorStateInfo(0);

        if ((state.IsName("idle") || state.IsName("Getting Hit (1)")) && !animator.IsInTransition(0))
        {
            comboStep = 0;
            isAttacking = false;
            didBufferNextAttack = false;
            animator.SetBool("ComboAttack", false);
            animator.SetBool("ComboAttack2", false);
        }

        if (inputState.AttackPressedThisFrame)
        {
            if (!isAttacking) ProcessAttackInput();
            else didBufferNextAttack = true; 
        }
    }

    private void ProcessAttackInput()
    {
        if (comboStep == 0)
            PerformAttack(1, "Attack", "slash1", false);
        else if (comboStep == 1 && Time.time - lastClickTime <= comboWindow)
            PerformAttack(2, "ComboAttack", "slash2", true);
        else if (comboStep == 2 && Time.time - lastClickTime <= comboWindow)
            PerformAttack(3, "ComboAttack2", "slash3", true);
    }

    private void PerformAttack(int step, string triggerName, string animatorStateName, bool isBool)
    {
        isAttacking = true;
        didBufferNextAttack = false;
        
        if (isBool) animator.SetBool(triggerName, true);
        else animator.SetTrigger(triggerName);

        // Lock in the damage for THIS specific coroutine instance
        float dmg = damageSteps[step - 1];
        float frc = forceSteps[step - 1];

        comboStep = step;
        lastClickTime = Time.time;

        StartCoroutine(AttackWindowRoutine(animatorStateName, dmg, frc));
    }

    private IEnumerator AttackWindowRoutine(string targetStateName, float dmg, float frc)
    {
        // Wait for state
        while (!animator.GetCurrentAnimatorStateInfo(0).IsName(targetStateName))
            yield return null;

        yield return new WaitForSeconds(damageDelay);
        
        swordHit.ResetHitTargets();

        float timer = 0f;
        while (timer < damageDuration)
        {
            // Use the "Stamped" damage values
            swordHit.CheckForHit(dmg, frc);
            timer += Time.deltaTime;
            yield return null; 
        }

        swordHit.ResetHitTargets();
        isAttacking = false; 

        if (didBufferNextAttack && (Time.time - lastClickTime <= comboWindow))
            ProcessAttackInput();
    }
}
