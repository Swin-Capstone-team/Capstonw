using UnityEngine;

public class ThirdPersonCam : MonoBehaviour
{
    [Header("References")]
    public Transform orientation;
    public Transform player;
    public Transform playerObj;
    public Rigidbody rb;

    public float rotationSpeed;
    public Transform combatLookAt;

    public CameraStyle currentStyle;
    public enum CameraStyle
    {
        Basic,
        Combat
    }

    public GameObject basicCam;
    public GameObject combatCam;

    [SerializeField] private PlayerInputState _input;

    void Awake()
    {
        if (_input != null) return;

        Debug.LogError("PlayerMove requires PlayerInputState on this object or a parent.", this);
        enabled = false;
    }

    void Start()
    {
        SwitchCameraStyle(currentStyle);
    }

    void Update()
    {
        Vector3 viewDir = player.position - new Vector3(transform.position.x, player.position.y, transform.position.z);
        orientation.forward = viewDir.normalized;

        if (currentStyle == CameraStyle.Basic)
        {
            float horizontalInput = _input.Look.x;
            float verticalInput = _input.Look.y;
            Vector3 inputDir = orientation.forward * verticalInput + orientation.right * horizontalInput;

            if (inputDir != Vector3.zero)
                orientation.forward = Vector3.Slerp(orientation.forward, inputDir.normalized, Time.deltaTime * rotationSpeed);
        }
        else if (currentStyle == CameraStyle.Combat)
        {
            Vector3 dirToCombatLookAt = combatLookAt.position - new Vector3(transform.position.x, combatLookAt.position.y, transform.position.z);
            orientation.forward = dirToCombatLookAt.normalized;

            playerObj.forward = dirToCombatLookAt.normalized;
        }
    }

    public void SwitchCameraStyle(CameraStyle newStyle)
    {
        currentStyle = newStyle;
        basicCam.SetActive(false);
        combatCam.SetActive(false);

        if (currentStyle == CameraStyle.Basic)
            basicCam.SetActive(true);
        else if (currentStyle == CameraStyle.Combat)
            combatCam.SetActive(true);
    }
}
