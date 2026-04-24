using UnityEngine;
using System.Collections;

public class SlashAttack : MonoBehaviour
{
    public Animator animator;
    public float comboWindow = 4f;

    [Header("Slash VFX")]
    public GameObject slashPrefab;
    public Transform slashPoint;
    public float slashDestroyTime = 1.5f;

    [Header("Follow Settings")]
    public float followTime = 0.05f;

    [Header("Rotation Offset")]
    public Vector3 slashRotationOffset;

    [Header("Hit Detection")]
    public SwordHit swordHit;

    private float lastClickTime;
    private int comboStep = 0;
    private int attackIdCounter = 0;

    public int comboStepPublic { get; private set; }
    public int activeDamageStep { get; private set; } = 0;
    public bool canDealDamage { get; private set; } = false;
    public int currentAttackId { get; private set; } = -1;

    void Update()
    {
        if (animator == null) return;

        AnimatorStateInfo state = animator.GetCurrentAnimatorStateInfo(0);

        if (state.IsName("idle") && !animator.IsInTransition(0))
        {
            comboStep = 0;
            comboStepPublic = 0;
            activeDamageStep = 0;
            canDealDamage = false;
            currentAttackId = -1;

            animator.SetBool("ComboAttack", false);
            animator.SetBool("ComboAttack2", false);
        }

        if (Input.GetMouseButtonDown(0))
        {
            if (comboStep == 0)
            {
                animator.ResetTrigger("Attack");
                animator.SetTrigger("Attack");

                comboStep = 1;
                comboStepPublic = 1;
                lastClickTime = Time.time;
            }
            else if (comboStep == 1 && Time.time - lastClickTime <= comboWindow)
            {
                animator.SetBool("ComboAttack", true);

                comboStep = 2;
                comboStepPublic = 2;
                lastClickTime = Time.time;
            }
            else if (comboStep == 2 && Time.time - lastClickTime <= comboWindow)
            {
                animator.SetBool("ComboAttack2", true);

                comboStep = 3;
                comboStepPublic = 3;
                lastClickTime = Time.time;
            }
        }

        if (comboStep > 0 && Time.time - lastClickTime > comboWindow)
        {
            ResetCombo();
        }

        if (Input.GetKeyDown(KeyCode.F))
        {
            SpawnSlash();
        }
    }

    private void ResetCombo()
    {
        comboStep = 0;
        comboStepPublic = 0;
        activeDamageStep = 0;
        canDealDamage = false;
        currentAttackId = -1;

        animator.SetBool("ComboAttack", false);
        animator.SetBool("ComboAttack2", false);
    }

    public void SpawnSlash()
    {
        if (slashPrefab == null)
        {
            Debug.LogWarning("Slash Prefab is missing!");
            return;
        }

        if (slashPoint == null)
        {
            Debug.LogWarning("Slash Point is missing!");
            return;
        }

        Quaternion finalRotation = slashPoint.rotation * Quaternion.Euler(slashRotationOffset);
        GameObject slash = Instantiate(slashPrefab, slashPoint.position, finalRotation);

        StartCoroutine(FollowSlash(slash));
        Destroy(slash, slashDestroyTime);
    }

    private IEnumerator FollowSlash(GameObject slash)
    {
        float timer = 0f;

        while (timer < followTime && slash != null && slashPoint != null)
        {
            slash.transform.position = slashPoint.position;
            slash.transform.rotation = slashPoint.rotation * Quaternion.Euler(slashRotationOffset);

            timer += Time.deltaTime;
            yield return null;
        }
    }

    public void EnableDamage1()
    {
        activeDamageStep = 1;
        canDealDamage = true;
        currentAttackId = ++attackIdCounter;

        if (swordHit != null)
            swordHit.ClearHitTargets();

        Debug.Log("EnableDamage1 attackId=" + currentAttackId);
    }

    public void EnableDamage2()
    {
        activeDamageStep = 2;
        canDealDamage = true;
        currentAttackId = ++attackIdCounter;

        if (swordHit != null)
            swordHit.ClearHitTargets();

        Debug.Log("EnableDamage2 attackId=" + currentAttackId);
    }

    public void EnableDamage3()
    {
        activeDamageStep = 3;
        canDealDamage = true;
        currentAttackId = ++attackIdCounter;

        if (swordHit != null)
            swordHit.ClearHitTargets();

        Debug.Log("EnableDamage3 attackId=" + currentAttackId);
    }

    public void DisableDamage()
    {
        Debug.Log("DisableDamage attackId=" + currentAttackId);
        canDealDamage = false;
        activeDamageStep = 0;
        currentAttackId = -1;
    }
}