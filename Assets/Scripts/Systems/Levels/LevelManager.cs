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

    [Header("Generation Settings")]
    public int roomsToKeepAhead = 3;
    public int roomsToKeepBehind = 1;

    private List<Level> activeRooms = new List<Level>();
    private Level lastSpawnedRoom;

    private void Start()
    {
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
        
        // Force the timer to start for the very first room since they spawn inside it
        gameTimer.StartTimerForLevel(startRoom);
    }

    private void SpawnNextSequence()
    {
        SpawnRoom(true);  
        SpawnRoom(false); 
    }

    private void SpawnRoom(bool isHallway)
    {
        Level[] prefabArray = isHallway ? hallwayPrefabs : parkourRoomPrefabs;
        Level prefabToSpawn = prefabArray[Random.Range(0, prefabArray.Length)];

        Level newRoom = Instantiate(prefabToSpawn);
        AlignRoomToPrevious(newRoom, lastSpawnedRoom);
        RegisterRoom(newRoom);
    }

    private void AlignRoomToPrevious(Level newRoom, Level previousRoom)
    {
        if (previousRoom == null) return;

        Quaternion rotationOffset = previousRoom.endPoint.rotation * Quaternion.Inverse(newRoom.startPoint.rotation);
        newRoom.transform.rotation = rotationOffset * newRoom.transform.rotation;

        Vector3 positionOffset = newRoom.startPoint.position - newRoom.transform.position;
        newRoom.transform.position = previousRoom.endPoint.position - positionOffset;
    }

    private void RegisterRoom(Level room)
    {
        activeRooms.Add(room);
        lastSpawnedRoom = room;
        
        // Subscribe to BOTH events
        room.OnRoomEntered += HandleRoomEntered;
        room.OnRoomExited += HandleRoomExited;
    }

    private void HandleRoomEntered(Level enteredRoom)
    {
        gameTimer.StartTimerForLevel(enteredRoom);
    }

    private void HandleRoomExited(Level completedRoom)
    {
        // 1. Unsubscribe to prevent memory leaks
        completedRoom.OnRoomEntered -= HandleRoomEntered;
        completedRoom.OnRoomExited -= HandleRoomExited;

        // 2. Notify systems about the completion
        gameTimer.RecordLevelCompletion(completedRoom);
        
        // 3. ONLY spawn the next sequence if we just beat a main parkour room
        if (!completedRoom.isHallway)
        {
            SpawnNextSequence();
        }

        // 4. Cleanup old rooms safely (this still runs for hallways so we don't leave them behind)
        int exitedIndex = activeRooms.IndexOf(completedRoom);
        CleanupOldRooms(exitedIndex);
    }

    private void CleanupOldRooms(int currentlyExitedIndex)
    {
        if (currentlyExitedIndex >= roomsToKeepBehind)
        {
            Level oldestRoom = activeRooms[0];
            activeRooms.RemoveAt(0);
            Destroy(oldestRoom.gameObject);
        }
    }
}