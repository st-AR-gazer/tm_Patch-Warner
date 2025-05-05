[SettingsTab name="Patch Warner" icon="Bolt" order="10"]
void ST_PatchWarner() {

    UI::Text("Views");
    TableView::S_enableTableView = UI::Checkbox("Table view", TableView::S_enableTableView);
    if (TableView::S_enableTableView) {
        UI::Indent();
        TableView::S_showDate = UI::Checkbox("Show patch date", TableView::S_showDate);
        TableView::S_showIcon = UI::Checkbox("Show icons",       TableView::S_showIcon);
        UI::Unindent();
    }

    ImageAssets::S_useVisualIndicator = UI::Checkbox("Image strip (old icons)", ImageAssets::S_useVisualIndicator);
    Notification::S_enableNotifyView  = UI::Checkbox("Popup notifications",     Notification::S_enableNotifyView);

    UI::Separator();
    UI::Text("Individual patches");
    for (uint i = 0; i < Physics::RULES.Length; ++i) {
        Physics::RULES[i].enabled =
            UI::Checkbox("Warn about " + Physics::RULES[i].name, Physics::RULES[i].enabled);
    }
}
