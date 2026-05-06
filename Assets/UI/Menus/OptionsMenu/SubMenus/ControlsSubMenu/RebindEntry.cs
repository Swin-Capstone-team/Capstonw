using System;
using UnityEngine;
using UnityEngine.InputSystem;

namespace UI.Menus.OptionsMenu
{
    [Serializable]
    public class RebindEntry
    {
        [Tooltip("VisualElement name/id")]
        public string rowId;

        [Tooltip("Input action reference")]
        public InputActionReference actionReference;

        [Tooltip("Composite part name for 2D bindings (up/down/left/right). Leave empty for normal actions.")]
        public string compositePartName;

        [Tooltip("Optional binding group filter")]
        public string bindingGroup;
    }
}
