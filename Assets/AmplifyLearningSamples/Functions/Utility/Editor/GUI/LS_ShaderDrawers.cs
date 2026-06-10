
using System;
using System.Linq; // used in LS_DrawerGradient
using UnityEditor;
using UnityEngine;

namespace LearningSamples.Drawers
{
    #region [LS_Constants]
    public static class LS_CONSTANTS
    {
        public static Color CategoryColor
        {
            get
            {
                if (EditorGUIUtility.isProSkin)
                {
                    return LS_CONSTANTS.ColorDarkGray;
                }
                else
                {
                    return LS_CONSTANTS.ColorLightGray;
                }
            }
        }

        public static Color LineColor
        {
            get
            {
                if (EditorGUIUtility.isProSkin)
                {
                    return new Color(0.15f, 0.15f, 0.15f, 1.0f);
                }
                else
                {
                    return new Color(0.65f, 0.65f, 0.65f, 1.0f);
                }
            }
        }

        public static Color ColorDarkGray
        {
            get
            {
                return new Color(0.2f, 0.2f, 0.2f, 1.0f);
            }
        }

        public static Color ColorLightGray
        {
            get
            {
                return new Color(0.82f, 0.82f, 0.82f, 1.0f);
            }
        }

        public static GUIStyle TitleStyle
        {
            get
            {
                GUIStyle guiStyle = new GUIStyle("label")
                {
                    richText = true,
                    alignment = TextAnchor.MiddleCenter
                };

                return guiStyle;
            }
        }

        public static GUIStyle HeaderStyle
        {
            get
            {
                GUIStyle guiStyle = new GUIStyle("label")
                {
                    richText = true,
                    fontStyle = FontStyle.Bold,
                    alignment = TextAnchor.MiddleLeft
                };

                return guiStyle;
            }
        }
    }

    public static class LS_Drawers
    {
        public static bool DrawInspectorCategory(string bannerText, bool enabled, bool colapsable, float top, float down, Material material)
        {
            //if (colapsable)
            //{
            //    if (enabled)
            //    {
            //        GUILayout.Space(top);
            //    }
            //    else
            //    {
            //        GUILayout.Space(0);
            //    }
            //}
            //else
            //{
            //    GUILayout.Space(top);
            //}

            var fullRect = GUILayoutUtility.GetRect(0, 0, 18, 0);
            var fillRect = new Rect(0, fullRect.y, fullRect.xMax + 10, 18);
            var lineRect = new Rect(0, fullRect.y - 1, fullRect.xMax + 10, 1);
            var titleRect = new Rect(fullRect.position.x - 1, fullRect.position.y, fullRect.width, 18);
            var arrowRect = new Rect(fullRect.position.x - 15, fullRect.position.y, fullRect.width, 18);

            if (colapsable)
            {
                if (GUI.Button(arrowRect, "", GUIStyle.none))
                {
                    enabled = !enabled;
                }
            }
            else
            {
                enabled = true;
            }

            EditorGUI.DrawRect(fillRect, LS_CONSTANTS.CategoryColor);
            EditorGUI.DrawRect(lineRect, LS_CONSTANTS.LineColor);

            GUI.color = new Color(1, 1, 1, 0.9f);

            GUI.Label(titleRect, bannerText, LS_CONSTANTS.HeaderStyle);

            if (material.GetTag("RenderPipeline", false) != "HDRenderPipeline")
            {
                GUI.color = new Color(1, 1, 1, 0.39f);

                if (colapsable)
                {
                    if (enabled)
                    {
                        GUI.Label(arrowRect, "<size=10>▼</size>", LS_CONSTANTS.HeaderStyle);
                        //GUILayout.Space(down);
                    }
                    else
                    {
                        GUI.Label(arrowRect, "<size=10>►</size>", LS_CONSTANTS.HeaderStyle);
                        //GUILayout.Space(0);
                    }
                }
                else
                {
                    //GUILayout.Space(down);
                }
            }

            GUI.color = Color.white;

            GUILayout.Space(5);

            return enabled;
        }
    }
    #endregion [LS_Constants]

    #region [LS_DrawersCategory]
    public class LS_DrawerCategory : MaterialPropertyDrawer
    {
        public string category;
        public float top;
        public float down;
        public string colapsable;
        public string conditions = "";

