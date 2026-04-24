using System.Collections.Generic;
using UnityEngine;

public class SwordHit : MonoBehaviour
{
    public SlashAttack attack;

    [Header("Damage")]
    public float damage1 = 10f;
    public float damage2 = 15f;
    public float damage3 = 25f;

    [Header("Hit Force")]
    public float normalForce = 1f;
    public float thirdSlashForce = 5f;

    private HashSet<Health> hitTargets = new HashSet<Health>();
    private int lastDamageStep = 0;

    void Update()
    {
        if (attack == null) return;

        if (attack.activeDamageStep != lastDamageStep)
        {
            hitTargets.Clear();
            lastDamageStep = attack.activeDamageStep;
        }

        if (!attack.canDealDamage || attack.activeDamageStep == 0)
        {
            hitTargets.Clear();
            lastDamageStep = 0;
        }
    }

    private void OnTriggerStay(Collider other)
    {
        if (attack == null) return;
        if (!attack.canDealDamage) return;
        if (attack.activeDamageStep == 0) return;

        Health health = other.GetComponentInParent<Health>();
        if (health == null) return;

        if (hitTargets.Contains(health)) return;

        Enemy enemy = other.GetComponentInParent<Enemy>();

        float finalDamage = damage1;
        float force = normalForce;

        if (attack.activeDamageStep == 2)
        {
            finalDamage = damage2;
        }
        else if (attack.activeDamageStep == 3)
        {
            finalDamage = damage3;
            force = thirdSlashForce;
        }

        Debug.Log("Hit: " + health.name + " step = " + attack.activeDamageStep + " damage = " + finalDamage + " attackId=" + attack.currentAttackId);

        bool applied = health.TryTakeDamageFromAttack(finalDamage, attack.currentAttackId);

        if (applied && enemy != null)
        {
            Vector3 dir = (health.transform.position - transform.position).normalized;
            enemy.TakeHit(dir, force);
        }

        hitTargets.Add(health);
    }

    public void ClearHitTargets()
    {
        hitTargets.Clear();
    }
}