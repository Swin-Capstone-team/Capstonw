using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.UIElements;

namespace UI.Menus.OptionsMenu
{
    public class OptionsMenuEvents : MonoBehaviour
    {
        private UIDocument _document;
        private List<Button> _optionsMenuButtons = new List<Button>();

        [Serializable]
        public class RebindEntry
        {
            [Tooltip("VisualElement name/id of the control row (for example: MOVE_FORWARD). Preferred over uiLabel.")]
            public string rowId;

            [Tooltip("Input action reference (drag from your Input Action asset)")]
            public InputActionReference actionReference;

            [Tooltip("Composite part name for 2D bindings (up/down/left/right). Leave empty for normal actions.")]
            public string compositePartName;

            [Tooltip("Optional binding group filter (for example: Keyboard&Mouse or Gamepad). Leave empty to use first matching binding.")]
            public string bindingGroup;
        }

        [Header("Input")]
        [SerializeField] private string rebindSaveKey = "input-rebinds";

        [Header("UI Query")]
        [SerializeField] private string controlRowClass = "controlOptionGroup";
        [SerializeField] private string valueContainerClass = "controlOptionSettingsContainer";

        [Header("Display")]
        [SerializeField] private string listeningText = "Press any key...";
        [SerializeField] private string unboundText = "Unbound";

        [Header("Mapping")]
        [SerializeField] private List<RebindEntry> entries = new List<RebindEntry>();

        private VisualElement _root;
        private readonly Dictionary<string, RebindEntry> _entryByRowId = new Dictionary<string, RebindEntry>();
        private readonly List<RowBinding> _rowBindings = new List<RowBinding>();
        private InputActionRebindingExtensions.RebindingOperation _activeRebind;

        private class RowBinding
        {
            public VisualElement ClickTarget;
            public EventCallback<ClickEvent> Callback;
            public Label ValueLabel;
            public RebindEntry Entry;
        }
    
        private void Awake()
        {
            _document = GetComponent<UIDocument>();
            InitializeMenuUi();
        }

        private void OnEnable()
        {
            if (_document == null)
            {
                _document = GetComponent<UIDocument>();
            }

            InitializeMenuUi();
        }

        private void OnDisable()
        {
            foreach (var button in _optionsMenuButtons)
            {
                button.UnregisterCallback<ClickEvent>(OnButtonClick);
            }

            UnbindRows();
            CancelActiveRebind();
        }

        private void InitializeMenuUi()
        {
            _root = _document != null ? _document.rootVisualElement : null;
            if (_root == null)
            {
                return;
            }

            _optionsMenuButtons = _root.Query<Button>().ToList();
            foreach (var t in _optionsMenuButtons)
            {
                t.RegisterCallback<ClickEvent>(OnButtonClick);
            }

            BuildEntryLookup();
            LoadOverrides();
            BindRows();
            RefreshAllRows();
        }
        
        private void OnButtonClick(ClickEvent evt)
        {
            var button = evt.target as Button;

            if (button == null)
            {
                return;
            }
        
            Debug.Log($"{button.name} clicked");
            switch (button.name) 
            {
                case  "ContinueButton":

                    break;
                case  "NewGameButton":

                    break;
                case  "LoadGameButton":

                    break;
                case "QuitButton":

                    break;
            
            }
            // _audioSource.Play();
        }

        public void ResetAllBindingsToDefault()
        {
            var asset = ResolveInputAsset();
            if (asset == null)
            {
                Debug.LogWarning("OptionsMenuEvents: No InputActionAsset found from entries.");
                return;
            }

            asset.RemoveAllBindingOverrides();
            PlayerPrefs.DeleteKey(rebindSaveKey);
            PlayerPrefs.Save();
            RefreshAllRows();
        }

        private InputActionAsset ResolveInputAsset()
        {
            for (var i = 0; i < entries.Count; i++)
            {
                var action = entries[i]?.actionReference?.action;
                var asset = action?.actionMap?.asset;
                if (asset != null)
                {
                    return asset;
                }
            }

            return null;
        }

        private void BuildEntryLookup()
        {
            _entryByRowId.Clear();

            for (var i = 0; i < entries.Count; i++)
            {
                var entry = entries[i];
                if (entry == null)
                {
                    continue;
                }

                if (!string.IsNullOrWhiteSpace(entry.rowId))
                {
                    _entryByRowId[NormalizeKey(entry.rowId)] = entry;
                }
            }
        }

        private void LoadOverrides()
        {
            var asset = ResolveInputAsset();
            if (asset == null)
            {
                return;
            }

            var saved = PlayerPrefs.GetString(rebindSaveKey, string.Empty);
            if (!string.IsNullOrEmpty(saved))
            {
                asset.LoadBindingOverridesFromJson(saved);
            }
        }

        private void SaveOverrides()
        {
            var asset = ResolveInputAsset();
            if (asset == null)
            {
                return;
            }

            PlayerPrefs.SetString(rebindSaveKey, asset.SaveBindingOverridesAsJson());
            PlayerPrefs.Save();
        }

