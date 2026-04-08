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
    public Transform[] waypointTransforms;

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
        Vector3[] points = new Vector3[waypointTransforms.Length];
        for (int i = 0; i < waypointTransforms.Length; i++)
        {
            points[i] = waypointTransforms[i].position;
        }
        return points;
    }
}