        public LS_DrawerCategory(string category)
        {
            this.category = category;
            this.colapsable = "false";
            this.top = 10;
            this.down = 10;
        }

        public LS_DrawerCategory(string category, string colapsable)
        {
            this.category = category;
            this.colapsable = colapsable;
            this.top = 10;
            this.down = 10;
        }

        public LS_DrawerCategory(string category, float top, float down)
        {
            this.category = category;
            this.colapsable = "false";
            this.top = top;
            this.down = down;
        }

        public LS_DrawerCategory(string category, string colapsable, float top, float down)
        {
            this.category = category;
            this.colapsable = colapsable;
            this.top = top;
            this.down = down;
        }

        public LS_DrawerCategory(string category, string colapsable, string conditions, float top, float down)
        {
            this.category = category;
            this.colapsable = colapsable;
            this.conditions = conditions;
            this.top = top;
            this.down = down;
        }

        public override void OnGUI(Rect position, MaterialProperty prop, String label, MaterialEditor materialEditor)
        {
            GUI.enabled = true;
            EditorGUI.indentLevel = 0;

            Material material = materialEditor.target as Material;

            if (conditions == "")
            {
                DrawInspector(prop, material);
            }
            else
            {
                bool showInspector = false;

                string[] split = conditions.Split(char.Parse(" "));

                for (int i = 0; i < split.Length; i++)
                {
                    if (material.HasProperty(split[i]))
                    {
                        showInspector = true;
                        break;
                    }
                }

                if (showInspector)
                {
                    DrawInspector(prop, material);
                }
            }
        }

        public override float GetPropertyHeight(MaterialProperty prop, string label, MaterialEditor editor)
        {
            return -2;
        }

        void DrawInspector(MaterialProperty prop, Material material)
        {
            bool isColapsable = false;

            if (colapsable == "true")
            {
                isColapsable = true;
            }

            bool isEnabled = true;

            if (prop.floatValue < 0.5f)
            {
                isEnabled = false;
            }

            isEnabled = LS_Drawers.DrawInspectorCategory(category, isEnabled, isColapsable, top, down, material);

            if (isEnabled)
            {
                prop.floatValue = 1;
            }
            else
            {
                prop.floatValue = 0;
            }
        }
    }
    #endregion [LS_DrawersCategory]

    #region [LS_DrawersCategorySpace]
    public class LS_DrawerCategorySpace : MaterialPropertyDrawer
    {
        public float space;
        public string conditions = "";

        public LS_DrawerCategorySpace(float space)
        {
            this.space = space;
        }

        public LS_DrawerCategorySpace(float space, string conditions)
        {
            this.space = space;
            this.conditions = conditions;
        }

        public override void OnGUI(Rect position, MaterialProperty prop, string label, MaterialEditor materialEditor)
        {
            if (conditions == "")
            {
                GUILayout.Space(space);
            }
            else
            {
                Material material = materialEditor.target as Material;

                bool showInspector = false;

                string[] split = conditions.Split(char.Parse(" "));

                for (int i = 0; i < split.Length; i++)
                {
                    if (material.HasProperty(split[i]))
                    {
                        showInspector = true;
                        break;
                    }
                }

                if (showInspector)
                {
                    GUILayout.Space(space);
                }
            }

        }

        public override float GetPropertyHeight(MaterialProperty prop, string label, MaterialEditor editor)
        {
            return -2;
        }
    }
    #endregion [LS_DrawersCategorySpace]

