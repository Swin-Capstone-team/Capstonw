using UnityEngine;
using UnityEngine.AI;
using System.Collections;
using System.Collections.Generic;

[DisallowMultipleComponent]
public class EnemyReferences : MonoBehaviour
{
    [HideInInspector] public NavMeshAgent navMeshAgent;

    [Header("Stats")]

    public float pathUpdateInterval = 0.2f;

    [Header("Sensors")]
    public Transform target;
    public Transform waypointParent;

    [Header("Combat Setup")]
    public Rigidbody projectilePrefab; 
    public Transform barrelEnd;       
    public float bulletSpeed = 2000f; 
    public float attackCooldown = 2f;
    private void Awake()
    {
        navMeshAgent = GetComponent<NavMeshAgent>();
    }

    public bool HasLineOfSight()
    {
        // Linecast from chest to chest
        Vector3 start = transform.position + Vector3.up * 1.5f;
        Vector3 end = target.position + Vector3.up * 1.5f;

        if (Physics.Linecast(start, end, out RaycastHit hit))
        {
            return hit.transform == target;
        }
        return false;
    }

    public Vector3[] GetWaypointPositions()
    {
        if (waypointParent == null) return new Vector3[0];

        int count = waypointParent.childCount;
        Vector3[] points = new Vector3[count];

        for (int i = 0; i < count; i++)
        {
            points[i] = waypointParent.GetChild(i).position;
        }

        return points;
    }

    private void OnDrawGizmos()
    {
        if (waypointParent == null || waypointParent.childCount < 2) return;

        Gizmos.color = Color.cyan;
        for (int i = 0; i < waypointParent.childCount; i++)
        {
            Vector3 current = waypointParent.GetChild(i).position;
            Gizmos.DrawSphere(current, 0.3f);

            // Draw line to next point
            if (i < waypointParent.childCount - 1)
            {
                Vector3 next = waypointParent.GetChild(i + 1).position;
                Gizmos.DrawLine(current, next);
            }
            else // Loop back to start
            {
                Gizmos.DrawLine(current, waypointParent.GetChild(0).position);
            }
        }
    }
}
