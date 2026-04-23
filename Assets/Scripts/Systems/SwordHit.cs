using System.Collections.Generic;
using UnityEngine;

public class SwordHit : MonoBehaviour
{
    [Header("References")]
    public SlashAttack attack;

    [Header("Damage Settings")]
    public float damage1 = 10f;
    public float damage2 = 15f;
    public float damage3 = 25f;

    [Header("Knockback Settings")]
    public float normalForce = 1f;
    public float thirdSlashForce = 5f;

    private HashSet<Collider> hitTargets = new HashSet<Collider>();
    private int lastComboStep = 0;

    void Update()
    {
        if (attack == null) return;


        if (attack.comboStepPublic != lastComboStep)
        {
            hitTargets.Clear();
            lastComboStep = attack.comboStepPublic;
        }

        // Safety clear when idle
        if (attack.comboStepPublic == 0)
        {
            hitTargets.Clear();
        }
    }

    private void OnTriggerStay(Collider other)
    {
        if (attack == null || attack.comboStepPublic == 0) return;
        
        if (hitTargets.Contains(other)) return;

        Health targetHealth = other.GetComponent<Health>();
        if (targetHealth == null) return;

        float finalDamage = GetDamageForStep(attack.comboStepPublic);
        float finalForce = (attack.comboStepPublic == 3) ? thirdSlashForce : normalForce;

        Vector3 knockbackDir = (other.transform.position - transform.position).normalized;
        knockbackDir.y = 0.5f; // Add a little "pop" upward

        // If it's an EnemyHealth, use the special TakeHit for flash/physics
        if (targetHealth is EnemyHealth enemy)
        {
            enemy.TakeHit(finalDamage, knockbackDir, finalForce);
        }
        else
        {
            // If it's a Player or a generic destructible, just do normal damage
            targetHealth.TakeDamage(finalDamage);
        }

        hitTargets.Add(other);
    }

    private float GetDamageForStep(int step)
    {
        return step switch
        {
            2 => damage2,
            3 => damage3,
            _ => damage1,
        };
    }
}