    #region [LS_DrawerEmissionFlags]
    public class LS_DrawerEmissionFlags : MaterialPropertyDrawer
    {
        public override void OnGUI(Rect position, MaterialProperty prop, String label, MaterialEditor editor)
        {
            var material = editor.target as Material;

            float flag = prop.floatValue;

            if (material.GetTag("RenderPipeline", false) == "HDRenderPipeline")
            {
                EditorGUILayout.BeginHorizontal();
                GUILayout.Space(0);
                GUILayout.Label(label, GUILayout.Width(EditorGUIUtility.labelWidth));
                flag = EditorGUILayout.Popup((int)flag, new string[] { "None", "Any", "Baked", "Realtime" });
                EditorGUILayout.EndHorizontal();
            }
            else
            {
                EditorGUILayout.BeginHorizontal();
                GUILayout.Space(-2);
                GUILayout.Label(label, GUILayout.Width(EditorGUIUtility.labelWidth));
                flag = EditorGUILayout.Popup((int)flag, new string[] { "None", "Any", "Baked", "Realtime" });
                EditorGUILayout.EndHorizontal();
            }

            if (flag == 0)
            {
                material.globalIlluminationFlags = MaterialGlobalIlluminationFlags.None;
            }
            else if (flag == 1)
            {
                material.globalIlluminationFlags = MaterialGlobalIlluminationFlags.AnyEmissive;
            }
            else if (flag == 2)
            {
                material.globalIlluminationFlags = MaterialGlobalIlluminationFlags.BakedEmissive;
            }
            else if (flag == 3)
            {
                material.globalIlluminationFlags = MaterialGlobalIlluminationFlags.RealtimeEmissive;
            }

            prop.floatValue = flag;
        }

        public override float GetPropertyHeight(MaterialProperty prop, string label, MaterialEditor editor)
        {
            return -2;
        }
    }
    #endregion [LS_DrawerEmissionFlags]

    #region [LS_DrawerEmissiveIntensity]
    public class LS_DrawerEmissiveIntensity : MaterialPropertyDrawer
    {
        public string reference = "";
        public float top = 0;
        public float down = 0;

        public LS_DrawerEmissiveIntensity()
        {
            this.top = 0;
            this.down = 0;
        }

        public LS_DrawerEmissiveIntensity(string reference)
        {
            this.reference = reference;
            this.top = 0;
            this.down = 0;
        }

        public LS_DrawerEmissiveIntensity(float top, float down)
        {
            this.top = top;
            this.down = down;
        }

        public LS_DrawerEmissiveIntensity(string reference, float top, float down)
        {
            this.reference = reference;
            this.top = top;
            this.down = down;
        }

        public override void OnGUI(Rect position, MaterialProperty prop, String label, MaterialEditor editor)
        {
            var stylePopup = new GUIStyle(EditorStyles.popup)
            {
                fontSize = 9,
                alignment = TextAnchor.MiddleCenter,
            };

            var internalReference = MaterialEditor.GetMaterialProperty(editor.targets, reference);

            Vector4 propVector = prop.vectorValue;

            GUILayout.Space(top);

            EditorGUI.BeginChangeCheck();

            EditorGUI.showMixedValue = prop.hasMixedValue;

            // Add this to get the material
            var material = editor.target as Material;

            if (material.GetTag("RenderPipeline", false) == "HDRenderPipeline")
            {
                GUILayout.BeginHorizontal();

                GUILayout.Space(1);

                GUILayout.Label(label, GUILayout.Width(EditorGUIUtility.labelWidth));

                if (propVector.w == 0)
                {
                    propVector.y = EditorGUILayout.FloatField(propVector.y);
                }
                else if (propVector.w == 1)
                {
                    propVector.z = EditorGUILayout.FloatField(propVector.z);
                }

                GUILayout.Space(-25);

                propVector.w = (float)EditorGUILayout.Popup((int)propVector.w, new string[] { "Nits", "EV100" }, stylePopup, GUILayout.Width(65));

                GUILayout.EndHorizontal();
            }
            else
            {
                GUILayout.BeginHorizontal();
                GUILayout.Space(-1);
                GUILayout.Label(label, GUILayout.Width(EditorGUIUtility.labelWidth));

                if (propVector.w == 0)
                {
                    propVector.y = EditorGUILayout.FloatField(propVector.y);
                }
                else if (propVector.w == 1)
                {
                    propVector.z = EditorGUILayout.FloatField(propVector.z);
                }

                GUILayout.Space(2);

                propVector.w = (float)EditorGUILayout.Popup((int)propVector.w, new string[] { "Nits", "EV100" }, stylePopup, GUILayout.Width(50));

                GUILayout.EndHorizontal();
            }

            EditorGUI.showMixedValue = false;

            if (EditorGUI.EndChangeCheck())
            {
                if (propVector.w == 0)
                {
                    propVector.x = propVector.y;
                }
                else if (propVector.w == 1)
                {
                    propVector.x = ConvertEvToLuminance(propVector.z);
                }

                if (internalReference.displayName != null)
                {
                    internalReference.floatValue = propVector.x;
                }

                prop.vectorValue = propVector;
            }

            GUILayout.Space(down);
        }

