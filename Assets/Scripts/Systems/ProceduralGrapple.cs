using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// Add this component to a Mesh object in the scene.
/// It procedurally creates child GameObjects with the existing GrappleAnchor component set to Point mode.
/// 
/// This script does NOT modify the existing grapple system.
/// It only outputs GrappleAnchor objects that the existing system should already understand.
/// </summary>
[DisallowMultipleComponent]
public class ProceduralGrapple : MonoBehaviour
{
    [Header("Generation Settings")]
    [Tooltip("Approximate distance between generated grapple anchors in world units.")]
    public float spacing = 1.5f;

    [Tooltip("Pushes generated anchors slightly away from the mesh surface to avoid being inside the geometry.")]
    public float surfaceOffset = 0.05f;

    [Tooltip("Name of the child container that generated anchors will be placed under.")]
    public string generatedParentName = "Generated_GrappleAnchors";

    [Header("Mesh Filtering")]
    [Tooltip("If enabled, very tiny triangles will be ignored.")]
    public bool ignoreTinyTriangles = true;

    [Tooltip("Triangles with world-space area below this value will be ignored.")]
    public float minimumTriangleArea = 0.01f;

    [Header("Output")]
    [Tooltip("Name prefix for created anchor objects.")]
    public string anchorNamePrefix = "GrappleAnchor_";

    
    // Removes previously generated anchors under this object's generated parent.
    
    public void ClearGeneratedAnchors()
    {
        Transform parent = transform.Find(generatedParentName);

        if (parent == null)
            return;

#if UNITY_EDITOR
        if (!Application.isPlaying)
        {
            UnityEditor.Undo.DestroyObjectImmediate(parent.gameObject);
        }
        else
#endif
        {
            Destroy(parent.gameObject);
        }
    }

    // Generates point-based GrappleAnchor children from this object's MeshFilter.
    public int GenerateAnchors()
    {
        MeshFilter meshFilter = GetComponent<MeshFilter>();

        if (meshFilter == null || meshFilter.sharedMesh == null)
        {
            Debug.LogWarning($"ProceduralGrapple on '{name}' needs a MeshFilter with a valid mesh.", this);
            return 0;
        }

        if (spacing <= 0f)
        {
            Debug.LogWarning("ProceduralGrapple spacing must be greater than zero.", this);
            return 0;
        }

        ClearGeneratedAnchors();

        GameObject parentObject = new GameObject(generatedParentName);

#if UNITY_EDITOR
        if (!Application.isPlaying)
            UnityEditor.Undo.RegisterCreatedObjectUndo(parentObject, "Create Generated Grapple Anchors Parent");
#endif

        Transform parent = parentObject.transform;
        parent.SetParent(transform, false);
        parent.localPosition = Vector3.zero;
        parent.localRotation = Quaternion.identity;
        parent.localScale = Vector3.one;

        Mesh mesh = meshFilter.sharedMesh;
        Vector3[] vertices = mesh.vertices;
        int[] triangles = mesh.triangles;

        List<Vector3> acceptedWorldPoints = new List<Vector3>();
        float minDistanceSqr = spacing * spacing;

        for (int i = 0; i < triangles.Length; i += 3)
        {
            Vector3 localA = vertices[triangles[i]];
            Vector3 localB = vertices[triangles[i + 1]];
            Vector3 localC = vertices[triangles[i + 2]];

            Vector3 worldA = transform.TransformPoint(localA);
            Vector3 worldB = transform.TransformPoint(localB);
            Vector3 worldC = transform.TransformPoint(localC);

            Vector3 normal = Vector3.Cross(worldB - worldA, worldC - worldA).normalized;
            float area = Vector3.Cross(worldB - worldA, worldC - worldA).magnitude * 0.5f;

            if (ignoreTinyTriangles && area < minimumTriangleArea)
                continue;

            // Number of sample attempts scales with triangle area.
            // Large triangles get multiple samples, small triangles get at least one.
            int samples = Mathf.Max(1, Mathf.CeilToInt(area / (spacing * spacing)));

            for (int s = 0; s < samples; s++)
            {
                Vector3 sampledPoint = SamplePointOnTriangle(worldA, worldB, worldC, s, samples);
                sampledPoint += normal * surfaceOffset;

                if (IsFarEnoughFromExistingPoints(sampledPoint, acceptedWorldPoints, minDistanceSqr))
                {
                    acceptedWorldPoints.Add(sampledPoint);
                }
            }
        }

        for (int i = 0; i < acceptedWorldPoints.Count; i++)
        {
            GameObject anchorObject = new GameObject(anchorNamePrefix + (i + 1).ToString("000"));

#if UNITY_EDITOR
            if (!Application.isPlaying)
                UnityEditor.Undo.RegisterCreatedObjectUndo(anchorObject, "Create Grapple Anchor");
#endif

            anchorObject.transform.SetParent(parent, true);
            anchorObject.transform.position = acceptedWorldPoints[i];
            anchorObject.transform.rotation = Quaternion.identity;
            anchorObject.transform.localScale = Vector3.one;

            GrappleAnchor anchor = anchorObject.AddComponent<GrappleAnchor>();
            anchor.anchorType = GrappleAnchor.AnchorType.Point;
        }

        Debug.Log($"Generated {acceptedWorldPoints.Count} grapple anchors on '{name}'.", this);
        return acceptedWorldPoints.Count;
    }

    private static bool IsFarEnoughFromExistingPoints(Vector3 point, List<Vector3> existingPoints, float minDistanceSqr)
    {
        for (int i = 0; i < existingPoints.Count; i++)
        {
            if ((point - existingPoints[i]).sqrMagnitude < minDistanceSqr)
                return false;
        }

        return true;
    }

    
    /// Deterministic-ish triangle sampling. Good enough for production testing without random changing every click.
    private static Vector3 SamplePointOnTriangle(Vector3 a, Vector3 b, Vector3 c, int sampleIndex, int sampleCount)
    {
        if (sampleCount <= 1)
            return (a + b + c) / 3f;

        float u = Halton(sampleIndex + 1, 2);
        float v = Halton(sampleIndex + 1, 3);

        // Keeps barycentric coordinates inside triangle.
        if (u + v > 1f)
        {
            u = 1f - u;
            v = 1f - v;
        }

        return a + (b - a) * u + (c - a) * v;
    }

    private static float Halton(int index, int baseValue)
    {
        float result = 0f;
        float fraction = 1f / baseValue;

        while (index > 0)
        {
            result += fraction * (index % baseValue);
            index /= baseValue;
            fraction /= baseValue;
        }

        return result;
    }
}
