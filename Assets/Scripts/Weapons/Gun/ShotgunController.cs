using System.Collections;
using UnityEngine;
using TMPro;

public class ShotgunController : MonoBehaviour {
    [Header("References")]
    [SerializeField] private GunData gunData;
    [SerializeField] private Transform muzzlePoint;
    [SerializeField] private GameObject tracePrefab;
    [SerializeField] private GameObject impactEffectPrefab;
    [SerializeField] private LayerMask ignoreLayers;
    [SerializeField] private Animator animator;
    [SerializeField] private TextMeshProUGUI ammoDisplay;
    private PlayerInputState inputState;

    [Header("Settings")]
    [SerializeField] private float knockbackForce = 5f;
    [SerializeField] private float impactDestroyTime = 2f; // Impact will vanish after 2s

    private int currentAmmo;
    private bool isReloading = false;    
    private float nextTimeToFire = 0f;
    private Camera cam;

    void Awake()
    {
        inputState ??= GetComponentInParent<PlayerInputState>();

        if (inputState != null) return;

        Debug.LogError("ShotgunController requires PlayerInputState on this object or a parent.", this);
        enabled = false;
    }


    void Start() {
        cam = Camera.main;
        currentAmmo = gunData.magSize;
        UpdateAmmoDisplay();
    }

    void Update() {
        if (isReloading) return;

        if (currentAmmo <= 0) {
            StartCoroutine(Reload());
            return;
        }

        if (inputState != null && inputState.ShootPressedThisFrame && Time.time >= nextTimeToFire) {
            Shoot();
        }
    }

    void UpdateAmmoDisplay() {
        if (ammoDisplay != null) {
            ammoDisplay.text = $"{currentAmmo} / {gunData.magSize}";
        }
    }

    void Shoot() {
        currentAmmo--;
        UpdateAmmoDisplay();
        nextTimeToFire = Time.time + gunData.fireRate;

        if (animator != null) animator.SetTrigger("Shoot");

        Ray cameraRay = cam.ViewportPointToRay(new Vector3(0.5f, 0.5f, 0));
        Vector3 targetPoint;

        if (Physics.Raycast(cameraRay, out RaycastHit cameraHit, gunData.range, ~ignoreLayers)) {
            targetPoint = cameraHit.point;
        } else {
            targetPoint = cameraRay.GetPoint(gunData.range);
        }

        Vector3 baseDirection = (targetPoint - muzzlePoint.position).normalized;

        for (int i = 0; i < gunData.pelletsPerShot; i++) {
            Vector3 spreadDir = CalculateSpread(baseDirection);

            if (Physics.Raycast(muzzlePoint.position, spreadDir, out RaycastHit hit, gunData.range, ~ignoreLayers)) {
                HandleHit(hit, spreadDir);
            } else {
                SpawnTrace(muzzlePoint.position + (spreadDir * gunData.range));
            }
        }
    }

    void HandleHit(RaycastHit hit, Vector3 direction) {
        DamageInfo info = new DamageInfo {
            amount = CalculateDamage(hit.distance),
            direction = direction.normalized,
            force = knockbackForce,
            attacker = this.gameObject
        };

        if (hit.collider.TryGetComponent(out IDamageable target)) {
            target.TakeDamage(info);
        }

        if (impactEffectPrefab != null) {
            GameObject impact = Instantiate(impactEffectPrefab, hit.point, Quaternion.LookRotation(hit.normal));
            Destroy(impact, impactDestroyTime); 
        }

        SpawnTrace(hit.point);
    }

    IEnumerator Reload() {
        isReloading = true;
        Debug.Log("Reloading...");

        if (animator != null) {
            animator.SetTrigger("Reload");
        }
        
        yield return new WaitForSeconds(gunData.reloadTime);

        currentAmmo = gunData.magSize;
        isReloading = false;
        UpdateAmmoDisplay();
    }

    float CalculateDamage(float distance) {
        float distancePercent = distance / gunData.range;
        float multiplier = gunData.damageFalloff.Evaluate(distancePercent);
        return gunData.damage * multiplier;
    }

    Vector3 CalculateSpread(Vector3 baseDir) {
        Vector2 randomPoint = Random.insideUnitCircle * gunData.spreadIntensity;

        Quaternion spreadRotation = Quaternion.Euler(randomPoint.y, randomPoint.x, 0);

        return Quaternion.LookRotation(baseDir) * spreadRotation * Vector3.forward;
    }

    void SpawnTrace(Vector3 endPoint) {
        if (tracePrefab != null) {
            GameObject trace = Instantiate(tracePrefab, muzzlePoint.position, Quaternion.identity);
            trace.GetComponent<BulletTrace>().Init(muzzlePoint.position, endPoint);
        }
    }

    private void OnDrawGizmos() {
        if (muzzlePoint == null || !Application.isPlaying) return;

        Gizmos.color = Color.yellow;
        Gizmos.DrawWireSphere(muzzlePoint.position, 0.1f);

        Gizmos.color = Color.blue;
        Gizmos.DrawRay(muzzlePoint.position, muzzlePoint.forward * 5f);
    }
}