        public override float GetPropertyHeight(MaterialProperty prop, string label, MaterialEditor editor)
        {
            return -2;
        }

        //public float ConvertLuminanceToEv(float luminance)
        //{
        //    return (float)Math.Log((luminance * 100f) / 12.5f, 2);
        //}

        public float ConvertEvToLuminance(float ev)
        {
            return (12.5f / 100.0f) * Mathf.Pow(2f, ev);
        }
    }
    #endregion [LS_DrawerEmissiveIntensity]

    #region [LS_DrawerEnumIndex]
    public class LS_DrawerEnumIndex : MaterialPropertyDrawer
    {
        public string options = "";

        public float top = 0;
        public float down = 0;

        public LS_DrawerEnumIndex(string options)
        {
            this.options = options;

            this.top = 0;
            this.down = 0;
        }

        public LS_DrawerEnumIndex(string options, float top, float down)
        {
            this.options = options;

            this.top = top;
            this.down = down;
        }

        public override void OnGUI(Rect position, MaterialProperty prop, String label, MaterialEditor materialEditor)
        {
            GUIStyle styleLabel = new GUIStyle(EditorStyles.label)
            {
                richText = true,
                alignment = TextAnchor.MiddleCenter,
                wordWrap = true
            };

            string[] enums = options.Split(char.Parse("_"));

            GUILayout.Space(top);

            int index = (int)prop.floatValue;

            index = EditorGUILayout.Popup(prop.displayName, index, enums);

            // Debug Value
            //EditorGUILayout.LabelField(index.ToString());

            prop.floatValue = index;

            GUI.enabled = true;

            GUILayout.Space(down);
        }

        public override float GetPropertyHeight(MaterialProperty prop, string label, MaterialEditor editor)
        {
            return -2;
        }
    }
    #endregion [LS_DrawerEnumIndex]

    #region [LS_DrawerGradient]
    //Credit: https://github.com/fisekoo
    public class LS_DrawerGradient : MaterialPropertyDrawer
    {
        private readonly int _resolution;
        private readonly bool _hdr;
        private MaterialProperty _prop;
        private string textureName => $"z_{_prop.name}Tex";

        public LS_DrawerGradient() : this(256, false) { }
        public LS_DrawerGradient(float resolution) : this((int)resolution, false) { }
        public LS_DrawerGradient(bool hdr) : this(256, hdr) { }
        public LS_DrawerGradient(float resolution, string parameters) : this((int)resolution, ExtractHdrParameter(parameters)) { }

        private LS_DrawerGradient(int resolution, bool hdr)
        {
            _resolution = resolution;
            _hdr = hdr;
        }

        private static bool ExtractHdrParameter(string parameters) =>
            parameters.Split(',').Any(s => string.Equals(s, "true", StringComparison.OrdinalIgnoreCase));

        public override void OnGUI(Rect position, MaterialProperty prop, string label, MaterialEditor editor)
        {
            OnGUI(position, prop, label, editor, string.Empty);
        }

        public void OnGUI(Rect position, MaterialProperty prop, string label, MaterialEditor editor, string tooltip)
        {
            var guiContent = new GUIContent(label, tooltip);
            OnGUI(position, prop, guiContent, editor);
        }


