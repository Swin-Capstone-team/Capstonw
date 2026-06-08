using UnityEditor;
using UnityEngine;
using System.IO;

public class Replace_Mesh : EditorWindow
{
    private DefaultAsset assetSearchFolder;

    [MenuItem("Tools/Replace Selected With Matching Assets")]
    public static void ShowWindow()
    {
        GetWindow<Replace_Mesh>("Replace Mesh");
    }

    private void OnGUI()
    {
        GUILayout.Label("Replace selected objects with FBX/Prefab assets of the same name", EditorStyles.boldLabel);

        assetSearchFolder = (DefaultAsset)EditorGUILayout.ObjectField(
            "Asset Search Folder",
            assetSearchFolder,
            typeof(DefaultAsset),
            false
        );

        GUILayout.Space(10);

        if (GUILayout.Button("Replace Selected With Matching Assets"))
        {
            ReplaceSelectedWithMatchingAssets();
        }
    }

    private void ReplaceSelectedWithMatchingAssets()
    {
        if (assetSearchFolder == null)
        {
            Debug.LogError("No asset search folder assigned.");
            return;
        }

        string folderPath = AssetDatabase.GetAssetPath(assetSearchFolder);

        if (!AssetDatabase.IsValidFolder(folderPath))
        {
            Debug.LogError("Assigned object is not a valid folder.");
            return;
        }

        GameObject[] selectedObjects = Selection.gameObjects;

        if (selectedObjects.Length == 0)
        {
            Debug.LogError("No scene objects selected.");
            return;
        }

        Undo.SetCurrentGroupName("Replace Selected With Matching Assets");
        int undoGroup = Undo.GetCurrentGroup();

        int replacedCount = 0;
        int failedCount = 0;

        foreach (GameObject oldObj in selectedObjects)
        {
            string cleanName = CleanObjectName(oldObj.name);

            GameObject matchingAsset = FindMatchingAsset(folderPath, cleanName);

            if (matchingAsset == null)
            {
                Debug.LogWarning($"No matching FBX/prefab found for: {oldObj.name}");
                failedCount++;
                continue;
            }

            Transform oldTransform = oldObj.transform;

            Transform oldParent = oldTransform.parent;
            int oldSiblingIndex = oldTransform.GetSiblingIndex();

            Vector3 oldPosition = oldTransform.position;
            Quaternion oldRotation = oldTransform.rotation;
            Vector3 oldScale = oldTransform.localScale;

            GameObject newObj = (GameObject)PrefabUtility.InstantiatePrefab(matchingAsset);

            if (newObj == null)
            {
                Debug.LogWarning($"Could not instantiate asset for: {oldObj.name}");
                failedCount++;
                continue;
            }

            Undo.RegisterCreatedObjectUndo(newObj, "Create matching asset replacement");

            Transform newTransform = newObj.transform;

            newTransform.SetParent(oldParent);
            newTransform.position = oldPosition;
            newTransform.rotation = oldRotation;
            newTransform.localScale = oldScale;
            newTransform.SetSiblingIndex(oldSiblingIndex);

            newObj.name = oldObj.name;

            Undo.DestroyObjectImmediate(oldObj);

            replacedCount++;
        }

        Undo.CollapseUndoOperations(undoGroup);

        Debug.Log($"Replacement complete. Replaced: {replacedCount}, Failed: {failedCount}");
    }

    private string CleanObjectName(string objectName)
    {
        string cleanName = objectName;

        // Removes Unity duplicate names like "Rock (1)"
        if (cleanName.Contains(" ("))
        {
            cleanName = cleanName.Substring(0, cleanName.IndexOf(" ("));
        }

        return cleanName;
    }

    private GameObject FindMatchingAsset(string folderPath, string objectName)
    {
        // Search normal prefabs first
        string[] prefabGuids = AssetDatabase.FindAssets("t:Prefab", new[] { folderPath });

        foreach (string guid in prefabGuids)
        {
            string assetPath = AssetDatabase.GUIDToAssetPath(guid);
            string assetName = Path.GetFileNameWithoutExtension(assetPath);

            if (assetName == objectName)
            {
                return AssetDatabase.LoadAssetAtPath<GameObject>(assetPath);
            }
        }

        // Then search raw FBX / model files
        string[] modelGuids = AssetDatabase.FindAssets("t:Model", new[] { folderPath });

        foreach (string guid in modelGuids)
        {
            string assetPath = AssetDatabase.GUIDToAssetPath(guid);
            string assetName = Path.GetFileNameWithoutExtension(assetPath);

            if (assetName == objectName)
            {
                return AssetDatabase.LoadAssetAtPath<GameObject>(assetPath);
            }
        }

        return null;
    }
}