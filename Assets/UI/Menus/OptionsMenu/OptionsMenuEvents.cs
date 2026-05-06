using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.UIElements;
using UnityEngine.SceneManagement;


namespace UI.Menus.OptionsMenu
{
    public class OptionsMenuEvents : MonoBehaviour
    {
        private UIDocument _document;
        private OptionsMenuNavigationController _navigationController;
        private ControlsRebindController _controlsRebindController;
        private GameplaySettingsController _gameplaySettingsController;
        private VideoSettingsController _videoSettingsController;
        private AudioSettingsController _audioSettingsController;
        private bool _navigationInputRegistered;

        [Header("Flow")]
        [SerializeField] private string mainMenuSceneName = "MainMenu";
        [SerializeField] private bool fallbackLoadMainMenuOnExit = true;

        [Header("Input")]
        [SerializeField] private string rebindSaveKey = "input-rebinds";

        [Header("UI Query")]
        [SerializeField] private string controlRowClass = "controlOptionGroup";
        [SerializeField] private string valueContainerClass = "controlOptionSettingsContainer";

        [Header("Display")]
        [SerializeField] private string listeningText = "Press any key...";
        [SerializeField] private string unboundText = "Unbound";

        [Header("Navigation")]
        [SerializeField] private InputActionReference backAction;

        [Header("Mapping")]
        [SerializeField] private List<RebindEntry> entries = new List<RebindEntry>();

        private VisualElement _root;
        private VisualElement _gameOptionsPanel;
        private VisualElement _videoOptionsPanel;
        private VisualElement _soundOptionsPanel;

        public event Action ExitRequested;

        private void Awake()
        {
            _document = GetComponent<UIDocument>();
            _navigationController = new OptionsMenuNavigationController();
            _controlsRebindController = new ControlsRebindController();
            _gameplaySettingsController = new GameplaySettingsController();
            _videoSettingsController = new VideoSettingsController();
            _audioSettingsController = new AudioSettingsController();
        }

        private void OnEnable()
        {
            if (_document == null)
            {
                _document = GetComponent<UIDocument>();
            }

            InitializeMenuUI();

            if (enabled)
            {
                RegisterNavigationInput();
                _navigationInputRegistered = true;
            }
        }

        private void OnDisable()
        {
            if (_navigationInputRegistered)
            {
                UnregisterNavigationInput();
                _navigationInputRegistered = false;
            }

            _navigationController.ActivePanelChanged -= HandleActivePanelChanged;
            _navigationController.UnregisterButtons();
            _controlsRebindController.UnregisterRows();
        }

        private void InitializeMenuUI()
        {
            _root = _document.rootVisualElement;

            _navigationController.Initialize(_root, HandleExitRequested, OnConfirmFooterClicked, OnDefaultSettingsFooterClicked);

            _navigationController.ActivePanelChanged -= HandleActivePanelChanged;
            _navigationController.ActivePanelChanged += HandleActivePanelChanged;
            _navigationController.RegisterButtons();

            _gameOptionsPanel = _root.Q<VisualElement>(OptionsMenuUIIDs.GameOptions);
            _videoOptionsPanel = _root.Q<VisualElement>(OptionsMenuUIIDs.VideoOptions);
            _soundOptionsPanel = _root.Q<VisualElement>(OptionsMenuUIIDs.SoundOptions);

            _gameplaySettingsController.Initialize(_root, _gameOptionsPanel);
            _videoSettingsController.Initialize(_root, _videoOptionsPanel);
            _audioSettingsController.Initialize(_root, _soundOptionsPanel);

            _controlsRebindController.Initialize(
                _root,
                entries,
                rebindSaveKey,
                controlRowClass,
                valueContainerClass,
                listeningText,
                unboundText);

            _controlsRebindController.RegisterRows();
        }

        private void OnConfirmFooterClicked()
        {
            // TODO
        }

        private void OnDefaultSettingsFooterClicked()
        {
            // TODO
        }

        private void RegisterNavigationInput()
        {
            var action = backAction.action;

            action.performed += OnBackPerformed;
            action.Enable();
        }

        private void UnregisterNavigationInput()
        {
            var action = backAction.action;

            action.performed -= OnBackPerformed;
            action.Disable();
        }

        private void OnBackPerformed(InputAction.CallbackContext _)
        {
            if (_controlsRebindController.IsRebinding)
            {
                _controlsRebindController.CancelActiveRebind();
                return;
            }

            _navigationController.HandleBackAction();
        }

        private void HandleExitRequested()
        {
            ExitRequested?.Invoke();

            if (ExitRequested == null && fallbackLoadMainMenuOnExit)
            {
                SceneManager.LoadSceneAsync(mainMenuSceneName);
            }
        }

        private void HandleActivePanelChanged(VisualElement activePanel)
        {
            _gameplaySettingsController.HandleActivePanelChanged(activePanel);
            _videoSettingsController.HandleActivePanelChanged(activePanel);
            _audioSettingsController.HandleActivePanelChanged(activePanel);
            _controlsRebindController.HandleActivePanelChanged(activePanel);
        }

        public void ResetAllBindingsToDefault()
        {
            _controlsRebindController.ResetAllBindingsToDefault();
        }
    }

}
