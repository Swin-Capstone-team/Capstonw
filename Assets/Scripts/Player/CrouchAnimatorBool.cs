using UnityEngine;

public class CrouchAnimatorBool : MonoBehaviour
{
    [SerializeField] private Animator animator;

    private static readonly int IsCrouchingHash = Animator.StringToHash("IsCrouching");
    private static readonly int IsMovingHash = Animator.StringToHash("IsMoving");

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

        animator.SetBool(IsCrouchingHash, isCrouching);
        animator.SetBool(IsMovingHash, isMoving);
    }
}