using UnityEditor;
using UnityEngine;

// This script is just for better organisation of the unity inspector editor (hides unused settings based of mode)

[CustomEditor(typeof(GrappleAnchor))]
public class GrappleAnchorEditor : Editor
{
    public override void OnInspectorGUI()
    {
        GrappleAnchor anchor = (GrappleAnchor)target;

        anchor.anchorType = (GrappleAnchor.AnchorType)EditorGUILayout.EnumPopup("Anchor Type", anchor.anchorType);

        EditorGUILayout.Space();

        if (anchor.anchorType == GrappleAnchor.AnchorType.Line)
        {
            EditorGUILayout.LabelField("Line Settings", EditorStyles.boldLabel);
            anchor.lineLength = EditorGUILayout.FloatField("Length", anchor.lineLength);
            anchor.linePoints = EditorGUILayout.IntField("Points", anchor.linePoints);
        }
        else if (anchor.anchorType == GrappleAnchor.AnchorType.Plane || anchor.anchorType == GrappleAnchor.AnchorType.Perimeter)
        {
            EditorGUILayout.LabelField("Plane Settings", EditorStyles.boldLabel);
            anchor.planeSize = EditorGUILayout.Vector2Field("Size", anchor.planeSize);
            anchor.planeResolution = EditorGUILayout.Vector2IntField("Resolution", anchor.planeResolution);
        }

        if (GUI.changed)
        {
            EditorUtility.SetDirty(anchor);
        }
    }
}