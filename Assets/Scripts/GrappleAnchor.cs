using System.Collections.Generic;
using UnityEngine;

public class GrappleAnchor : MonoBehaviour
{
    public enum AnchorType
    {
        Point,
        Line,
        Plane,
        Perimeter
    }

    public AnchorType anchorType = AnchorType.Point;

    [Header("Line Settings")]
    public float lineLength = 5f;
    public int linePoints = 5;

    [Header("Plane Settings")]
    public Vector2 planeSize = new Vector2(5f, 5f);
    public Vector2Int planeResolution = new Vector2Int(3, 3);

    public static List<Vector3> AllAnchorPoints = new List<Vector3>();

    private List<Vector3> generatedPoints = new List<Vector3>();

    void OnEnable()
    {
        GeneratePoints();
        RegisterPoints();
    }

    void OnDisable()
    {
        UnregisterPoints();
    }

    void GeneratePoints()
    {
        generatedPoints.Clear();

        if (anchorType == AnchorType.Point)
        {
            generatedPoints.Add(transform.position);
        }
        else if (anchorType == AnchorType.Line)
        {
            for (int i = 0; i < linePoints; i++)
            {
                float t = i / (float)(linePoints - 1);
                Vector3 localPos = Vector3.Lerp(
                    -Vector3.right * lineLength * 0.5f,
                     Vector3.right * lineLength * 0.5f,
                    t
                );

                generatedPoints.Add(transform.TransformPoint(localPos));
            }
        }
        else if (anchorType == AnchorType.Plane)
        {
            for (int x = 0; x < planeResolution.x; x++)
            {
                for (int y = 0; y < planeResolution.y; y++)
                {
                    float tx = x / (float)(planeResolution.x - 1);
                    float ty = y / (float)(planeResolution.y - 1);

                    Vector3 localPos = new Vector3(
                        Mathf.Lerp(-planeSize.x * 0.5f, planeSize.x * 0.5f, tx),
                        Mathf.Lerp(-planeSize.y * 0.5f, planeSize.y * 0.5f, ty),
                        0f
                    );

                    generatedPoints.Add(transform.TransformPoint(localPos));
                }
            }
        }
        else if (anchorType == AnchorType.Perimeter)
        {
            for (int x = 0; x < planeResolution.x; x++)
            {
                for (int y = 0; y < planeResolution.y; y++)
                {
                    bool isEdge =
                        x == 0 ||
                        y == 0 ||
                        x == planeResolution.x - 1 ||
                        y == planeResolution.y - 1;

                    if (!isEdge) continue;

                    float tx = x / (float)(planeResolution.x - 1);
                    float ty = y / (float)(planeResolution.y - 1);

                    Vector3 localPos = new Vector3(
                        Mathf.Lerp(-planeSize.x * 0.5f, planeSize.x * 0.5f, tx),
                        Mathf.Lerp(-planeSize.y * 0.5f, planeSize.y * 0.5f, ty),
                        0f
                    );

                    generatedPoints.Add(transform.TransformPoint(localPos));
                }
            }
        }
    }

    void RegisterPoints()
    {
        AllAnchorPoints.AddRange(generatedPoints);
    }

    void UnregisterPoints()
    {
        foreach (var p in generatedPoints)
        {
            AllAnchorPoints.Remove(p);
        }
    }

    void OnDrawGizmos()
    {
        GeneratePoints();

        Gizmos.color = Color.yellow;

        foreach (var point in generatedPoints)
        {
            Gizmos.DrawSphere(point, 0.1f);
        }
    }
}