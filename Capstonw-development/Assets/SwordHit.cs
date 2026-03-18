using UnityEngine;

public class SwordHit : MonoBehaviour
{
    public SlashAttack attack;

    public float normalForce = 20f;
    public float thirdSlashForce = 30f;

    private float hitCooldown = 0.2f;
    private float lastHitTime = 0f;

    private void OnTriggerStay(Collider other)
    {
        // ✅ Only deal damage when attacking
        if (attack == null || attack.comboStepPublic == 0) return;

        if (Time.time - lastHitTime < hitCooldown) return;

        Enemy enemy = other.GetComponent<Enemy>();
        if (enemy == null) return;

        Vector3 dir = (other.transform.position - transform.position).normalized;

        float force = normalForce;

        // 3rd slash = big push
        if (attack.comboStepPublic == 3)
        {
            force = thirdSlashForce;
        }

        enemy.TakeHit(dir, force);
        lastHitTime = Time.time;
    }
}