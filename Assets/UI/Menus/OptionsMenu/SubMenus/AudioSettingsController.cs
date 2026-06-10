using UnityEngine.UIElements;
using UnityEngine;
using System;
namespace UI.Menus.OptionsMenu
{
    public class AudioSettingsController : OptionsMenuSectionController
    {
        private Slider _masterSlider;
        private Slider _musicSlider;
        private Slider _sfxSlider;


        public override void Initialize(VisualElement root, VisualElement panel, Action anyChange)
        {
            base.Initialize(root, panel, anyChange);
            _masterSlider = root.Q<Slider>(OptionsMenuUIIDs.MasterSlider);
            _musicSlider = root.Q<Slider>(OptionsMenuUIIDs.MusicSlider);
            _sfxSlider = root.Q<Slider>(OptionsMenuUIIDs.SFXSlider);

            Load();
        }

        public void RegisterButtons()
        {
            _masterSlider.RegisterValueChangedCallback(OnMasterVolumeChanged);  
            _musicSlider.RegisterValueChangedCallback(OnMusicVolumeChanged);
            _sfxSlider.RegisterValueChangedCallback(OnSFXVolumeChanged);
        }

        public void UnregisterButtons()
        {
            _masterSlider.UnregisterValueChangedCallback(OnMasterVolumeChanged);
            _musicSlider.UnregisterValueChangedCallback(OnMusicVolumeChanged);
            _sfxSlider.UnregisterValueChangedCallback(OnSFXVolumeChanged);
        }

        private void OnMasterVolumeChanged(ChangeEvent<float> evt)
        {
            AudioManager.Instance.masterVolume = evt.newValue/100;
            AudioManager.Instance.UpdateMusicVolume();
            float rounded = Mathf.Round(evt.newValue);
            _masterSlider.SetValueWithoutNotify(rounded);
            if(changed) return;
            changed = true;
            _anyChange?.Invoke();
        }

        private void OnMusicVolumeChanged(ChangeEvent<float> evt)
        {
            AudioManager.Instance.musicVolume = evt.newValue/100;
            AudioManager.Instance.UpdateMusicVolume();
            float rounded = Mathf.Round(evt.newValue);
            _musicSlider.SetValueWithoutNotify(rounded);
            if(changed) return;
            changed = true;
            _anyChange?.Invoke();
        }

        private void OnSFXVolumeChanged(ChangeEvent<float> evt)
        {
            AudioManager.Instance.sfxVolume = evt.newValue/100;
            float rounded = Mathf.Round(evt.newValue);
            _sfxSlider.SetValueWithoutNotify(rounded);
            if(changed) return;
            changed = true;
            _anyChange?.Invoke();
        }

        private void Load()
        {
            _masterSlider.SetValueWithoutNotify(Mathf.Round(PlayerPrefs.GetFloat("MasterVolume", 1f)));
            _musicSlider.SetValueWithoutNotify(Mathf.Round(PlayerPrefs.GetFloat("MusicVolume", 1f)));
            _sfxSlider.SetValueWithoutNotify(Mathf.Round(PlayerPrefs.GetFloat("SFXVolume", 1f)));
            
            AudioManager.Instance.masterVolume = _masterSlider.value/100;
            AudioManager.Instance.musicVolume = _musicSlider.value/100;
            AudioManager.Instance.sfxVolume = _sfxSlider.value/100;
        }

        public void Confirm()
        {
            if(!_isVisible) return;

            PlayerPrefs.SetFloat("MasterVolume", _masterSlider.value);
            PlayerPrefs.SetFloat("MusicVolume", _musicSlider.value);
            PlayerPrefs.SetFloat("SFXVolume", _sfxSlider.value);

            changed = false;
        }
    }
}
