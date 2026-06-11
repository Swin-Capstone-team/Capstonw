using System.Collections.Generic;
using UnityEngine;

public class SwordHit : MonoBehaviour
{
    [Header("References")]
    public Transform hitCheckPoint; 
    public LayerMask enemyLayer;    

    [Header("Hitbox Settings")]
    public Vector3 hitBoxSize = new Vector3(0.5f, 0.5f, 1.5f); 

    private HashSet<IDamageable> hitTargets = new HashSet<IDamageable>();

    public void ResetHitTargets() => hitTargets.Clear();

    // Now accepts parameters so it doesn't "guess" based on the combo step
    public void CheckForHit(float damage, float force)
    {
        Debug.Log($"Checking for hits. Damage: {damage}, Force: {force}", this);
        Collider[] hitColliders = Physics.OverlapBox(
            hitCheckPoint.position, 
            hitBoxSize / 2, 
            hitCheckPoint.rotation, 
            enemyLayer
        );

        foreach (var hitCollider in hitColliders)
        {
            if (hitCollider.TryGetComponent(out IDamageable target))
            {
                if (hitTargets.Contains(target)) continue;

                DamageInfo info = new DamageInfo
                {
                    amount = damage, // Use the "stamped" damage
                    direction = transform.root.forward,
                    force = force,
                    attacker = transform.root.gameObject
                };

                target.TakeDamage(info);
                hitTargets.Add(target);
            }
        }
    }

    private void OnDrawGizmosSelected()
    {
        if (hitCheckPoint == null) return;
        Gizmos.color = Color.red;
        Gizmos.matrix = hitCheckPoint.localToWorldMatrix;
        Gizmos.DrawWireCube(Vector3.zero, hitBoxSize);
    }
}