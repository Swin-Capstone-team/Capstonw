using UnityEngine;

public class Inventory : MonoBehaviour
{
                //THIS IS THE GUN SCRIPT
    public int currentSlot = 0;
    public Transform crossbowTip;
    public Transform shotgunTip;
    public GameObject boltPrefab;
    public GameObject razor;
    public GameObject shotgun;
    public GameObject crossbow;
    private int shotgunAmmo = 10;
    private int crossbowAmmo = 10;
    public float boltSpeed;
    private PlayerInputState _input;

    [SerializeField] private Camera playerCamera;

    [SerializeField] private LayerMask aimMask;

    [SerializeField] private float aimDistance = 100f;

    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        _input ??= GetComponentInParent<PlayerInputState>();

        currentSlot = 0;
        EquipWeapon();
    }

    // Update is called once per frame
    void Update()
    {
        if (_input.ShootPressedThisFrame)
        {
            if (currentSlot == 2)
            {
                if (crossbowAmmo > 0)
                {
                    crossbowAmmo--;
                    Debug.Log("Crossbow shot fired");
                    ShootCrossbow();
                }
                else
                {
                    Debug.Log("Out of Crossbow ammo");
                }
            }
            if (currentSlot == 1)
            {
                if (shotgunAmmo > 0)
                {
                    shotgunAmmo--;
                    Debug.Log("Shotgun shot fired");
                }
                else
                {
                    Debug.Log("Out of Shotgun ammo");
                }
            }
            if(currentSlot == 0)
            {
                Debug.Log("Razor swung");
            }
        }

        if (Input.GetKeyDown(KeyCode.Alpha1))
        {
            SetSlot(0);
            EquipWeapon();
            Debug.Log("Razor equipped");
        }

        if (Input.GetKeyDown(KeyCode.Alpha2))
        {
            SetSlot(1);
            EquipWeapon();
            Debug.Log("Shotgun equipped");
        }

        if (Input.GetKeyDown(KeyCode.Alpha3))
        {
            SetSlot(2);
            EquipWeapon();  
            Debug.Log("Crossbow equipped");
        }
    }

    void SetSlot(int slotIndex)
    {
        currentSlot = slotIndex;
        EquipWeapon();
    }

    void EquipWeapon()
    {
        switch (currentSlot)
        {
            case 0:
                Razor();
                razor.SetActive(true);
                shotgun.SetActive(false);
                crossbow.SetActive(false);
                break;

            case 1:
                Shotgun();
                shotgun.SetActive(true);
                crossbow.SetActive(false);
                razor.SetActive(false);
                break;

            case 2:
                Crossbow();
                crossbow.SetActive(true);
                razor.SetActive(false);
                shotgun.SetActive(false);
                break;
        }
    }

    void Razor()
    {
        Debug.Log("Razor equipped");
    }

    void Shotgun()
    {
        Debug.Log("Shotgun equipped");
    }
    
    void Crossbow()
    {
        Debug.Log("Crossbow equipped");
    }

    void ShootCrossbow()
    {
        Ray ray = playerCamera.ViewportPointToRay(new Vector3(0.5f, 0.5f, 0f));

        Vector3 targetPoint;

        if (Physics.Raycast(ray, out RaycastHit hit, aimDistance, aimMask))

            targetPoint = hit.point;

        else

            targetPoint = ray.GetPoint(aimDistance);

        Vector3 shootDir = (targetPoint - crossbowTip.position).normalized;

        GameObject bolt = Instantiate(

            boltPrefab,

            crossbowTip.position,

            Quaternion.LookRotation(shootDir)

        );

        Rigidbody boltRb = bolt.GetComponent<Rigidbody>();

        if (boltRb != null)

        {

            boltRb.isKinematic = false;

            boltRb.linearVelocity = shootDir * boltSpeed;

        }
    }
}
