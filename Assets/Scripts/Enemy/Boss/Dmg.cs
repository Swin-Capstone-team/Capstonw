using UnityEngine;

public class Dmg : MonoBehaviour
{
    public PlayerHealth playerHealth; // Reference to the player's health script
    public float damageAmount; // Amount of damage to inflict
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
        if (other.gameObject.tag == "Player") // Check if the collided object is the player
        {
            DamageInfo info = new DamageInfo{ amount = damageAmount }; // Create a DamageInfo instance
            playerHealth.TakeDamage(info); // Inflict damage to the player
            Debug.Log("Player hit! Damage inflicted: " + damageAmount);
        }
    }
}
