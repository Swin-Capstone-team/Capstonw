using UnityEngine;

public struct DamageInfo
{
    public float amount;      // Numeric damage
    public Vector3 direction; // Direction of the hit for knockback
    public float force;       // Strength of the knockback
    public GameObject attacker; // Reference to who dealt the damage
}

public interface IDamageable
{
    void TakeDamage(DamageInfo info);
}