using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LevelManager : MonoBehaviour
{
    [Header("System References")]
    public GameTimer gameTimer;

    [Header("Prefabs")]
    public Level startingRoomPrefab;
    public Level[] parkourRoomPrefabs;
    public Level[] hallwayPrefabs;

    [Header("Back Wall")]
    public GameObject backWallPrefab;
    public float backWallDelay = 0.5f;
    public float backWallBackwardOffset = 4f;

    [Header("Generation Settings")]
    public int roomsToKeepAhead = 3;
    public int roomsToKeepBehind = 1;

    private List<Level> activeRooms = new List<Level>();
    private Level lastSpawnedRoom;

    private FallReset playerFallReset;

    private void Start()
    {
        playerFallReset = FindFirstObjectByType<FallReset>();

        SpawnStartingRoom();

        for (int i = 0; i < roomsToKeepAhead; i++)
        {
            SpawnNextSequence();
        }
    }

    private void SpawnStartingRoom()
    {
        Level startRoom = Instantiate(startingRoomPrefab, Vector3.zero, Quaternion.identity);
        RegisterRoom(startRoom);

        if (gameTimer != null)
        {
            gameTimer.StartTimerForLevel(startRoom);
        }

        if (playerFallReset != null && startRoom.startPoint != null)
        {
            playerFallReset.SetRespawnPoint(startRoom.startPoint);
        }
    }

    private void SpawnNextSequence()
    {
        SpawnRoom(true);
        SpawnRoom(false);
    }

    private void SpawnRoom(bool isHallway)
    {
        Level[] prefabArray = isHallway ? hallwayPrefabs : parkourRoomPrefabs;

        if (prefabArray == null || prefabArray.Length == 0)
        {
            Debug.LogWarning("No level prefabs assigned.");
            return;
        }

        Level prefabToSpawn = prefabArray[Random.Range(0, prefabArray.Length)];

        Level newRoom = Instantiate(prefabToSpawn);
        AlignRoomToPrevious(newRoom, lastSpawnedRoom);
        RegisterRoom(newRoom);
    }

    private void AlignRoomToPrevious(Level newRoom, Level previousRoom)
    {
        if (previousRoom == null) return;
        if (newRoom.startPoint == null || previousRoom.endPoint == null) return;

        Quaternion rotationOffset = previousRoom.endPoint.rotation * Quaternion.Inverse(newRoom.startPoint.rotation);
        newRoom.transform.rotation = rotationOffset * newRoom.transform.rotation;

        Vector3 positionOffset = newRoom.startPoint.position - newRoom.transform.position;
        newRoom.transform.position = previousRoom.endPoint.position - positionOffset;
    }

    private void RegisterRoom(Level room)
    {
        activeRooms.Add(room);
        lastSpawnedRoom = room;

        room.OnRoomEntered += HandleRoomEntered;
        room.OnRoomExited += HandleRoomExited;
    }

    private void HandleRoomEntered(Level enteredRoom)
    {
        if (gameTimer != null)
        {
            gameTimer.StartTimerForLevel(enteredRoom);
        }

        if (playerFallReset != null && enteredRoom.startPoint != null)
        {
            playerFallReset.SetRespawnPoint(enteredRoom.startPoint);
        }
    }

    private void HandleRoomExited(Level completedRoom)
    {
        completedRoom.OnRoomEntered -= HandleRoomEntered;
        completedRoom.OnRoomExited -= HandleRoomExited;

        if (gameTimer != null)
        {
            gameTimer.RecordLevelCompletion(completedRoom);
        }

        StartCoroutine(SpawnBackWallAfterDelay(completedRoom));

        if (!completedRoom.isHallway)
        {
            SpawnNextSequence();
        }

        int exitedIndex = activeRooms.IndexOf(completedRoom);
        CleanupOldRooms(exitedIndex);
    }

    private IEnumerator SpawnBackWallAfterDelay(Level completedRoom)
    {
        yield return new WaitForSeconds(backWallDelay);

        SpawnBackWall(completedRoom);
    }

    private void SpawnBackWall(Level completedRoom)
    {
        if (backWallPrefab == null)
        {
            Debug.LogWarning("Back wall prefab is not assigned.");
            return;
        }

        if (completedRoom == null || completedRoom.endPoint == null)
        {
            return;
        }

        Vector3 spawnPosition =
            completedRoom.endPoint.position -
            completedRoom.endPoint.forward * backWallBackwardOffset;

        GameObject wall = Instantiate(
            backWallPrefab,
            spawnPosition,
            completedRoom.endPoint.rotation
        );

        wall.name = "Invisible Back Wall";
        wall.transform.SetParent(completedRoom.transform);
    }

    private void CleanupOldRooms(int currentlyExitedIndex)
    {
        if (currentlyExitedIndex >= roomsToKeepBehind && activeRooms.Count > 0)
        {
            Level oldestRoom = activeRooms[0];
            activeRooms.RemoveAt(0);
            Destroy(oldestRoom.gameObject);
        }
    }
}