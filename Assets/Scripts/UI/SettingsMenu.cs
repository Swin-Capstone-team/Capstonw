using UnityEngine;
using UnityEngine.UI;
using TMPro;
using System.Collections.Generic;

public class SettingsMenu : MonoBehaviour
{
    public Slider masterSlider;
    public Slider musicSlider;
    public Slider sfxSlider;
    public Toggle fullscreenToggle;
    public TMP_Dropdown graphicsDropdown; 

    public void Load()
    {
        LoadSettings();

        masterSlider.onValueChanged.AddListener(SetMasterVolume);
        musicSlider.onValueChanged.AddListener(SetMusicVolume);
        sfxSlider.onValueChanged.AddListener(SetSFXVolume);
        fullscreenToggle.onValueChanged.AddListener(SetFullscreen);
        graphicsDropdown.onValueChanged.AddListener(SetGraphics);
        PopulateGraphicsDropdown();
    }

    public void SetMasterVolume(float volume)
    {
        AudioManager.Instance.masterVolume = volume;
        AudioManager.Instance.UpdateMusicVolume();
    }

    public void SetMusicVolume(float volume)
    {
        AudioManager.Instance.musicVolume = volume;
        AudioManager.Instance.UpdateMusicVolume();
    }

    public void SetSFXVolume(float volume)
    {
        AudioManager.Instance.sfxVolume = volume;
    }


    public void SetFullscreen(bool fullscreen)
    {
        Screen.fullScreen = fullscreen;
    }

    public void SetGraphics(int qualityIndex)
    {
        if(qualityIndex < QualitySettings.count)
        {
            QualitySettings.SetQualityLevel(qualityIndex);
        }
        
    }

    private void PopulateGraphicsDropdown()
    {
        graphicsDropdown.ClearOptions();
        List<string> qualityLevels = new List<string>(QualitySettings.names);
        graphicsDropdown.AddOptions(qualityLevels);
        graphicsDropdown.RefreshShownValue();
    }

    public void SaveSettings()
    {
        PlayerPrefs.SetFloat("MasterVolume", masterSlider.value);
        PlayerPrefs.SetFloat("MusicVolume", musicSlider.value);
        PlayerPrefs.SetFloat("SFXVolume", sfxSlider.value);
        PlayerPrefs.SetInt("Fullscreen", fullscreenToggle.isOn ? 1 : 0);
        PlayerPrefs.SetInt("Quality", graphicsDropdown.value);

        PlayerPrefs.Save();
    }

    void LoadSettings()
    {
        masterSlider.value = PlayerPrefs.GetFloat("MasterVolume", 1f);
        musicSlider.value = PlayerPrefs.GetFloat("MusicVolume", 1f);
        sfxSlider.value = PlayerPrefs.GetFloat("SFXVolume", 1f);
        fullscreenToggle.isOn = PlayerPrefs.GetInt("Fullscreen", 1) == 1;
        graphicsDropdown.value = PlayerPrefs.GetInt("Quality", QualitySettings.GetQualityLevel());
        SetMasterVolume(masterSlider.value);
        SetMusicVolume(musicSlider.value);
        SetSFXVolume(sfxSlider.value);
        SetFullscreen(fullscreenToggle.isOn);
        SetGraphics(graphicsDropdown.value);
    }
}   