using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.UIElements;




namespace UI.Menus.OptionsMenu
{
    public interface IMenu
    {
        void Show();
        void Hide();
    }
    public class OptionsMenuEvents : MonoBehaviour
    {
        private UIDocument _document;
        private OptionsMenuNavigationController _navigationController;
        private ControlsRebindController _controlsRebindController;
        private GameplaySettingsController _gameplaySettingsController;
        private VideoSettingsController _videoSettingsController;
        private AudioSettingsController _audioSettingsController;
        private bool _navigationInputRegistered;

        private IMenu previousMenu;

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

        private bool inMenu = false;

        private void Awake()
        {
            _document = GetComponent<UIDocument>();
            _navigationController = new OptionsMenuNavigationController();
            _controlsRebindController = new ControlsRebindController();
            _gameplaySettingsController = new GameplaySettingsController();
            _videoSettingsController = new VideoSettingsController();
            _audioSettingsController = new AudioSettingsController();

            _document.rootVisualElement.style.display = DisplayStyle.None;
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

            _gameplaySettingsController.UnregisterButtons();
            _videoSettingsController.UnregisterButtons();
            _audioSettingsController.UnregisterButtons();
            
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

            _gameplaySettingsController.Initialize(_root, _gameOptionsPanel, OnAnyChange);
            _videoSettingsController.Initialize(_root, _videoOptionsPanel, OnAnyChange);
            _audioSettingsController.Initialize(_root, _soundOptionsPanel, OnAnyChange);

            _controlsRebindController.Initialize(
                _root,
                entries,
                rebindSaveKey,
                controlRowClass,
                valueContainerClass,
                listeningText,
                unboundText,
                OnAnyChange);


            _gameplaySettingsController.RegisterButtons();
            _videoSettingsController.RegisterButtons();
            _audioSettingsController.RegisterButtons();
            _controlsRebindController.RegisterRows();
        }

        public void Show(IMenu cameFrom)
        {
            if(!this.gameObject.activeSelf) this.gameObject.SetActive(true);
            inMenu = true;
            previousMenu = cameFrom;
            _document.rootVisualElement.style.display = DisplayStyle.Flex;
            previousMenu.Hide();
        }

        private void Hide()
        {
            inMenu = false;
            _document.rootVisualElement.style.display = DisplayStyle.None;
        }

        private void OnAnyChange()
        {
            _navigationController.ChangeConfirmOpacity(1f);
        }

        private void confirmOpacity(float opacity)
        {
            _navigationController.ChangeConfirmOpacity(opacity);
        }


        private void OnConfirmFooterClicked()
        {
            _gameplaySettingsController.Confirm();
            _videoSettingsController.Confirm();
            _audioSettingsController.Confirm();
            PlayerPrefs.Save();
            _navigationController.ChangeConfirmOpacity(0.3f);
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
            if (inMenu)
            {
                ExitRequested?.Invoke();

                Hide();
                previousMenu.Show(); 
            }
        }

        private void HandleActivePanelChanged(VisualElement activePanel)
        {
            _gameplaySettingsController.HandleActivePanelChanged(activePanel, confirmOpacity);
            _videoSettingsController.HandleActivePanelChanged(activePanel, confirmOpacity);
            _audioSettingsController.HandleActivePanelChanged(activePanel, confirmOpacity);
            _controlsRebindController.HandleActivePanelChanged(activePanel, confirmOpacity);
        }

        public void ResetAllBindingsToDefault()
        {
            _controlsRebindController.ResetAllBindingsToDefault();
        }
    }

}
