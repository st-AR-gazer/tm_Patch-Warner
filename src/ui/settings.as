[Setting hidden] bool g_PluginEnabled = true;

[SettingsTab name="General" icon="Cog" order="10"]
void ST_PatchWarner() {
    /* --------- General (two-column table) --------- */
    UI::Text("General");
    UI::Separator();

    if (UI::BeginTable("GeneralTable", 3,
        UI::TableFlags::SizingFixedFit |
        UI::TableFlags::NoPadOuterX    |
        UI::TableFlags::BordersInnerV))
    {
        UI::TableSetupColumn("Patches", UI::TableColumnFlags::WidthFixed, 150.0f);
        UI::TableSetupColumn("Toggles");
        UI::TableNextRow();

        /* LEFT column - individual patches */
        UI::TableNextColumn();
        UI::Text("Individual patches");
        UI::Indent();

        for (uint i = 0; i < Physics::RULES.Length; ++i) {
            bool newVal = UI::Checkbox("##patch" + i, Physics::RULES[i].enabled);
            if (newVal != Physics::RULES[i].enabled) {
                Physics::RULES[i].enabled = newVal;
                Prefs::SetEnabled(Physics::RULES[i].name, newVal);
            }
            UI::SameLine();
            UI::Text(Physics::RULES[i].name);
        }
        UI::Unindent();

        /* MIDDLE column - patch labels */
        UI::TableNextColumn();
        UI::Text("Patch labels");
        UI::Indent();
        for (uint i = 0; i < Physics::RULES.Length; ++i) {
            string cur = Prefs::GetLabel(Physics::RULES[i].name, Physics::RULES[i].name);
            string newTxt = UI::InputText("##lbl" + i, cur, false,
                UI::InputTextFlags::CharsNoBlank | 
                UI::InputTextFlags::AutoSelectAll);
            if (newTxt != cur) Prefs::SetLabel(Physics::RULES[i].name, newTxt);
            UI::SameLine();
            UI::Text(Physics::RULES[i].name);
        }
        UI::Unindent();

        /* RIGHT column - global toggles */
        UI::TableNextColumn();
        UI::Text("Global options");
        UI::Indent();

        g_PluginEnabled = UI::Checkbox("Enable Patch Warner", g_PluginEnabled);
        Detectors::S_useOffset = UI::Checkbox("Read exeBuild via GBX offset", Detectors::S_useOffset);
        if (UI::Button("Use 'Gen' instead of boring normal text")) {
            for (uint i = 0; i < Physics::RULES.Length; ++i) {
                string patchName = Physics::RULES[i].name;
                int dashPos = patchName.IndexOf("-");
                if (dashPos >= 0) {
                    string typePart = patchName.SubStr(0, dashPos);
                    string numPart  = patchName.SubStr(dashPos + 1);
                    Prefs::SetLabel(patchName, "Gen " + numPart + " " + typePart);
                }
            }
        }
        if (UI::Button("Reset patch labels to defaults")) {
            for (uint i = 0; i < Physics::RULES.Length; ++i) {
                string patchName = Physics::RULES[i].name;
                Prefs::SetLabel(patchName, patchName);
            }
        }

        UI::Unindent();
        UI::EndTable();
    }

    UI::Separator();

    UI::Dummy(vec2(0, 20));

    /* --------- Views TabBar --------- */
    UI::BeginTabBar("ViewsTabBar", UI::TabBarFlags::NoCloseWithMiddleMouseButton |
        UI::TabBarFlags::FittingPolicyScroll |
        UI::TabBarFlags::FittingPolicyResizeDown);

    /* Table view */
    if (UI::BeginTabItem("Table")) {
        TableView::S_enableTableView = UI::Checkbox("Enable table view", TableView::S_enableTableView);

        UI::Separator(); UI::Text("Content");
        UI::Indent();
        TableView::S_showDate = UI::Checkbox("Show patch date", TableView::S_showDate);
        TableView::S_showIcon = UI::Checkbox("Show icons",      TableView::S_showIcon);
        UI::Unindent();

        UI::Separator(); UI::Text("Size");
        UI::Indent();
        TableView::S_heightScalePct = UI::SliderFloat("Row height (%)",  TableView::S_heightScalePct, 50.0f, 200.0f, "%.0f %%");
        TableView::S_widthScalePct  = UI::SliderFloat("Table width (%)", TableView::S_widthScalePct,  10.0f, 120.0f, "%.0f %%");
        UI::Unindent();

        UI::Separator(); UI::Text("Position");
        UI::Indent();
        TableView::S_anchorX = UI::SliderFloat("Horizontal anchor (%)", TableView::S_anchorX, 0.0f, 1.0f, "%.2f");
        TableView::S_anchorY = UI::SliderFloat("Vertical anchor (%)",   TableView::S_anchorY, 0.0f, 1.0f, "%.2f");
        UI::Unindent();

        UI::Separator(); UI::Text("Animation");
        UI::Indent();
        TableView::S_slideMS   = UI::SliderInt("Panel slide (ms)",    TableView::S_slideMS,   200, 2000);
        TableView::S_sepGrowMS = UI::SliderInt("Separator grow (ms)", TableView::S_sepGrowMS, 200, 3000);
        TableView::S_holdMS    = UI::SliderInt("Hold time (ms)",      TableView::S_holdMS,    1000, 15000);
        UI::Unindent();

        UI::Separator(); UI::Text("Colours");
        UI::Indent();
        TableView::S_colBg      = UI::InputColor4("Background",   TableView::S_colBg);
        TableView::S_colBorder  = UI::InputColor4("Border",       TableView::S_colBorder);
        TableView::S_colSep     = UI::InputColor4("Separators",   TableView::S_colSep);
        TableView::S_colOutline = UI::InputColor4("Text outline", TableView::S_colOutline);
        TableView::S_colText    = UI::InputColor4("Text",         TableView::S_colText);
        UI::Unindent();

        UI::Separator();
        if (UI::Button("Reset table to defaults")) {
            TableView::S_heightScalePct = 90.0f;
            TableView::S_widthScalePct  = 50.0f;
            TableView::S_anchorX        = 0.70f;
            TableView::S_anchorY        = 0.05f;
            TableView::S_slideMS        = 500;
            TableView::S_sepGrowMS      = 1000;
            TableView::S_holdMS         = 8000;

            TableView::S_colBg      = vec4(0, 0, 0, 0.85f);
            TableView::S_colBorder  = vec4(1, 1, 1, 0.80f);
            TableView::S_colSep     = vec4(1, 1, 1, 0.25f);
            TableView::S_colOutline = vec4(0, 0, 0, 0.90f);
            TableView::S_colText    = vec4(1, 1, 1, 1);
        }
        UI::EndTabItem();
    }

    /* Image view */
    if (UI::BeginTabItem("Image strip")) {
        ImageView::S_strip_useVisualIndicator = UI::Checkbox("Enable image strip", ImageView::S_strip_useVisualIndicator);
        UI::Separator(); UI::Text("Position");
        ImageView::S_strip_xOffset = UI::SliderFloat("X offset (%)", ImageView::S_strip_xOffset, 0.0f, 1.0f, "%.2f");
        ImageView::S_strip_yOffset = UI::SliderFloat("Y offset (%)", ImageView::S_strip_yOffset, 0.0f, 1.0f, "%.2f");
        UI::Separator(); UI::Text("Size");
        ImageView::S_strip_imageSize = UI::SliderFloat("Image size (%)", ImageView::S_strip_imageSize, 0.02f, 0.30f, "%.2f");
        UI::Separator(); UI::Text("Animation");
        ImageView::S_strip_duration = UI::SliderInt("Duration (ms)", ImageView::S_strip_duration, 1000, 15000);


        if (UI::Button("Reset image strip to defaults")) {
            ImageView::S_strip_useVisualIndicator = true;
            ImageView::S_strip_xOffset   = 0.15f;
            ImageView::S_strip_yOffset   = 0.00f;
            ImageView::S_strip_imageSize = 0.06f;
            ImageView::S_strip_duration  = 6000;
        }
        UI::EndTabItem();
    }
    
    /* Notification view */
    if (UI::BeginTabItem("Notifications")) {
        Notification::S_notif_enableNotifyView = UI::Checkbox("Enable notifications", Notification::S_notif_enableNotifyView);
        UI::Separator();
        Notification::S_notif_duration = UI::SliderInt("Duration (ms)", Notification::S_notif_duration, 1000, 15000);

        if (UI::Button("Reset notifications to defaults")) {
            Notification::S_notif_enableNotifyView = true;
            Notification::S_notif_duration = 6000;
        }
        UI::EndTabItem();
    }
    
    UI::EndTabBar();
}
