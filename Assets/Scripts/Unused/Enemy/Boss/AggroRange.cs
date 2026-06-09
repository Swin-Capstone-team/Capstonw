using UnityEngine;

public class AggroRange : MonoBehaviour
{
    public Behaviour boss;

    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {

    }

    void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {
            // Follow the player
            if(!boss.isAttacking)
            {
                Debug.Log("Following the player!");
                boss.isFollowing = true;
            }
        }
    }

    void OnTriggerExit(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {
            // Stop following the player
            Debug.Log("Stopped following the player!");
            boss.isFollowing = false;
        }
    }
}