        public override void OnGUI(Rect position, MaterialProperty prop, GUIContent label, MaterialEditor editor)
        {
        #if UNITY_6000_2_OR_NEWER
            if (prop.propertyType != UnityEngine.Rendering.ShaderPropertyType.Texture)
        #else
            if (prop.type != MaterialProperty.PropType.Texture)
        #endif
            {
        #if UNITY_6000_2_OR_NEWER
                EditorGUI.HelpBox(position, $"[Gradient] used on property {prop.name} of type {prop.propertyType}.", MessageType.Error);
        #else
                EditorGUI.HelpBox(position, $"[Gradient] used on property {prop.name} of type {prop.type}.", MessageType.Error);
        #endif
                return;
            }

            if (!AssetDatabase.Contains(prop.targets.FirstOrDefault()))
            {
                EditorGUI.HelpBox(position, $"Material {prop.targets.FirstOrDefault()?.name} is not an Asset.", MessageType.Error);
                return;
            }

            _prop = prop;

            Gradient currentGradient = LoadCurrentGradient(prop);
            currentGradient ??= CreateDefaultGradient();

            EditorGUI.showMixedValue = prop.targets.Length > 1;

            using (var changeScope = new EditorGUI.ChangeCheckScope())
            {
                EditorGUILayout.Space(-22);
                EditorGUILayout.BeginHorizontal();

                DrawLabel(label);
                currentGradient = DrawGradientFieldWithButton(currentGradient, prop, _hdr, () => { });

                if (changeScope.changed)
                {
                    UpdateGradient(currentGradient, prop);
                }

                EditorGUILayout.EndHorizontal();
            }

            EditorGUI.showMixedValue = false;
        }

        private Gradient DrawGradientFieldWithButton(Gradient currentGradient, MaterialProperty property, bool hdr, System.Action buttonAction)
        {
            EditorGUILayout.BeginVertical(GUILayout.ExpandWidth(true));

            float gradientHeight = EditorGUIUtility.singleLineHeight;
            var totalRect = EditorGUILayout.GetControlRect(true, gradientHeight, EditorStyles.colorField, new[] { GUILayout.MinWidth(0) });
            var buttonWidth = 50;

            var gradientRect = new Rect(totalRect.x, totalRect.y, totalRect.width - buttonWidth - 5, gradientHeight);
            gradientRect.xMin -= 15f;

            var buttonRect = new Rect(gradientRect.xMax + 5, totalRect.y, buttonWidth, gradientHeight);
            var buttonIcon = EditorGUIUtility.IconContent("CustomTool@2x");

            currentGradient = EditorGUI.GradientField(gradientRect, GUIContent.none, currentGradient, hdr, ColorSpace.Linear);

            if (GUI.Button(buttonRect, buttonIcon))
            {
                var contextMenu = new GenericMenu();
                contextMenu.AddItem(new GUIContent("Reverse"), false, () =>
                {
                    var colorKeys = currentGradient.colorKeys;
                    for (var i = 0; i < colorKeys.Length / 2; i++)
                    {
                        (colorKeys[i].color, colorKeys[colorKeys.Length - 1 - i].color) = (
                            colorKeys[colorKeys.Length - 1 - i].color, colorKeys[i].color);
                    }

                    currentGradient = new Gradient
                    {
                        colorKeys = colorKeys,
                        alphaKeys = currentGradient.alphaKeys,
                        mode = currentGradient.mode
                    };
                    UpdateGradient(currentGradient, property);
                });
                contextMenu.ShowAsContext();
            }

            EditorGUILayout.EndVertical();

            return currentGradient;
        }
        private Gradient LoadCurrentGradient(MaterialProperty prop)
        {
            if (prop.targets.Length != 1) return null;

            var target = (Material)prop.targets[0];
            var path = AssetDatabase.GetAssetPath(target);
            var textureAsset = LoadSubAsset(path, textureName);
            var materialReset = target.GetTexture(prop.name) == null;

            if (textureAsset != null && IsValidTextureFormat(textureAsset, _hdr))
            {
                return Decode(prop, textureAsset.name);
            }

            return materialReset ? CreateDefaultGradient() : null;
        }

        private static bool IsValidTextureFormat(Texture2D textureAsset, bool hdr) =>
            (textureAsset.format == TextureFormat.RGBAHalf) == hdr;

        private static Texture2D LoadSubAsset(string path, string name) =>
            AssetDatabase.LoadAllAssetsAtPath(path).OfType<Texture2D>().FirstOrDefault(asset => asset.name.StartsWith(name));

        private void DrawLabel(GUIContent label)
        {
            var guiContent = new GUIContent(label.text, label.tooltip);
            EditorGUILayout.LabelField(guiContent, EditorStyles.label, GUILayout.Width(EditorGUIUtility.labelWidth));
        }

