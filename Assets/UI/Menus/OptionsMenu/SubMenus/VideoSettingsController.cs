using UnityEngine.UIElements;
using UnityEngine;
using System;
using System.Collections.Generic;

namespace UI.Menus.OptionsMenu
{
    public class VideoSettingsController : OptionsMenuSectionController
    {
        private Label _displayLabel;
        private Button _displayLeftButton;
        private Button _displayRightButton;

        private DropdownField _resolutionDropDown;

        private Label _refeshRateLabel;
        private Button _refreshRateLeftButton;
        private Button _refreshRateRightButton;
        private Slider _brightnessSlider;
        private Slider _fovSlider;



        private int displayIndex;
        private Resolution[] resolutions;
        private int resolutionIndex;

        private List<RefreshRate> refreshRates;
        private int refreshRateIndex;



        public override void Initialize(VisualElement root, VisualElement panel, Action anyChange)
        {
            base.Initialize(root, panel, anyChange);
            _displayLabel = root.Q<Label>(OptionsMenuUIIDs.DisplayLabel);
            _displayLeftButton = root.Q<Button>(OptionsMenuUIIDs.DisplayLeftButton);
            _displayRightButton = root.Q<Button>(OptionsMenuUIIDs.DisplayRightButton);

            _resolutionDropDown = root.Q<DropdownField>(OptionsMenuUIIDs.ResolutionDropDown);

            _refeshRateLabel = root.Q<Label>(OptionsMenuUIIDs.RefreshRateLabel);
            _refreshRateLeftButton = root.Q<Button>(OptionsMenuUIIDs.RefreshRateLeftButton);
            _refreshRateRightButton = root.Q<Button>(OptionsMenuUIIDs.RefreshRateRightButton);
            
            _brightnessSlider = root.Q<Slider>(OptionsMenuUIIDs.BrightnessSlider);

            _fovSlider = root.Q<Slider>(OptionsMenuUIIDs.FOVSlider);
            

            Load();
        }

        public void RegisterButtons()
        {
            _displayLeftButton.clicked += PreviousDisplay;
            _displayRightButton.clicked += NextDisplay;
            _resolutionDropDown.RegisterValueChangedCallback(OnResolutionChanged);
            _refreshRateLeftButton.clicked += PreviousRefreshRate;
            _refreshRateRightButton.clicked += NextRefreshRate;
            _brightnessSlider.RegisterValueChangedCallback(OnBrightnessChanged); 
            _brightnessSlider.RegisterCallback<PointerCaptureOutEvent>(OnSliderReleased);
            _fovSlider.RegisterValueChangedCallback(OnFOVChanged); 
            _fovSlider.RegisterCallback<PointerCaptureOutEvent>(OnSliderReleased);
        }

        public void UnregisterButtons()
        {
            _displayLeftButton.clicked -= PreviousDisplay;
            _displayRightButton.clicked -= NextDisplay;
            _resolutionDropDown.UnregisterValueChangedCallback(OnResolutionChanged);
            _refreshRateLeftButton.clicked -= PreviousRefreshRate;
            _refreshRateRightButton.clicked -= NextRefreshRate;
            _brightnessSlider.UnregisterValueChangedCallback(OnBrightnessChanged); 
            _brightnessSlider.UnregisterCallback<PointerCaptureOutEvent>(OnSliderReleased); 
            _fovSlider.UnregisterValueChangedCallback(OnFOVChanged); 
            _fovSlider.UnregisterCallback<PointerCaptureOutEvent>(OnSliderReleased);
        }

        public void NextDisplay()
        {
           UpdateDisplayMode(1);
        }
        public void PreviousDisplay()
        {
            UpdateDisplayMode(-1);
        }

        private void UpdateDisplayMode(int change)
        {
            AudioManager.Instance.PlaySFX("menuOptions");
            int length = Enum.GetValues(typeof(FullScreenMode)).Length;
            displayIndex = (displayIndex + change) % length;
            if (displayIndex < 0)
            {
                displayIndex = length - 1;
            }
            _displayLabel.text = GetDisplayName((FullScreenMode)displayIndex);

            if(changed) return;
            changed = true;
            _anyChange?.Invoke();
        }

