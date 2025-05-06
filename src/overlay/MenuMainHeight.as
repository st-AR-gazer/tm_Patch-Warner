namespace OPMenu {
    float g_HeightPx = 0.0f;
}

void RenderMenuMain() {
    vec2 sz = UI::GetWindowSize();
    OPMenu::g_HeightPx = sz.y;
}
