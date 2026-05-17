using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(MovementManager))]
public class MovementManagerEditor : Editor
{
    private SerializedProperty runtimeDebugProperty;

    private void OnEnable()
    {
        runtimeDebugProperty = serializedObject.FindProperty("runtimeDebug");
    }

    public override void OnInspectorGUI()
    {
        serializedObject.Update();

        DrawPropertiesExcluding(serializedObject, "runtimeDebug");

        if (runtimeDebugProperty != null)
        {
            EditorGUILayout.Space();
            EditorGUILayout.LabelField("Runtime Debug", EditorStyles.boldLabel);

            using (new EditorGUI.DisabledScope(true))
            {
                DrawRuntimeDebugFields();
            }
        }

        serializedObject.ApplyModifiedProperties();
    }

    private void DrawRuntimeDebugFields()
    {
        EditorGUI.indentLevel++;
        EditorGUILayout.PropertyField(runtimeDebugProperty.FindPropertyRelative("configuredSpeed"));
        EditorGUILayout.PropertyField(runtimeDebugProperty.FindPropertyRelative("horizontalSpeed"));
        EditorGUILayout.PropertyField(runtimeDebugProperty.FindPropertyRelative("verticalSpeed"));
        EditorGUILayout.PropertyField(runtimeDebugProperty.FindPropertyRelative("slopeAngle"));
        EditorGUILayout.PropertyField(runtimeDebugProperty.FindPropertyRelative("grounded"));
        EditorGUILayout.PropertyField(runtimeDebugProperty.FindPropertyRelative("inAir"));
        EditorGUILayout.PropertyField(runtimeDebugProperty.FindPropertyRelative("sliding"));
        EditorGUILayout.PropertyField(runtimeDebugProperty.FindPropertyRelative("queuedSlideOnLand"));
        EditorGUILayout.PropertyField(runtimeDebugProperty.FindPropertyRelative("currentState"));
        EditorGUI.indentLevel--;
    }
}