        private void BindRows()
        {
            if (_root == null)
            {
                return;
            }

            UnbindRows();

            var rows = _root.Query<VisualElement>(className: controlRowClass).ToList();
            foreach (var row in rows)
            {
                var labels = row.Query<Label>().ToList();
                if (labels.Count < 2)
                {
                    continue;
                }

                var valueLabel = labels[1];

                if (!TryGetEntryForRow(row, out var entry))
                {
                    continue;
                }

                var clickTarget = row.Q(className: valueContainerClass) ?? row;
                EventCallback<ClickEvent> callback = _ => { StartRebind(entry, valueLabel); };

                clickTarget.RegisterCallback(callback);
                _rowBindings.Add(new RowBinding
                {
                    ClickTarget = clickTarget,
                    Callback = callback,
                    ValueLabel = valueLabel,
                    Entry = entry
                });
            }
        }

        private void UnbindRows()
        {
            for (var i = 0; i < _rowBindings.Count; i++)
            {
                var rowBinding = _rowBindings[i];
                if (rowBinding.ClickTarget == null || rowBinding.Callback == null)
                {
                    continue;
                }

                rowBinding.ClickTarget.UnregisterCallback(rowBinding.Callback);
            }

            _rowBindings.Clear();
        }

        private void StartRebind(RebindEntry entry, Label valueLabel)
        {
            if (entry == null || valueLabel == null)
            {
                return;
            }

            if (!TryGetActionAndBindingIndex(entry, out var action, out var bindingIndex))
            {
                if (entry.actionReference == null || entry.actionReference.action == null)
                {
                    Debug.LogWarning("OptionsMenuEvents: Missing action reference for row: " + entry.rowId);
                }
                else
                {
                    Debug.LogWarning("OptionsMenuEvents: Could not find binding index for row: " + entry.rowId);
                }
                return;
            }

            CancelActiveRebind();

            valueLabel.text = listeningText;
            action.Disable();

            _activeRebind = action.PerformInteractiveRebinding(bindingIndex)
                .WithCancelingThrough("<Keyboard>/escape")
                .OnCancel(op =>
                {
                    op.Dispose();
                    _activeRebind = null;
                    action.Enable();
                    RefreshBindingLabel(valueLabel, entry);
                })
                .OnComplete(op =>
                {
                    op.Dispose();
                    _activeRebind = null;
                    action.Enable();
                    SaveOverrides();
                    RefreshBindingLabel(valueLabel, entry);
                });

            _activeRebind.Start();
        }

        private void CancelActiveRebind()
        {
            if (_activeRebind == null)
            {
                return;
            }

            _activeRebind.Cancel();
            _activeRebind.Dispose();
            _activeRebind = null;
        }

        private int FindBindingIndex(InputAction action, RebindEntry entry)
        {
            for (var i = 0; i < action.bindings.Count; i++)
            {
                var binding = action.bindings[i];

                if (!string.IsNullOrEmpty(entry.compositePartName))
                {
                    if (!binding.isPartOfComposite)
                    {
                        continue;
                    }

                    if (!string.Equals(binding.name, entry.compositePartName, StringComparison.OrdinalIgnoreCase))
                    {
                        continue;
                    }
                }
                else if (binding.isComposite || binding.isPartOfComposite)
                {
                    continue;
                }

                if (!string.IsNullOrEmpty(entry.bindingGroup))
                {
                    var groups = binding.groups ?? string.Empty;
                    if (!groups.Contains(entry.bindingGroup, StringComparison.OrdinalIgnoreCase))
                    {
                        continue;
                    }
                }

                return i;
            }

            return -1;
        }

        private bool TryGetEntryForRow(VisualElement row, out RebindEntry entry)
        {
            entry = null;

            if (row != null && !string.IsNullOrWhiteSpace(row.name) &&
                _entryByRowId.TryGetValue(NormalizeKey(row.name), out entry))
            {
                return true;
            }

            return false;
        }

        private void RefreshAllRows()
        {
            foreach (var rowBinding in _rowBindings)
            {
                RefreshBindingLabel(rowBinding.ValueLabel, rowBinding.Entry);
            }
        }

        private void RefreshBindingLabel(Label valueLabel, RebindEntry entry)
        {
            if (valueLabel == null || entry == null)
            {
                return;
            }

            if (!TryGetActionAndBindingIndex(entry, out var action, out var index))
            {
                valueLabel.text = unboundText;
                return;
            }

            var text = action.GetBindingDisplayString(index);
            valueLabel.text = string.IsNullOrEmpty(text) ? unboundText : text;
        }

        private bool TryGetActionAndBindingIndex(RebindEntry entry, out InputAction action, out int index)
        {
            action = entry?.actionReference?.action;
            if (action == null)
            {
                index = -1;
                return false;
            }

            index = FindBindingIndex(action, entry);
            return index >= 0;
        }

        private static string NormalizeKey(string value)
        {
            return (value ?? string.Empty).Trim().ToUpperInvariant();
        }
    }

}
