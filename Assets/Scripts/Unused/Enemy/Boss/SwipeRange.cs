using UnityEngine;

public class SwipeRange : MonoBehaviour
{
    public Behaviour boss;
    

    

    void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {
            // Attack the player
            Debug.Log("Swiping the player!");
            boss.swipeattackRange = true;
        }
    }
    
    void OnTriggerExit(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {
            // Stop attacking the player
            Debug.Log("Stopped swiping the player!");
            boss.swipeattackRange = false;
        }
    }
}
