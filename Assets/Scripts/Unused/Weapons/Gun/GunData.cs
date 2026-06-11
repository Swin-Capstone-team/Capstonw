using UnityEngine;

[CreateAssetMenu(fileName = "NewGun", menuName = "Weapon/GunData")]
public class GunData : ScriptableObject {
    [Header("Info")]
    public string gunName;

    [Header("Shooting")]
    public float range = 50f;
    public int damage = 10;
    public int pelletsPerShot = 8;
    public float spreadIntensity = 0.1f;
    public float fireRate = 0.5f;

    [Header("Ammo")]
    public int magSize = 8;
    public float reloadTime = 2.5f;
    
    [Header("Falloff")]
    public AnimationCurve damageFalloff; 
}