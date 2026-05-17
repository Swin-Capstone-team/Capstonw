using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(MovementManager))]
public class MovementManagerEditor : Editor
{
    public override void OnInspectorGUI()
    {
        DrawDefaultInspector();

        EditorGUILayout.Space();
        EditorGUILayout.LabelField("Runtime Debug", EditorStyles.boldLabel);

        using (new EditorGUI.DisabledScope(true))
        {
            DrawRuntimeDebugFields((MovementManager)target);
        }
    }

    public override bool RequiresConstantRepaint()
    {
        return Application.isPlaying;
    }

    private static void DrawRuntimeDebugFields(MovementManager manager)
    {
        EditorGUI.indentLevel++;
        EditorGUILayout.FloatField("Configured Speed", manager.CurrentSpeed);
        EditorGUILayout.FloatField("Horizontal Speed", manager.HorizontalSpeed);
        EditorGUILayout.FloatField("Vertical Speed", manager.VerticalSpeed);
        EditorGUILayout.FloatField("Slope Angle", manager.CurrentGroundSlopeAngle);
        EditorGUILayout.Toggle("Grounded", manager.IsGrounded);
        EditorGUILayout.Toggle("In Air", !manager.IsGrounded);
        EditorGUILayout.Toggle("Sliding", manager.IsSliding);
        EditorGUILayout.Toggle("Queued Slide On Land", manager.HasQueuedSlideOnLand);
        EditorGUILayout.TextField("Current State", manager.CurrentStateName);
        EditorGUI.indentLevel--;
    }
}
