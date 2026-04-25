using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UIElements;
using UnityEngine.SceneManagement;

namespace UI.Menus.MainMenu
{
    public class MainMenuEvents : MonoBehaviour
    {
        private UIDocument _document;
        private List<Button> _mainMenuButtons = new List<Button>();
        private AudioSource _audioSource;
    
        private void Awake()
        {
            _audioSource = GetComponent<AudioSource>();
            _document = GetComponent<UIDocument>();
            _mainMenuButtons = _document.rootVisualElement.Query<Button>().ToList();
        
            foreach (var button in _mainMenuButtons)
            {
                button.RegisterCallback<ClickEvent>(OnButtonClick);
            }
        }

        private void OnDisable()
        {
            foreach (var button in _mainMenuButtons)
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
            SceneManager.LoadSceneAsync("Main");
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
