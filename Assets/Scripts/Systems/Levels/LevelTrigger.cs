using UnityEngine;

public class LevelTrigger : MonoBehaviour
{
    public enum TriggerType { Entrance, Exit }

    [Header("Trigger Settings")]
    [Tooltip("Is this at the start of the room or the end?")]
    public TriggerType type;
    
    [Tooltip("Drag the parent Level script here.")]
    public Level parentLevel;

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            if (type == TriggerType.Entrance)
            {
                parentLevel.EnterRoom();
            }
            else if (type == TriggerType.Exit)
            {
                parentLevel.CompleteRoom();
            }
            
            // Disable the collider so it only fires once per run
            gameObject.SetActive(false);
        }
    }
}