        private static Texture2D CreateEmptySubAssetTexture(string path, string name, FilterMode filterMode, int resolution, bool hdr)
        {
            var textureAsset = new Texture2D(resolution, 1, hdr ? TextureFormat.RGBAHalf : TextureFormat.ARGB32, false)
            {
                name = name,
                wrapMode = TextureWrapMode.Clamp,
                filterMode = filterMode
            };
            AssetDatabase.AddObjectToAsset(textureAsset, path);
            AssetDatabase.SaveAssets();
            AssetDatabase.ImportAsset(path);
            return textureAsset;
        }

        private static Gradient CreateDefaultGradient()
        {
            return new Gradient
            {
                colorKeys = new[] { new GradientColorKey(Color.white, 0f), new GradientColorKey(Color.white, 1f) },
                alphaKeys = new[] { new GradientAlphaKey(1, 0f), new GradientAlphaKey(1, 1f) }
            };
        }

        private void UpdateGradient(Gradient gradient, MaterialProperty prop)
        {
            var encodedGradient = Encode(gradient);
            var fullAssetName = textureName + encodedGradient;
            foreach (var target in prop.targets)
            {
                if (!AssetDatabase.Contains(target)) continue;

                var path = AssetDatabase.GetAssetPath(target);
                var filterMode = gradient.mode == GradientMode.Blend ? FilterMode.Bilinear : FilterMode.Point;
                var textureAsset = GetOrCreateGradientTexture(path, textureName, filterMode, _resolution, _hdr);
                Undo.RecordObject(textureAsset, "Change Material Gradient");
                textureAsset.name = fullAssetName;
                Bake(gradient, textureAsset);

                var material = (Material)target;
                material.SetTexture(prop.name, textureAsset);
                EditorUtility.SetDirty(material);
            }
        }

        private static Texture2D GetOrCreateGradientTexture(string path, string name, FilterMode filterMode, int resolution, bool hdr)
        {
            var textureAsset = LoadSubAsset(path, name);

            if (textureAsset != null && ((hdr && textureAsset.format != TextureFormat.RGBAHalf) ||
                                          (!hdr && textureAsset.format == TextureFormat.RGBAHalf)))
            {
                AssetDatabase.RemoveObjectFromAsset(textureAsset);
            }

            if (textureAsset == null)
            {
                textureAsset = CreateEmptySubAssetTexture(path, name, filterMode, resolution, hdr);
            }

            textureAsset.filterMode = filterMode;

            if (textureAsset.width != resolution)
            {
            #if UNITY_2021_2_OR_NEWER
                textureAsset.Reinitialize(resolution, 1);
            #else
                textureAsset.Resize(resolution, 1);
            #endif
            }

            return textureAsset;
        }

        public static void Bake(Gradient gradient, Texture2D texture)
        {
            if (gradient == null) return;

            for (var x = 0; x < texture.width; x++)
            {
                var color = gradient.Evaluate((float)x / (texture.width - 1));
                for (var y = 0; y < texture.height; y++) texture.SetPixel(x, y, color);
            }

            texture.Apply();
        }

        private static string Encode(Gradient gradient) => gradient == null ? null : JsonUtility.ToJson(new GradientData(gradient));

        private Gradient Decode(MaterialProperty prop, string name)
        {
            if (prop == null) return null;

            var json = name.Substring(textureName.Length);
            try
            {
                var gradientRepresentation = JsonUtility.FromJson<GradientData>(json);
                return gradientRepresentation?.ToGradient();
            }
            catch (Exception)
            {
                return null;
            }
        }

        [Serializable]
        internal class GradientData
        {
            public GradientMode mode;
            public ColorKey[] colorKeys;
            public AlphaKey[] alphaKeys;

            public GradientData() { }

            public GradientData(Gradient source)
            {
                FromGradient(source);
            }

            public void FromGradient(Gradient source)
            {
                mode = source.mode;
                colorKeys = source.colorKeys.Select(key => new ColorKey(key)).ToArray();
                alphaKeys = source.alphaKeys.Select(key => new AlphaKey(key)).ToArray();
            }

            public Gradient ToGradient()
            {
                var gradient = new Gradient();
                gradient.mode = mode;
                gradient.colorKeys = colorKeys.Select(key => key.ToGradientKey()).ToArray();
                gradient.alphaKeys = alphaKeys.Select(key => key.ToGradientKey()).ToArray();
                return gradient;
            }

