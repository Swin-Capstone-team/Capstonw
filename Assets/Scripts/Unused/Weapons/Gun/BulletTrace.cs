using UnityEngine;
using System.Collections;

public class BulletTrace : MonoBehaviour {
    private LineRenderer line;
    private float duration = 0.05f;

    public void Init(Vector3 start, Vector3 end) {
        line = GetComponent<LineRenderer>();
        line.SetPosition(0, start);
        line.SetPosition(1, end);
        StartCoroutine(Fade());
    }

    private IEnumerator Fade() {
        float elapsed = 0;
        while (elapsed < duration) {
            elapsed += Time.deltaTime;
            yield return null;
        }
        Destroy(gameObject);
    }
}