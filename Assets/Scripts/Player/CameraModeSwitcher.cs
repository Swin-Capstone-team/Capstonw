using UnityEngine;
using Cinemachine;

public class CameraModeSwitcher : MonoBehaviour
{
    public CinemachineVirtualCamera basicCam;
    public CinemachineVirtualCamera combatCam;
    public Transform player;

    public float enemyCheckRadius = 10f;
    public LayerMask enemyLayer;
    public float checkInterval = 0.2f;

    private float timer;
    private bool inCombat;

    void Start()
    {
        SetCombatMode(false);
    }

    void Update()
    {
        timer -= Time.deltaTime;
        if (timer > 0f) return;

        timer = checkInterval;

        bool enemyNearby = Physics.CheckSphere(player.position, enemyCheckRadius, enemyLayer);

        if (enemyNearby != inCombat)
        {
            SetCombatMode(enemyNearby);
        }
    }

    void SetCombatMode(bool combat)
    {
        inCombat = combat;

        if (combat)
        {
            combatCam.Priority = 20;
            basicCam.Priority = 10;
        }
        else
        {
            basicCam.Priority = 20;
            combatCam.Priority = 10;
        }
    }

    void OnDrawGizmosSelected()
    {
        if (player == null) return;

        Gizmos.color = Color.red;
        Gizmos.DrawWireSphere(player.position, enemyCheckRadius);
    }
}