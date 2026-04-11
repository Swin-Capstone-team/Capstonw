using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UIElements;

namespace UI.Menus.OptionsMenu
{
    public class OptionsMenuEvents : MonoBehaviour
    {
        private UIDocument _document;
        private List<Button> _optionsMenuButtons = new List<Button>();
        private AudioSource _audioSource;
    
        private void Awake()
        {
            _audioSource = GetComponent<AudioSource>();
            _document = GetComponent<UIDocument>();
            _optionsMenuButtons = _document.rootVisualElement.Query<Button>().ToList();
        
            foreach (var button in _optionsMenuButtons)
            {
                button.RegisterCallback<ClickEvent>(OnButtonClick);
            }
        }

        private void OnDisable()
        {
            foreach (var button in _optionsMenuButtons)
            {
                button.UnregisterCallback<ClickEvent>(OnButtonClick);
            }
        }
    
        private void QuitGame()
        {
            Debug.Log("Quitting game");
            Application.Quit();
        }

        private void ContinueGame()
        {
        
        }

        private void NewGame()
        {
        
        }

        private void LoadGame()
        {
        
        }

        private void OnButtonClick(ClickEvent evt)
        {
            var button = evt.target as Button;
        
            Debug.Log($"{button.name} clicked");
            switch (button.name) 
            {
                case  "ContinueButton":
                    ContinueGame();
                    break;
                case  "NewGameButton":
                    NewGame();
                    break;
                case  "LoadGameButton":
                    LoadGame();
                    break;
                case "QuitButton":
                    QuitGame();
                    break;
            
            }
            // _audioSource.Play();
        }
    }

}
