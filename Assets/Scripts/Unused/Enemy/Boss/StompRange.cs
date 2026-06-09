using UnityEngine;

public class StompRange : MonoBehaviour
{
    public Behaviour boss;
   
   
    void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {
            // Attack the player
            Debug.Log("Stomping the player!");
            boss.stompattackRange = true;    
        }
    }

    void OnTriggerExit(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {
            // Stop attacking the player
            Debug.Log("Stopped stomping the player!");
            boss.stompattackRange = false;
        }
    }

   
}
