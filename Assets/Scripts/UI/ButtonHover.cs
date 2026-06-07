using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;

public class ButtonHover : MonoBehaviour
{
    public Image arrow;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        arrow.enabled = false;
    }

    // Update is called once per frame
    void Update()
    {

    }

    public void OnPointerEnter()
    {
        arrow.enabled = true;
    }

    public void OnPointerExit()
    {
        arrow.enabled = false;
    }
}
