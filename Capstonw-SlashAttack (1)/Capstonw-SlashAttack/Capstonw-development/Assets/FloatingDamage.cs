using UnityEngine;
using TMPro;

public class FloatingDamage : MonoBehaviour
{
    public float moveSpeed = 1.5f;
    public float lifeTime = 1f;

    private TextMeshPro textMesh;
    private Camera cam;

    void Awake()
    {
        textMesh = GetComponent<TextMeshPro>();
    }

    void Start()
    {
        cam = Camera.main;
        Destroy(gameObject, lifeTime);
    }

    void Update()
    {
        transform.position += Vector3.up * moveSpeed * Time.deltaTime;

        if (cam != null)
        {
            transform.forward = cam.transform.forward;
        }
    }

    public void SetText(string value)
    {
        textMesh.text = value;
    }
}