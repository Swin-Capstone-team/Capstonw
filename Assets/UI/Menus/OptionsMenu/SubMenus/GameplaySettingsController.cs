using System;
using UnityEngine.UIElements;
using UnityEngine;

namespace UI.Menus.OptionsMenu
{
    public class GameplaySettingsController : OptionsMenuSectionController
    {
        private Slider _cameraSensitivity;

        public override void Initialize(VisualElement root, VisualElement panel, Action anyChange)
        {
            base.Initialize(root, panel, anyChange);
            _cameraSensitivity = root.Q<Slider>(OptionsMenuUIIDs.CameraSensitivitySlider);

            Load();

        }

        public void RegisterButtons()
        {
            _cameraSensitivity.RegisterValueChangedCallback(OnCameraSensitivityChanged); 
            _cameraSensitivity.RegisterCallback<PointerCaptureOutEvent>(OnSliderReleased); 
        }

        public void UnregisterButtons()
        {
            _cameraSensitivity.UnregisterValueChangedCallback(OnCameraSensitivityChanged);  
            _cameraSensitivity.UnregisterCallback<PointerCaptureOutEvent>(OnSliderReleased);
        }

        private void OnCameraSensitivityChanged(ChangeEvent<float> evt)
        {
            GameSettingsManager.Instance.CameraSensitivity = evt.newValue;
            float rounded = Mathf.Round(evt.newValue);
            _cameraSensitivity.SetValueWithoutNotify(rounded);
            if(changed) return;
            changed = true;
            _anyChange?.Invoke();
        }

        private void OnSliderReleased(PointerCaptureOutEvent evt)
        {
            AudioManager.Instance.PlaySFX("menuOptions");
        }

        private void Load()
        {
            _cameraSensitivity.SetValueWithoutNotify(Mathf.Round(PlayerPrefs.GetFloat("CameraSensitivity", _cameraSensitivity.highValue)));
            GameSettingsManager.Instance.CameraSensitivity = _cameraSensitivity.value;
            GameSettingsManager.Instance.Apply();
        }

        public void Confirm()
        {
            if(!_isVisible) return;

            PlayerPrefs.SetFloat("CameraSensitivity", _cameraSensitivity.value);
            GameSettingsManager.Instance.Apply();
            changed = false;
        }
    }
}
