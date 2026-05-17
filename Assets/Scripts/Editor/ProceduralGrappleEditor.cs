using UnityEditor;
using UnityEngine;

/// <summary>
/// Custom Inspector for ProceduralGrapple.
/// Put this file inside an Editor folder.
/// </summary>
[CustomEditor(typeof(ProceduralGrapple))]
public class ProceduralGrappleEditor : Editor
{
    public override void OnInspectorGUI()
    {
        DrawDefaultInspector();

        ProceduralGrapple generator = (ProceduralGrapple)target;

        EditorGUILayout.Space();
        EditorGUILayout.LabelField("Procedural Grapple Tools", EditorStyles.boldLabel);

        if (GUILayout.Button("Generate Grapple Anchors"))
        {
            generator.GenerateAnchors();
            EditorUtility.SetDirty(generator);
        }

        if (GUILayout.Button("Clear Generated Anchors"))
        {
            generator.ClearGeneratedAnchors();
            EditorUtility.SetDirty(generator);
        }
    }
}
