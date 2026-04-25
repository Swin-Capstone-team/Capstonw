using System.Runtime.CompilerServices;
using UnityEngine;

public class WallDetector : MonoBehaviour
{
    [HideInInspector] public bool nearWall = false;
    [HideInInspector] public Vector3 wallNormal;
    [HideInInspector] public Collider currentWall;

    private void OnTriggerStay(Collider other)
    {
        if (other.CompareTag("Jumpable"))
        {
            nearWall = true;
            currentWall = other;

            // Direction from player to collider center
            Vector3 dir = (transform.position - other.ClosestPointOnBounds(transform.position)).normalized;
            wallNormal = dir;
        }
    }


    private void OnTriggerExit(Collider other)
    {
        if (other != currentWall) return; // only reset if exiting the wall we're currently near
        {
            nearWall = false;
            currentWall = null;
            wallNormal = Vector3.zero;
        }
    }
}
