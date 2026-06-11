using UnityEngine;

public class BackWallSpawner : MonoBehaviour
{
    public GameObject wallPrefab;

    public void SpawnWall(Transform spawnPoint)
    {
        if (wallPrefab == null || spawnPoint == null)
            return;

        Instantiate(
            wallPrefab,
            spawnPoint.position,
            spawnPoint.rotation
        );
    }
}