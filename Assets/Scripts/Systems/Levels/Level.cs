using System;
using System.Collections.Generic;
using UnityEngine;

public class Level : MonoBehaviour
{
    [Header("Room Identity")]
    public string levelID = "Room_Basic_01";
    public bool isHallway = false;
    
    [Header("Difficulty & Timing")]
    public float defaultTime = 30f;
    public float decayRate = 1.2f; 
    
    [Header("Tutorial Hints")]
    public List<MechanicHint> hints = new List<MechanicHint>();

    [Header("Connection Points")]
    public Transform startPoint;
    public Transform endPoint;

    // We now have two distinct events
    public event Action<Level> OnRoomEntered;
    public event Action<Level> OnRoomExited;

    private bool hasBeenEntered = false;
    private bool hasBeenExited = false;

    /// <summary>
    /// Called by the Entrance trigger at the start of the room.
    /// </summary>
    public void EnterRoom()
    {
        if (!hasBeenEntered)
        {
            hasBeenEntered = true;
            OnRoomEntered?.Invoke(this);
        }
    }

    /// <summary>
    /// Called by the Exit trigger at the end of the room.
    /// </summary>
    public void CompleteRoom()
    {
        if (!hasBeenExited)
        {
            hasBeenExited = true;
            OnRoomExited?.Invoke(this);
        }
    }
}
