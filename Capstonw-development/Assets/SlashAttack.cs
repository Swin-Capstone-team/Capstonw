using UnityEngine;

public class SlashAttack : MonoBehaviour
{
    public Animator animator;
    public float comboWindow = 4f;

    private float lastClickTime;
    private int comboStep = 0;

    public int comboStepPublic { get; private set; }

    void Update()
    {
        AnimatorStateInfo state = animator.GetCurrentAnimatorStateInfo(0);

        // Reset when back to idle
        if (state.IsName("idle") && !animator.IsInTransition(0))
        {
            comboStep = 0;
            comboStepPublic = 0;

            animator.SetBool("ComboAttack", false);
            animator.SetBool("ComboAttack2", false);
            animator.SetBool("ComboAttack3", false);
        }

        if (Input.GetMouseButtonDown(0))
        {
            if (comboStep == 0)
            {
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

        // Reset if too slow
        if (comboStep > 0 && Time.time - lastClickTime > comboWindow)
        {
            comboStep = 0;
            comboStepPublic = 0;

            animator.SetBool("ComboAttack", false);
            animator.SetBool("ComboAttack2", false);
        }
    }
}