            [Serializable]
            public struct ColorKey
            {
                public Color color;
                public float time;

                public ColorKey(GradientColorKey source)
                {
                    color = source.color;
                    time = source.time;
                }

                public GradientColorKey ToGradientKey() => new GradientColorKey(color, time);
            }

            [Serializable]
            public struct AlphaKey
            {
                public float alpha;
                public float time;

                public AlphaKey(GradientAlphaKey source)
                {
                    alpha = source.alpha;
                    time = source.time;
                }

                public GradientAlphaKey ToGradientKey() => new GradientAlphaKey(alpha, time);
            }
        }
    }
    #endregion [LS_DrawerGradient]

    #region [LS_DrawerSliderRemap]
    public class LS_DrawerSliderRemap : MaterialPropertyDrawer
    {
        public override void OnGUI(Rect position, MaterialProperty prop, String label, MaterialEditor editor)
        {
            EditorGUI.BeginChangeCheck();
            Vector4 value = prop.vectorValue;

            EditorGUI.showMixedValue = prop.hasMixedValue;

            var cacheLabel = EditorGUIUtility.labelWidth;
            var cacheField = EditorGUIUtility.fieldWidth;
            if (cacheField <= 64)
            {
                float total = position.width;
                EditorGUIUtility.labelWidth = Mathf.Ceil(0.45f * total) - 30;
                EditorGUIUtility.fieldWidth = Mathf.Ceil(0.55f * total) + 30;
            }

            EditorGUI.MinMaxSlider(position, label, ref value.x, ref value.y, 0, 1);

            EditorGUIUtility.labelWidth = cacheLabel;
            EditorGUIUtility.fieldWidth = cacheField;
            EditorGUI.showMixedValue = false;
            if (EditorGUI.EndChangeCheck())
            {
                prop.vectorValue = value;
            }
        }
    }
    #endregion [LS_DrawerSliderRemap]

    #region [LS_DrawerTextureScaleOffset]
    public class LS_DrawerTextureScaleOffset : MaterialPropertyDrawer
    {
        override public void OnGUI(Rect position, MaterialProperty prop, string label, MaterialEditor editor)
        {
            var cacheLabel = EditorGUIUtility.labelWidth;
            var cacheField = EditorGUIUtility.fieldWidth;

            Vector4 vec4value = prop.vectorValue;
            Vector2 tiling = new Vector2(vec4value.x, vec4value.y);
            Vector2 offset = new Vector2(vec4value.z, vec4value.w);

            var material = editor.target as Material;

            {
                GUILayout.Space(-4);
                EditorGUI.BeginChangeCheck();
                EditorGUILayout.BeginVertical();
                EditorGUILayout.BeginHorizontal();
                GUILayout.Label("Tiling", GUILayout.Width(cacheLabel));
                tiling = EditorGUILayout.Vector2Field("", tiling);
                EditorGUILayout.EndHorizontal();
                EditorGUILayout.BeginHorizontal();
                GUILayout.Label("Offset", GUILayout.Width(cacheLabel));
                offset = EditorGUILayout.Vector2Field("", offset);
                EditorGUILayout.EndHorizontal();
                EditorGUILayout.EndVertical();
                GUILayout.Space(4);
            }

            if (EditorGUI.EndChangeCheck())
            {
                prop.vectorValue = new Vector4(tiling.x, tiling.y, offset.x, offset.y);
            }
        }

        public override float GetPropertyHeight(MaterialProperty prop, string label, MaterialEditor editor)
        {
            return 0;
        }
    }
    #endregion [LS_DrawerTextureScaleOffset]

    #region [LS_DrawerTextureSingleLine]
    public class LS_DrawerTextureSingleLine : MaterialPropertyDrawer
    {
        public override void OnGUI(Rect position, MaterialProperty prop, String label, MaterialEditor editor)
        {
            EditorGUI.BeginChangeCheck();
            EditorGUI.showMixedValue = prop.hasMixedValue;

            Texture value = editor.TexturePropertyMiniThumbnail(position, prop, label, string.Empty);

            EditorGUI.showMixedValue = false;
            if (EditorGUI.EndChangeCheck())
            {
                prop.textureValue = value;
            }
        }
    }
    #endregion [LS_DrawerTextureSingleLine]

