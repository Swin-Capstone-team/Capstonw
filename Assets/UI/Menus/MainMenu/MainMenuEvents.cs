using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UIElements;
using UnityEngine.SceneManagement;
using UI.Menus.OptionsMenu;

namespace UI.Menus.MainMenu
{
    public class MainMenuEvents : MonoBehaviour, IMenu
    {
        private UIDocument _document;
        private readonly List<Button> _mainMenuButtons = new List<Button>();
        public OptionsMenuEvents _optionsMenu;
    
        private void Awake()
        {
            _document = GetComponent<UIDocument>();
            if (_document == null || _document.rootVisualElement == null)
            {
                enabled = false;
                return;
            }

            _mainMenuButtons.Clear();
            _mainMenuButtons.AddRange(_document.rootVisualElement.Query<Button>().ToList());
        
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
            SceneManager.LoadSceneAsync("Main");
        }

        private void LoadGame()
        {
        
        }

        private void OnButtonClick(ClickEvent evt)
        {
            var button = evt.currentTarget as Button;
            if (button == null)
            {
                return;
            }
            AudioManager.Instance.PlaySFX("menuSelect");
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
                case "OptionsButton":
                    _optionsMenu.Show(this);
                    break;
                case "QuitButton":
                    QuitGame();
                    break;
            
            }
        }



        public void Show()
        {
            _document.rootVisualElement.style.display = DisplayStyle.Flex;
        }

        public void Hide()
        {
            _document.rootVisualElement.style.display = DisplayStyle.None;
        }
    }

}
