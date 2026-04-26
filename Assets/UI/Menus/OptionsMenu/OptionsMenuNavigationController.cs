using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UIElements;

namespace UI.Menus.OptionsMenu
{
    public class OptionsMenuNavigationController
    {
        private VisualElement _optionsMainMenu;
        private VisualElement _gameOptionsMenu;
        private VisualElement _videoOptionsMenu;
        private VisualElement _soundOptionsMenu;
        private VisualElement _controlOptionsMenu;

        private Button _gameOptionsButton;
        private Button _videoButton;
        private Button _soundButton;
        private Button _controlsButton;
        private Button _exitMenuButton;

        private Button _confirmFooterButton;
        private Button _backFooterButton;
        private Button _defaultSettingsFooterButton;

        private readonly List<VisualElement> _menuPanels = new List<VisualElement>();
        private readonly List<Button> _footerButtons = new List<Button>();
        private readonly Stack<VisualElement> _panelHistory = new Stack<VisualElement>();

        private Action _exitRequested;
        private Action _confirmRequested;
        private Action _defaultSettingsRequested;

        private bool _buttonsRegistered;
        private VisualElement _activePanel;

        public event Action<VisualElement> ActivePanelChanged;

        public void Initialize(VisualElement root, Action exitRequested, Action confirmRequested, Action defaultSettingsRequested)
        {
            _exitRequested = exitRequested;
            _confirmRequested = confirmRequested;
            _defaultSettingsRequested = defaultSettingsRequested;

            _optionsMainMenu = root.Q<VisualElement>(OptionsMenuUIIDs.OptionsMainMenu);
            _gameOptionsMenu = root.Q<VisualElement>(OptionsMenuUIIDs.GameOptions);
            _videoOptionsMenu = root.Q<VisualElement>(OptionsMenuUIIDs.VideoOptions);
            _soundOptionsMenu = root.Q<VisualElement>(OptionsMenuUIIDs.SoundOptions);
            _controlOptionsMenu = root.Q<VisualElement>(OptionsMenuUIIDs.ControlOptions);

            _gameOptionsButton = root.Q<Button>(OptionsMenuUIIDs.GameOptionsButton);
            _videoButton = root.Q<Button>(OptionsMenuUIIDs.VideoButton);
            _soundButton = root.Q<Button>(OptionsMenuUIIDs.SoundButton);
            _controlsButton = root.Q<Button>(OptionsMenuUIIDs.ControlsButton);
            _exitMenuButton = root.Q<Button>(OptionsMenuUIIDs.ExitMenuButton);

            _confirmFooterButton = root.Q<Button>(OptionsMenuUIIDs.ConfirmFooterButton);
            _backFooterButton = root.Q<Button>(OptionsMenuUIIDs.BackFooterButton);
            _defaultSettingsFooterButton = root.Q<Button>(OptionsMenuUIIDs.DefaultSettingsFooterButton);

            _menuPanels.Clear();
            _menuPanels.Add(_optionsMainMenu);
            _menuPanels.Add(_gameOptionsMenu);
            _menuPanels.Add(_videoOptionsMenu);
            _menuPanels.Add(_soundOptionsMenu);
            _menuPanels.Add(_controlOptionsMenu);

            _footerButtons.Clear();
            _footerButtons.Add(_confirmFooterButton);
            _footerButtons.Add(_backFooterButton);
            _footerButtons.Add(_defaultSettingsFooterButton);

            ShowMainMenu();
        }

        public void RegisterButtons()
        {
            if (_buttonsRegistered)
            {
                return;
            }

            _gameOptionsButton.clicked += ShowGameOptions;
            _videoButton.clicked += ShowVideoOptions;
            _soundButton.clicked += ShowSoundOptions;
            _controlsButton.clicked += ShowControlsOptions;
            _exitMenuButton.clicked += HandleExitRequested;

            _confirmFooterButton.clicked += HandleConfirmRequested;
            _backFooterButton.clicked += HandleBackRequested;
            _defaultSettingsFooterButton.clicked += HandleDefaultSettingsRequested;

            _buttonsRegistered = true;
        }

        public void UnregisterButtons()
        {
            if (!_buttonsRegistered)
            {
                return;
            }

            _gameOptionsButton.clicked -= ShowGameOptions;
            _videoButton.clicked -= ShowVideoOptions;
            _soundButton.clicked -= ShowSoundOptions;
            _controlsButton.clicked -= ShowControlsOptions;
            _exitMenuButton.clicked -= HandleExitRequested;

            _confirmFooterButton.clicked -= HandleConfirmRequested;
            _backFooterButton.clicked -= HandleBackRequested;
            _defaultSettingsFooterButton.clicked -= HandleDefaultSettingsRequested;

            _buttonsRegistered = false;
        }

        public void HandleBackAction()
        {
            if (_activePanel == _optionsMainMenu)
            {
                HandleExitRequested();
                return;
            }

            if (_panelHistory.Count > 0)
            {
                SetActivePanel(_panelHistory.Pop());
                return;
            }

            ShowMainMenu();
        }

        private void ShowMainMenu()
        {
            _panelHistory.Clear();
            SetActivePanel(_optionsMainMenu);
        }

        private void ShowGameOptions()
        {
            ShowSubMenu(_gameOptionsMenu);
        }

        private void ShowVideoOptions()
        {
            ShowSubMenu(_videoOptionsMenu);
        }

        private void ShowSoundOptions()
        {
            ShowSubMenu(_soundOptionsMenu);
        }

        private void ShowControlsOptions()
        {
            ShowSubMenu(_controlOptionsMenu);
        }

        private void ShowSubMenu(VisualElement submenu)
        {
            if (_activePanel != null && _activePanel != submenu)
            {
                _panelHistory.Push(_activePanel);
            }

            SetActivePanel(submenu);
        }

        private void SetActivePanel(VisualElement activePanel)
        {
            _activePanel = activePanel;

            foreach (var menuPanel in _menuPanels)
            {
                menuPanel.style.display = menuPanel == activePanel ? DisplayStyle.Flex : DisplayStyle.None;
            }

            var showFooterButtons = activePanel != _optionsMainMenu;
            foreach (var footerButton in _footerButtons)
            {
                footerButton.style.display = showFooterButtons ? DisplayStyle.Flex : DisplayStyle.None;
            }

            ActivePanelChanged?.Invoke(activePanel);
        }

        private void HandleExitRequested()
        {
            _exitRequested?.Invoke();
        }

        private void HandleConfirmRequested()
        {
            _confirmRequested?.Invoke();
        }

        private void HandleBackRequested()
        {
            HandleBackAction();
        }

        private void HandleDefaultSettingsRequested()
        {
            _defaultSettingsRequested?.Invoke();
        }
    }
}