        private string GetDisplayName(FullScreenMode mode)
        {
            return mode switch
            {
                FullScreenMode.Windowed => "WINDOWED",
                FullScreenMode.FullScreenWindow => "BORDERLESS FULLSCREEN",
                FullScreenMode.ExclusiveFullScreen => "FULLSCREEN",
                FullScreenMode.MaximizedWindow => "MAXIMIZED",
                _ => mode.ToString()
            };
        }

        private void OnResolutionChanged(ChangeEvent<string> evt)
        {
            AudioManager.Instance.PlaySFX("menuOptions");
            resolutionIndex = _resolutionDropDown.choices.IndexOf(evt.newValue);
            if(changed) return;
            changed = true;
            _anyChange?.Invoke();
        }

        public void NextRefreshRate()
        {
           UpdateRefreshRate(1);
        }
        public void PreviousRefreshRate()
        {
            UpdateRefreshRate(-1);
        }

        private void UpdateRefreshRate(int change)
        {
            AudioManager.Instance.PlaySFX("menuOptions");
            refreshRateIndex = (refreshRateIndex + change) % refreshRates.Count;
            if (refreshRateIndex < 0)
            {
                refreshRateIndex = refreshRates.Count - 1;
            }
            _refeshRateLabel.text = refreshRates[refreshRateIndex].ToString() + "Hz";
            if(changed) return;
            changed = true;
            _anyChange?.Invoke();
        }

        private void OnBrightnessChanged(ChangeEvent<float> evt)
        {
            
            //idk man
            Debug.Log(evt.newValue);
            float rounded = Mathf.Round(evt.newValue);
            _brightnessSlider.SetValueWithoutNotify(rounded);
            if(changed) return;
            changed = true;
            _anyChange?.Invoke();
        }

        private void OnFOVChanged(ChangeEvent<float> evt)
        {
            GameSettingsManager.Instance.FieldOfView = evt.newValue;
            float rounded = Mathf.Round(evt.newValue * 10f) / 10f;
            _fovSlider.SetValueWithoutNotify(rounded);
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
            // Unity gets fullscreen, resolution and refresh rate from player prefs before the first frame
            resolutions = Screen.resolutions;
            List<string> choices = new();
            HashSet<RefreshRate> rates = new();

            foreach (var resolution in resolutions)
            {
                choices.Add($"{resolution.width} x {resolution.height}");
                rates.Add(resolution.refreshRateRatio);
            }

            refreshRates = new List<RefreshRate>(rates);
            refreshRates.Add(new RefreshRate() { numerator = 90, denominator = 1 }); // Make sure its working
            _resolutionDropDown.choices = choices;

            displayIndex = (int)Screen.fullScreenMode;
            _displayLabel.text = GetDisplayName((FullScreenMode)displayIndex); 
            
            Resolution currentResolution = Screen.currentResolution;
            _resolutionDropDown.SetValueWithoutNotify($"{currentResolution.width} x {currentResolution.height}");
            resolutionIndex = Array.IndexOf(resolutions, currentResolution);
            
            refreshRateIndex = refreshRates.IndexOf(Screen.currentResolution.refreshRateRatio);
            _refeshRateLabel.text = refreshRates[refreshRateIndex].ToString() + "Hz";

            _brightnessSlider.SetValueWithoutNotify(Mathf.Round(PlayerPrefs.GetFloat("Brightness", 1f)));
            _fovSlider.SetValueWithoutNotify(Mathf.Round(PlayerPrefs.GetFloat("FOV", 1f)*10)/10);
            GameSettingsManager.Instance.FieldOfView = _fovSlider.value;
            GameSettingsManager.Instance.Apply();
        }

        public void Confirm()
        {
            if(!_isVisible) return;

            // Sets fullscreen, resolution and refresh rate which saves it to playerprefs
            Resolution resolution = resolutions[resolutionIndex];
            Screen.SetResolution(resolution.width, resolution.height, (FullScreenMode)displayIndex, refreshRates[refreshRateIndex]);

            PlayerPrefs.SetFloat("Brightness", _brightnessSlider.value);
            PlayerPrefs.SetFloat("FOV", _fovSlider.value);
            GameSettingsManager.Instance.Apply();

            changed = false;
        }
    }
}
