using System.Collections.Generic;
using UnityEngine;

public class GrappleAnchor : MonoBehaviour
{
    public enum AnchorType
    {
        Point,
        Line,
        Plane,
        Perimeter,
        Cube,
        CubePerimeter
    }

    public AnchorType anchorType = AnchorType.Point;

    [Header("Line Settings")]
    public float lineLength = 5f;
    public int linePoints = 5;

    [Header("Plane Settings")]
    public Vector2 planeSize = new Vector2(5f, 5f);
    public Vector2Int planeResolution = new Vector2Int(3, 3);

    [Header("Cube Settings")]
    public Vector3 cubeSize = new Vector3(5f, 5f, 5f);
    public Vector3Int cubeResolution = new Vector3Int(3, 3, 3);


    public static List<GrappleAnchor> AllAnchors = new List<GrappleAnchor>();

    private List<Vector3> localPoints = new List<Vector3>();

    public float boundingRadius;
    

    void OnEnable()
    {
        GeneratePoints();
        AllAnchors.Add(this);
    }

    void OnDisable()
    {
        AllAnchors.Remove(this);
    }

    void GeneratePoints()
    {
        localPoints.Clear();

        if (anchorType == AnchorType.Point)
        {
            localPoints.Add(Vector3.zero);
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

                localPoints.Add(localPos);
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

                    localPoints.Add(localPos);
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

                    localPoints.Add(localPos);
                }
            }
        }
        else if (anchorType == AnchorType.Cube)
        {
            for (int x = 0; x < cubeResolution.x; x++)
            {
                for (int y = 0; y < cubeResolution.y; y++)
                {
                    for (int z = 0; z < cubeResolution.z; z++)
                    {
                        bool isSurface =
                            x == 0 || y == 0 || z == 0 ||
                            x == cubeResolution.x - 1 ||
                            y == cubeResolution.y - 1 ||
                            z == cubeResolution.z - 1;

                        if (!isSurface) continue;

                        float tx = x / (float)(cubeResolution.x - 1);
                        float ty = y / (float)(cubeResolution.y - 1);
                        float tz = z / (float)(cubeResolution.z - 1);

                        Vector3 localPos = new Vector3(
                            Mathf.Lerp(-cubeSize.x * 0.5f, cubeSize.x * 0.5f, tx),
                            Mathf.Lerp(-cubeSize.y * 0.5f, cubeSize.y * 0.5f, ty),
                            Mathf.Lerp(-cubeSize.z * 0.5f, cubeSize.z * 0.5f, tz)
                        );

                        localPoints.Add(localPos);
                    }
                }
            }
        }
        else if (anchorType == AnchorType.CubePerimeter)
        {
            for (int x = 0; x < cubeResolution.x; x++)
            {
                for (int y = 0; y < cubeResolution.y; y++)
                {
                    for (int z = 0; z < cubeResolution.z; z++)
                    {
                        int edgeCount = 0;

                        if (x == 0 || x == cubeResolution.x - 1) edgeCount++;
                        if (y == 0 || y == cubeResolution.y - 1) edgeCount++;
                        if (z == 0 || z == cubeResolution.z - 1) edgeCount++;

                        if (edgeCount < 2) continue;

                        float tx = x / (float)(cubeResolution.x - 1);
                        float ty = y / (float)(cubeResolution.y - 1);
                        float tz = z / (float)(cubeResolution.z - 1);

                        Vector3 localPos = new Vector3(
                            Mathf.Lerp(-cubeSize.x * 0.5f, cubeSize.x * 0.5f, tx),
                            Mathf.Lerp(-cubeSize.y * 0.5f, cubeSize.y * 0.5f, ty),
                            Mathf.Lerp(-cubeSize.z * 0.5f, cubeSize.z * 0.5f, tz)
                        );

                        localPoints.Add(localPos);
                    }
                }
            }
        }

        boundingRadius = 0f;

        foreach (var local in localPoints)
        {
            float dist = local.magnitude;
            if (dist > boundingRadius)
                boundingRadius = dist;
        }
    }

    public int GetPointCount()
    {
        return localPoints.Count;
    }

    public Vector3 GetWorldPoint(int index)
    {
        return transform.TransformPoint(localPoints[index]);
    }

    void OnDrawGizmos()
    {
        GeneratePoints();

        Gizmos.color = Color.yellow;

        foreach (var local in localPoints)
        {
            Vector3 world = transform.TransformPoint(local);
            Gizmos.DrawSphere(world, 0.1f);
        }
    }
}