using UnityEngine.UIElements;

namespace UI.Menus.OptionsMenu
{
    public abstract class OptionsMenuSectionController
    {
        protected VisualElement Root;
        protected VisualElement Panel;
        private bool _isVisible;

        public virtual void Initialize(VisualElement root, VisualElement panel)
        {
            Root = root;
            Panel = panel;
            _isVisible = false;
        }

        public void HandleActivePanelChanged(VisualElement activePanel)
        {
            var shouldBeVisible = Panel != null && Panel == activePanel;
            if (shouldBeVisible == _isVisible)
            {
                return;
            }

            _isVisible = shouldBeVisible;
            if (_isVisible)
            {
                OnShown();
                return;
            }

            OnHidden();
        }

        protected virtual void OnShown() { }
        protected virtual void OnHidden() { }
    }
}
