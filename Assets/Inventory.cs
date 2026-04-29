using UnityEngine;

public class Inventory : MonoBehaviour
{
    public int currentSlot = 0; 
    public GameObject razor;
    public GameObject shotgun;
    public GameObject crossbow;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        currentSlot = 0;
        EquipWeapon();
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Alpha1))
        {
            SetSlot(0);
            EquipWeapon();
        }

        if (Input.GetKeyDown(KeyCode.Alpha2))
        {
            SetSlot(1);
            EquipWeapon();
        }

        if (Input.GetKeyDown(KeyCode.Alpha3))
        {
            SetSlot(2);
            EquipWeapon();  
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

    
}
