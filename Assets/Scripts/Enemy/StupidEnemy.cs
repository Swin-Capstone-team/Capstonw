using System.Collections.Generic;
using System.Collections;
using UnityEngine;

public class StupidEnemy : MonoBehaviour
{
    public Transform target;

    private EnemyReferences enemyReferences;

    private float distanceToTarget;
    private float pathUpdateTimer;

    private void Awake()
    {
        enemyReferences = GetComponent<EnemyReferences>();
    }

    void Start()
    {
        distanceToTarget = enemyReferences.navMeshAgent.stoppingDistance;
    }

    public void Update()
    {
        if (target != null)
        {
            bool inRange = Vector3.Distance(transform.position, target.position) <= distanceToTarget;

            if (inRange)
            {
                Look();
            }
            else
            {
                UpdatePath();
            }

        }

    }

    private void Look()
    {
        Vector3 direction = (target.position - transform.position).normalized;
        direction.y = 0f;
        Quaternion lookRotation = Quaternion.LookRotation(direction);
        transform.rotation = Quaternion.Slerp(transform.rotation, lookRotation, Time.deltaTime * 5f);
    }

    private void UpdatePath()
    {
        if (Time.time >= pathUpdateTimer)
        {
            enemyReferences.navMeshAgent.SetDestination(target.position);
            pathUpdateTimer = Time.time + enemyReferences.pathUpdateInterval;
        }
    }

}
