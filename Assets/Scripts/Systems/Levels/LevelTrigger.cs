using UnityEngine;

public class LevelTrigger : MonoBehaviour
{
    public enum TriggerType { Entrance, Exit }

    [Header("Trigger Settings")]
    [Tooltip("Is this at the start of the room or the end?")]
    public TriggerType type;
    
    [Tooltip("Drag the parent Level script here.")]
    public Level parentLevel;

    private bool hasTriggered = false;

    private void OnTriggerEnter(Collider other) => TryTrigger(other);
    private void OnTriggerStay(Collider other) => TryTrigger(other);

    private void TryTrigger(Collider other)
    {
        if (hasTriggered) return;
        if (!other.CompareTag("Player")) return;

        hasTriggered = true;
            // Debug.Log($"[LevelTrigger] {type} triggered on {parentLevel?.levelID ?? "NULL parentLevel"} by {other.name}");

        if (type == TriggerType.Entrance)
            parentLevel.EnterRoom();
        else if (type == TriggerType.Exit)
            parentLevel.CompleteRoom();

        gameObject.SetActive(false);
    }
}
