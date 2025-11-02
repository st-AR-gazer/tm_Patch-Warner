void RenderMenu() {
    if (UI::MenuItem("\\$1F1" + "\\$ " + Colorize(Icons::ExclamationTriangle + " " + Icons::Bell + " Patch Warner", {"#FF4E42", "#FF8600", "#FFEB3B"}, colorize::GradientMode::inverseQuadratic, true))) {
        Physics_RunChecks();
    }
}