using UnityEngine;

public class CrouchAnimatorBool : MonoBehaviour
{
    [SerializeField] private Animator animator;

    private static readonly int IsCrouchingHash = Animator.StringToHash("IsCrouching");
    private static readonly int IsMovingHash = Animator.StringToHash("IsMoving");
    private static readonly int IsSlidingHash = Animator.StringToHash("IsSliding");

    private void Awake()
    {
        if (animator == null)
        {
            animator = GetComponent<Animator>();
        }
    }

    private void Update()
    {
        bool isCrouching = Input.GetKey(KeyCode.LeftControl);

        bool isMoving =
            Input.GetKey(KeyCode.W) ||
            Input.GetKey(KeyCode.A) ||
            Input.GetKey(KeyCode.S) ||
            Input.GetKey(KeyCode.D);

        bool isSliding =
            Input.GetKey(KeyCode.LeftControl) &&
            Input.GetKey(KeyCode.LeftShift) &&
            isMoving;

        animator.SetBool(IsCrouchingHash, isCrouching && !isSliding);
        animator.SetBool(IsMovingHash, isMoving);
        animator.SetBool(IsSlidingHash, isSliding);
    }
}