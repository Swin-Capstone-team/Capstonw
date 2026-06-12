using UnityEngine;
using KinematicCharacterController;

public class FallReset : MonoBehaviour
{
    [Header("Fall Detection")]
    public float fallY = -20f;

    private Vector3 currentRespawnPosition;
    private Quaternion currentRespawnRotation;

    private KinematicCharacterMotor motor;
    private Rigidbody rb;
    private float lastRespawnTime;

    private void Awake()
    {
        motor = GetComponent<KinematicCharacterMotor>();
        rb = GetComponent<Rigidbody>();
    }

    private void Start()
    {
        currentRespawnPosition = transform.position;
        currentRespawnRotation = transform.rotation;
    }

    private void Update()
    {   
        //Unnecessary to use lines, trigger collider is used instead 👍
        // if (transform.position.y < fallY && Time.time - lastRespawnTime > 1f)
        // {
        //     Respawn();
        // }
    }

    public void SetRespawnPoint(Transform point)
    {
        if (point == null) return;

        currentRespawnPosition = point.position + Vector3.up * 3f;
        currentRespawnRotation = point.rotation;

        Debug.Log("Respawn Point Updated: " + point.name);
    }

    private void Respawn()
    {
        lastRespawnTime = Time.time;

        if (motor != null)
        {
            motor.SetPositionAndRotation(currentRespawnPosition, currentRespawnRotation);
            motor.BaseVelocity = Vector3.zero;
        }

        if (rb != null)
        {
            rb.linearVelocity = Vector3.zero;
            rb.angularVelocity = Vector3.zero;
        }

        transform.position = currentRespawnPosition;
        transform.rotation = currentRespawnRotation;

        Debug.Log("Player Respawned to: " + currentRespawnPosition);
    }

    void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Respawn"))
        {
            Respawn();
        }
    }
}