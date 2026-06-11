using UnityEngine;

public class Behaviour : MonoBehaviour
{
    public Animator animator;
    public Transform player;
    public GameObject playerObj;
    public GameObject followRange;      // Aggro range for the boss to start following the player
    public GameObject stompRange;       // Range for the stomp attack
    public Collider stompHitbox;       // hitbox for the stomp attack
    public GameObject swipeRange;       // Range for the swipe attack
    public Collider swipeHitbox;       // hitbox for the swipe attack
    public bool isFollowing = false;
    public bool stompattackRange = false;
    public bool swipeattackRange = false;
    public bool isAttacking = false;
    public float health;
    public float speed;

    public float attackTimer = 0f;
    private float stompattackCooldown = 5f;
    private float swipeattackCooldown = 3f;

    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        animator = GetComponent<Animator>();
    }

    // Update is called once per frame
    void Update()
    {
        attackTimer -= Time.deltaTime; //Cooldown for  attack
        if (player == null)
        {
            playerObj = GameObject.FindGameObjectWithTag("Player");  //Find the player using script
            if (playerObj != null)
            {
                player = playerObj.transform;
            }
            return;
        }

        if (stompattackRange)       //Stomp Attack
        {
            if (attackTimer <= 0f)
            {
                // stomp the player
                Debug.Log("Stomping the player!");
                StompAttack();
                attackTimer = stompattackCooldown;
            }
            else { Debug.Log("Stomp attack is on cooldown!"); }
        }

        if(swipeattackRange)        //Swipe Attack
        {
            if (attackTimer <= 0f)
            {
                // swipe the player
                Debug.Log("Swiping the player!");
                SwipeAttack();
                attackTimer = swipeattackCooldown;
            }
            else { Debug.Log("Swipe attack is on cooldown!"); }
        }

        if (isFollowing && !stompattackRange && !swipeattackRange)       //Follow the player if in aggro range but not attack ranges
        {
            FollowPlayer();
            Debug.Log("Following the player!");
        }
        
        
        if(health <= 0f)
        {
            // Die
            Debug.Log("Boss has been defeated!");
            animator.SetBool("isAlive", false);
        }
    }

    void FollowPlayer()
    {
        Vector3 target = player.position;
        target.y = transform.position.y;
        transform.position = Vector3.MoveTowards(transform.position, target, Time.deltaTime * speed);
        Vector3 dir = target - transform.position;

        if (dir.sqrMagnitude > 0.01f)
        {
            transform.rotation = Quaternion.LookRotation(dir);
        }
        
        animator.SetBool("isFollowing", true);
        Debug.Log("Following the player!");
    }

    void StompAttack()
    {
        isAttacking = true;
        animator.SetBool("isFollowing", false);
        animator.SetTrigger("Stomp");
        Debug.Log("Performing stomp attack!");
    }

    void SwipeAttack()
    {
        isAttacking = true;
        animator.SetBool("isFollowing", false);
        animator.SetTrigger("Swipe");
        Debug.Log("Performing swipe attack!");
    }

    public void SwipeHitboxEnable()
    {
        swipeHitbox.enabled = true;
    }

    public void SwipeHitboxDisable()
    {
        swipeHitbox.enabled = false;
    }

    public void StompHitboxEnable()
    {
        stompHitbox.enabled = true;
    }

    public void StompHitboxDisable()
    {
        stompHitbox.enabled = false;
    }

    public void EndAttack()
    {
        isAttacking = false;
        Debug.Log("Attack ended!");
    }
}
