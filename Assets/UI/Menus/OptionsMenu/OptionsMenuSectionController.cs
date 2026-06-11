using UnityEngine.UIElements;
using System;

namespace UI.Menus.OptionsMenu
{
    public abstract class OptionsMenuSectionController
    {
        protected VisualElement Root;
        protected VisualElement Panel;
        protected bool _isVisible;
        protected Action _anyChange;
        protected bool changed;

        public virtual void Initialize(VisualElement root, VisualElement panel, Action anyChange)
        {
            Root = root;
            Panel = panel;
            _isVisible = false;
            _anyChange = anyChange;
            changed = false;
        }

        public void HandleActivePanelChanged(VisualElement activePanel, Action<float> confirmOpacity)
        {
            var shouldBeVisible = Panel != null && Panel == activePanel;
            if (shouldBeVisible == _isVisible)
            {
                return;
            }

            _isVisible = shouldBeVisible;
            if (_isVisible)
            {
                if(changed) confirmOpacity?.Invoke(1f);
                else confirmOpacity?.Invoke(0.3f);
                
                OnShown();
                return;
            }

            OnHidden();
        }

        protected virtual void OnShown() { }
        protected virtual void OnHidden() { }
    }
}
