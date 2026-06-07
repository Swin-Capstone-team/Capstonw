using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LevelManager : MonoBehaviour
{
    [Header("System References")]
    public GameTimer gameTimer;
    public UIManager uiManager;

    [Header("Prefabs")]
    public Level startingRoomPrefab;
    public Level[] parkourRoomPrefabs;
    public Level[] hallwayPrefabs;

    [Header("Generation Settings")]
    public int roomsToKeepAhead = 3;
    public int roomsToKeepBehind = 1;

    private List<Level> activeRooms = new List<Level>();
    private Level lastSpawnedRoom;
    private Level startingRoomInstance;

    private HashSet<string> seenMechanicKeys = new HashSet<string>();

    private void Start()
    {
        SpawnStartingRoom();

        for (int i = 0; i < roomsToKeepAhead; i++)
        {
            SpawnNextSequence();
        }

        StartCoroutine(ShowStartingRoomHintNextFrame());
    }

    private IEnumerator ShowStartingRoomHintNextFrame()
    {
        yield return null;
        // Debug.Log($"[LevelManager] Showing starting room hint for: {startingRoomInstance.levelID}, hints count: {startingRoomInstance.hints.Count}");
        ShowNewHintsForRoom(startingRoomInstance);
    }

    private void SpawnStartingRoom()
    {
        Level startRoom = Instantiate(startingRoomPrefab, Vector3.zero, Quaternion.identity);
        startingRoomInstance = startRoom;
        RegisterRoom(startRoom);
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
        
        room.OnRoomEntered += HandleRoomEntered;
        room.OnRoomExited  += HandleRoomExited;

        // Debug.Log($"[LevelManager] Registered room: {room.levelID}, isHallway: {room.isHallway}, hints: {room.hints.Count}");
    }


    private void HandleRoomEntered(Level enteredRoom)
    {
        // Debug.Log($"[LevelManager] HandleRoomEntered: {enteredRoom.levelID}");
        gameTimer.StartTimerForLevel(enteredRoom);

        if (enteredRoom.isHallway)
        {
            // Dismiss any lingering hint when entering a hallway breather
            uiManager.DismissHint();
        }
        else
        {
            // ShowHint internally cancels any active coroutine so no race condition
            ShowNewHintsForRoom(enteredRoom);
        }
    }

    private void HandleRoomExited(Level completedRoom)
    {
        // Debug.Log($"[LevelManager] HandleRoomExited: {completedRoom.levelID}");
        completedRoom.OnRoomEntered -= HandleRoomEntered;
        completedRoom.OnRoomExited  -= HandleRoomExited;

        // Don't dismiss here
        gameTimer.RecordLevelCompletion(completedRoom);
        
        if (!completedRoom.isHallway)
            SpawnNextSequence();

        int exitedIndex = activeRooms.IndexOf(completedRoom);
        CleanupOldRooms(exitedIndex);
    }


    private void ShowNewHintsForRoom(Level room)
    {
        if (room.hints == null || room.hints.Count == 0)
        {
            // Debug.Log($"[LevelManager] ShowNewHintsForRoom: {room.levelID} has no hints, skipping.");
            uiManager.DismissHint(); // no hint for this room, clear whatever was showing
            return;
        }

        foreach (MechanicHint hint in room.hints)
        {
            if (string.IsNullOrWhiteSpace(hint.mechanicKey) || string.IsNullOrWhiteSpace(hint.message))
            {
                // Debug.Log($"[LevelManager] Skipping hint with empty key or message on {room.levelID}");
                continue;
            }

            if (seenMechanicKeys.Contains(hint.mechanicKey))
            {
                // Debug.Log($"[LevelManager] Mechanic '{hint.mechanicKey}' already seen, skipping.");
                continue;
            }

            // Debug.Log($"[LevelManager] Showing hint for mechanic '{hint.mechanicKey}': {hint.message}");
            seenMechanicKeys.Add(hint.mechanicKey);
            uiManager.ShowHint(hint.message);
            return;
        }

        // All hints on this room have already been seen this run
        // Debug.Log($"[LevelManager] All hints already seen for {room.levelID}, dismissing.");
        uiManager.DismissHint();
    }

    public void ResetTutorialState()
    {
        seenMechanicKeys.Clear();
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