    #region [LS_DrawerToggleLeft]
    public class LS_DrawerToggleLeft : MaterialPropertyDrawer
    {

        public override void OnGUI(Rect position, MaterialProperty prop, string label, MaterialEditor editor)
        {
            position.width -= 24;
            bool value = prop.floatValue != 0.0f;
            EditorGUI.BeginChangeCheck();
            EditorGUI.showMixedValue = prop.hasMixedValue;
            if (EditorGUIUtility.isProSkin)
            {
                value = EditorGUI.ToggleLeft(position, label, value);
            }
            else
            {
                GUIStyle LeftToggle = new GUIStyle();
                LeftToggle.normal.textColor = Color.white;
                LeftToggle.contentOffset = new Vector2(2f, 0f);
                value = EditorGUI.ToggleLeft(position, label, value, LeftToggle);
            }
            EditorGUI.showMixedValue = false;

            if (EditorGUI.EndChangeCheck())
            {
                prop.floatValue = value ? 1.0f : 0.0f;
            }
        }
    }
    #endregion [LS_DrawerToggleLeft]

    #region [LS_DrawerToggleNoKeyword]
    public class LS_DrawerToggleNoKeyword : MaterialPropertyDrawer
    {

        public override void OnGUI(Rect position, MaterialProperty prop, String label, MaterialEditor editor)
        {
            bool value = (prop.floatValue != 0.0f);

            EditorGUI.BeginChangeCheck();
            {
                EditorGUI.showMixedValue = prop.hasMixedValue;
                value = EditorGUI.Toggle(position, label, value);
                EditorGUI.showMixedValue = false;
            }
            if (EditorGUI.EndChangeCheck())
            {
                prop.floatValue = value ? 1.0f : 0.0f;
            }
        }
    }
    #endregion [LS_DrawerToggleNoKeyword]

    #region [LS_DrawerVector2]
    public class LS_DrawerVector2 : MaterialPropertyDrawer
    {
        public override void OnGUI(Rect position, MaterialProperty prop, GUIContent label, MaterialEditor editor)
        {
            #if UNITY_6000_2_OR_NEWER
            if (prop.propertyType == UnityEngine.Rendering.ShaderPropertyType.Vector)
            #else
            if (prop.type == MaterialProperty.PropType.Vector)
            #endif
            {
                GUILayout.Space(-18);

                EditorGUI.BeginChangeCheck();
                EditorGUI.showMixedValue = prop.hasMixedValue;

                GUILayout.BeginHorizontal();
                GUILayout.Label(label, GUILayout.Width(EditorGUIUtility.labelWidth));
                Vector4 vec = EditorGUILayout.Vector2Field("", prop.vectorValue);
                GUILayout.EndHorizontal();

                GUILayout.Space(2);

                if (EditorGUI.EndChangeCheck())
                {
                    prop.vectorValue = vec;
                }
            }
            else
                editor.DefaultShaderProperty(prop, label.text);

        }
    }
    #endregion [LS_DrawerVector2]

    #region [LS_DrawerVector3]
    public class LS_DrawerVector3 : MaterialPropertyDrawer
    {
        public override void OnGUI(Rect position, MaterialProperty prop, GUIContent label, MaterialEditor editor)
        {
            #if UNITY_6000_2_OR_NEWER
            if (prop.propertyType == UnityEngine.Rendering.ShaderPropertyType.Vector)
            #else
            if (prop.type == MaterialProperty.PropType.Vector)
            #endif
            {
                GUILayout.Space(-18);

                EditorGUI.BeginChangeCheck();
                EditorGUI.showMixedValue = prop.hasMixedValue;

                GUILayout.BeginHorizontal();
                GUILayout.Label(label, GUILayout.Width(EditorGUIUtility.labelWidth));
                Vector4 vec = EditorGUILayout.Vector3Field("", prop.vectorValue);
                GUILayout.EndHorizontal();

                GUILayout.Space(2);

                if (EditorGUI.EndChangeCheck())
                {
                    prop.vectorValue = vec;
                }
            }
            else
                editor.DefaultShaderProperty(prop, label.text);

        }
    }
    #endregion [LS_DrawerVector3]

}