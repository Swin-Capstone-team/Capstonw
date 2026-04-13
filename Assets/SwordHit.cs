using System.Collections.Generic;
using UnityEngine;

public class SwordHit : MonoBehaviour
{
    public SlashAttack attack;

    public float damage1 = 10f;
    public float damage2 = 15f;
    public float damage3 = 25f;

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

        if (attack.comboStepPublic == 0)
        {
            hitTargets.Clear();
        }
    }

    private void OnTriggerStay(Collider other)
    {
        if (attack == null || attack.comboStepPublic == 0) return;

        // Already hit this target during this slash
        if (hitTargets.Contains(other)) return;

        Enemy enemy = other.GetComponent<Enemy>();
        Health health = other.GetComponent<Health>();

        if (enemy == null && health == null) return;

        Vector3 dir = (other.transform.position - transform.position).normalized;

        float force = normalForce;
        float finalDamage = damage1;

        if (attack.comboStepPublic == 2)
        {
            finalDamage = damage2;
        }
        else if (attack.comboStepPublic == 3)
        {
            finalDamage = damage3;
            force = thirdSlashForce;
        }

        if (health != null)
        {
            health.TakeDamage(finalDamage);
        }

        if (enemy != null)
        {
            enemy.TakeHit(dir, force);
        }

        hitTargets.Add(other);
    }
}