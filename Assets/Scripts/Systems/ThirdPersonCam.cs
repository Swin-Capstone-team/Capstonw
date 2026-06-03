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

    [Header("Aim")]
    public Transform aimTarget;
    public float aimSensitivity = 0.5f;
    public float aimClampAngle = 80f;

    public CameraStyle currentStyle;
    public enum CameraStyle
    {
        Basic,
        Combat,
        Aim
    }

    public GameObject basicCam;
    public GameObject combatCam;
    public GameObject aimCam;

    [SerializeField] private PlayerInputState _input;

    private float _aimYaw;
    private float _aimPitch;

    void Awake()
    {
        if (_input != null) return;

        Debug.LogError("ThirdPersonCam requires PlayerInputState to be assigned.", this);
        enabled = false;
    }

    void Start()
    {
        Cursor.lockState = CursorLockMode.Locked;
        _aimYaw   = player.eulerAngles.y;
        _aimPitch = 0f;
        SwitchCameraStyle(currentStyle);
    }

    void Update()
    {
        Vector3 viewDir = player.position - new Vector3(transform.position.x, player.position.y, transform.position.z);
        orientation.forward = viewDir.normalized;

        if (currentStyle == CameraStyle.Basic)
        {
            float horizontalInput = _input.Look.x;
            float verticalInput   = _input.Look.y;
            Vector3 inputDir = orientation.forward * verticalInput + orientation.right * horizontalInput;

            if (inputDir != Vector3.zero)
                orientation.forward = Vector3.Slerp(orientation.forward, inputDir.normalized, Time.deltaTime * rotationSpeed);
        }
        else if (currentStyle == CameraStyle.Combat)
        {
            Vector3 dirToCombatLookAt = combatLookAt.position - new Vector3(transform.position.x, combatLookAt.position.y, transform.position.z);
            orientation.forward = dirToCombatLookAt.normalized;
            playerObj.forward   = dirToCombatLookAt.normalized;
        }
        else if (currentStyle == CameraStyle.Aim)
        {
            // Accumulate input here, but don't write to aimTarget yet
            _aimYaw   += _input.Look.x * aimSensitivity;
            _aimPitch -= _input.Look.y * aimSensitivity;
            _aimPitch  = Mathf.Clamp(_aimPitch, -aimClampAngle, aimClampAngle);

            // Player body and orientation can update here — no Cinemachine conflict
            Vector3 aimForwardFlat = Quaternion.Euler(0f, _aimYaw, 0f) * Vector3.forward;
            orientation.forward = aimForwardFlat;
            playerObj.forward   = aimForwardFlat;
        }

        if (_input.AimHeld && currentStyle != CameraStyle.Aim)
        {
            _aimYaw   = playerObj.eulerAngles.y;
            _aimPitch = 0f;
            SwitchCameraStyle(CameraStyle.Aim);
        }
        else if (!_input.AimHeld && currentStyle == CameraStyle.Aim)
        {
            SwitchCameraStyle(CameraStyle.Combat);
        }
    }

    // aimTarget written here so Cinemachine reads a stable value — no per-frame conflict
    void LateUpdate()
    {
        if (currentStyle == CameraStyle.Aim)
            aimTarget.rotation = Quaternion.Euler(_aimPitch, _aimYaw, 0f);
    }

    public void SwitchCameraStyle(CameraStyle newStyle)
    {
        currentStyle = newStyle;

        basicCam.SetActive(false);
        combatCam.SetActive(false);
        aimCam.SetActive(false);

        switch (currentStyle)
        {
            case CameraStyle.Basic:  basicCam.SetActive(true);  break;
            case CameraStyle.Combat: combatCam.SetActive(true); break;
            case CameraStyle.Aim:    aimCam.SetActive(true);    break;
        }
    }
}