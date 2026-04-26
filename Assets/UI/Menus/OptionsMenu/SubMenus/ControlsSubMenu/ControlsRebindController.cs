using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.UIElements;

namespace UI.Menus.OptionsMenu
{
    public class ControlsRebindController : OptionsMenuSectionController
    {
        private readonly Dictionary<string, RebindEntry> _entryByRowId = new Dictionary<string, RebindEntry>();
        private readonly List<RowBinding> _rowBindings = new List<RowBinding>();
        private InputActionRebindingExtensions.RebindingOperation _activeRebind;

        private List<RebindEntry> _entries;
        private string _rebindSaveKey;
        private string _controlRowClass;
        private string _valueContainerClass;
        private string _listeningText;
        private string _unboundText;

        public bool IsRebinding => _activeRebind != null;

        protected override void OnHidden()
        {
            CancelActiveRebind();
        }

        private class RowBinding
        {
            public VisualElement ClickTarget;
            public EventCallback<ClickEvent> Callback;
            public Label ValueLabel;
            public RebindEntry Entry;
        }

        public void Initialize(
            VisualElement root,
            List<RebindEntry> entries,
            string rebindSaveKey,
            string controlRowClass,
            string valueContainerClass,
            string listeningText,
            string unboundText)
        {
            base.Initialize(root, root?.Q<VisualElement>(OptionsMenuUIIDs.ControlOptions));

            _entries = entries;
            _rebindSaveKey = rebindSaveKey;
            _controlRowClass = controlRowClass;
            _valueContainerClass = valueContainerClass;
            _listeningText = listeningText;
            _unboundText = unboundText;

            BuildEntryLookup();
            LoadOverrides();
        }

        public void RegisterRows()
        {
            UnregisterRows();

            var rows = Panel.Query<VisualElement>(className: _controlRowClass).ToList();
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

                var clickTarget = row.Q(className: _valueContainerClass) ?? row;
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

            RefreshAllRows();
        }

        public void UnregisterRows()
        {
            for (var i = 0; i < _rowBindings.Count; i++)
            {
                var rowBinding = _rowBindings[i];
                rowBinding.ClickTarget?.UnregisterCallback(rowBinding.Callback);
            }

            _rowBindings.Clear();
            CancelActiveRebind();
        }

        public void CancelActiveRebind()
        {
            if (_activeRebind == null)
            {
                return;
            }

            _activeRebind.Cancel();
            _activeRebind.Dispose();
            _activeRebind = null;
        }

        public void ResetAllBindingsToDefault()
        {
            var asset = ResolveInputAsset();
            if (asset == null)
            {
                Debug.LogWarning("ControlsRebindController: No InputActionAsset found from entries.");
                return;
            }

            asset.RemoveAllBindingOverrides();
            PlayerPrefs.DeleteKey(_rebindSaveKey);
            PlayerPrefs.Save();
            RefreshAllRows();
        }

        private InputActionAsset ResolveInputAsset()
        {
            for (var i = 0; i < _entries.Count; i++)
            {
                var action = _entries[i]?.actionReference?.action;
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

            for (var i = 0; i < _entries.Count; i++)
            {
                var entry = _entries[i];
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

            var saved = PlayerPrefs.GetString(_rebindSaveKey, string.Empty);
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

            PlayerPrefs.SetString(_rebindSaveKey, asset.SaveBindingOverridesAsJson());
            PlayerPrefs.Save();
        }

        private void StartRebind(RebindEntry entry, Label valueLabel)
        {
            if (!TryGetActionAndBindingIndex(entry, out var action, out var bindingIndex))
            {
                if (entry.actionReference == null || entry.actionReference.action == null)
                {
                    Debug.LogWarning("ControlsRebindController: Missing action reference for row: " + entry.rowId);
                }
                else
                {
                    Debug.LogWarning("ControlsRebindController: Could not find binding index for row: " + entry.rowId);
                }

                return;
            }

            CancelActiveRebind();

            valueLabel.text = _listeningText;
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

            if (!string.IsNullOrWhiteSpace(row.name) && _entryByRowId.TryGetValue(NormalizeKey(row.name), out entry))
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
            if (!TryGetActionAndBindingIndex(entry, out var action, out var index))
            {
                valueLabel.text = _unboundText;
                return;
            }

            var text = action.GetBindingDisplayString(index);
            valueLabel.text = string.IsNullOrEmpty(text) ? _unboundText : text;
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
