namespace TableView {

    /* behaviour toggles */
    [Setting hidden] bool S_enableTableView = true;
    [Setting hidden] bool S_showDate        = true;
    [Setting hidden] bool S_showIcon        = true;

    /* persistent/drag flags */
    [Setting hidden] bool S_constantDisplay = false;
    [Setting hidden] bool S_dragMode        = false;

    bool g_dragging = false;
    vec2 g_dragOff  = vec2();

    /* anchor position */
    [Setting hidden] float S_anchorX = 0.70f;
    [Setting hidden] float S_anchorY = 0.05f;

    /* user scaling */
    [Setting hidden min=50 max=150] float S_heightScalePct = 100.0f;
    [Setting hidden min=50 max=150] float S_widthScalePct  = 100.0f;

    /* base geometry */
    const float kBaseRowHPct   = 3.6f;
    const float kBaseRowGapF   = 0.35f;
    const float kBaseTextWFrac = 0.18f;
    const float kBaseSpacerF   = 0.012f;

    /* timings  */
    [Setting hidden] uint  S_slideMS    = 500;
    [Setting hidden] uint  S_sepGrowMS  = 1000;
    [Setting hidden] uint  S_holdMS     = 8000;

    /* slide direction */
    enum SlideDir { Up = 0, Down, Left, Right }
    [Setting hidden] int S_slideDir = int(SlideDir::Up);

    /* user colours */
    [Setting hidden] vec4 S_colBg      = vec4(0, 0, 0, 0.85f);
    [Setting hidden] vec4 S_colBorder  = vec4(1, 1, 1, 0.80f);
    [Setting hidden] vec4 S_colSep     = vec4(1, 1, 1, 0.25f);
    [Setting hidden] vec4 S_colOutline = vec4(0, 0, 0, 0.90f);
    [Setting hidden] vec4 S_colText    = vec4(1, 1, 1, 0.85f);
    const float kBorderW = 2.0f;

    /* animation state */
    bool g_animActive = false;
    uint g_animStartMS = 0;
    uint g_totalMS = 0;
    void StartAnimation() {
        g_animActive  = true;
        g_animStartMS = Time::Now;
        g_totalMS     = S_slideMS + S_holdMS + S_slideMS;
    }

    /* helpers */
    float EaseInOut(float t) {
        return (t < 0.5f)
             ? 4.0f * t * t * t
             : 1.0f - Math::Pow(-2.0f * t + 2.0f, 3.0f) / 2.0f;
    }

    void DrawTextOutlined(const string &in txt, vec2 pos, float fontSz,
                          const vec4 &in outline, const vec4 &in fill) {
        nvg::FontSize(fontSz);
        nvg::FillColor(outline);
        nvg::Text(pos + vec2( 1, 0), txt); nvg::Text(pos + vec2(-1, 0), txt);
        nvg::Text(pos + vec2( 0, 1), txt); nvg::Text(pos + vec2( 0,-1), txt);
        nvg::Text(pos + vec2( 2, 0), txt); nvg::Text(pos + vec2(-2, 0), txt);
        nvg::Text(pos + vec2( 0, 2), txt); nvg::Text(pos + vec2( 0,-2), txt);
        nvg::FillColor(fill);
        nvg::Text(pos, txt);
    }

    float _SlideVal(uint elapsed, uint phaseIn, uint phaseHold, float range, bool positive) {
        if (elapsed < phaseIn) {
            float p = EaseInOut(float(elapsed) / float(S_slideMS));
            return (positive ? 1.0f : -1.0f) * (1.0f - p) * range;
        }
        if (elapsed >= phaseHold) {
            float p = EaseInOut(float(elapsed - phaseHold) / float(S_slideMS));
            return (positive ? 1.0f : -1.0f) * p * range;
        }
        return 0.0f;
    }

    /* render */
    void Render() {
        if (!S_enableTableView) return;

        auto cache = Physics::g_Result;
        if (!cache.ready || cache.results.IsEmpty()) return;

        bool infiniteHold = S_constantDisplay;
        bool dragActive   = S_dragMode;
        uint now          = Time::Now;
        uint elapsed      = now - g_animStartMS;

        if (!infiniteHold && !dragActive) {
            if (!g_animActive) return;
            if (now - g_animStartMS >= g_totalMS) {
                g_animActive = false;
                return;
            }
        }

        float W = Draw::GetWidth();
        float H = Draw::GetHeight();

        float hScale = S_heightScalePct / 100.0f;
        float wScale = S_widthScalePct  / 100.0f;

        /* geometry */
        float rowH   = (kBaseRowHPct / 100.0f) * H * hScale;
        float gap    = rowH * kBaseRowGapF;
        float stepY  = rowH + gap;

        float iconW  = rowH;
        float spacer = kBaseSpacerF * W * wScale;
        float textW  = kBaseTextWFrac * W * wScale;

        float tableH = cache.results.Length * stepY - gap;
        float tableW = textW + spacer + iconW;

        float padX   = 0.010f * W * wScale;
        float padY   = gap * 0.5f + kBorderW;

        /* anchor */
        float baseX  = W * S_anchorX;
        float baseY  = H * S_anchorY;

        if (S_anchorY < 0.06f && UI::IsOverlayShown() && OPMenu::g_HeightPx > 0.0f) baseY += OPMenu::g_HeightPx;

        float dispX  = 0.0f, dispY = 0.0f;

        if (!dragActive) {
            uint phaseIn  = S_slideMS;
            uint phaseHold = infiniteHold ? uint(-1)/* uint::Max() :Clueless: */ : (S_slideMS + S_holdMS);

            switch (SlideDir(S_slideDir)) {
                case SlideDir::Up: {
                    float range = baseY + tableH + padY * 2.0f;
                    dispY = _SlideVal(elapsed, phaseIn, phaseHold, range, false);
                } break;

                case SlideDir::Down: {
                    float range = (H - baseY) + padY + rowH;
                    dispY = _SlideVal(elapsed, phaseIn, phaseHold, range, true);
                } break;

                case SlideDir::Left: {
                    float range = baseX + tableW + padX * 2.0f;
                    dispX = _SlideVal(elapsed, phaseIn, phaseHold, range, false);
                } break;

                case SlideDir::Right: {
                    float range = (W - baseX) + padX + iconW;
                    dispX = _SlideVal(elapsed, phaseIn, phaseHold, range, true);
                } break;
            }
        }

        if (dragActive && UI::IsOverlayShown()) {
            vec2 mPos = UI::GetMousePos();

            vec2 panelLT   = vec2(baseX + dispX, baseY + dispY);
            vec2 panelBr   = panelLT + vec2(tableW, tableH);
            float buf      = 5.0f;

            bool hovered = (mPos.x >= panelLT.x - buf && mPos.x <= panelBr.x + buf && mPos.y >= panelLT.y - buf && mPos.y <= panelBr.y + buf);

            if (!g_dragging && hovered && UI::IsMouseClicked(UI::MouseButton::Left)) {
                g_dragging = true;
                g_dragOff  = mPos - panelLT;
            }

            if (g_dragging) {
                if (UI::IsMouseDown(UI::MouseButton::Left)) {
                    float newBaseX = (mPos.x - g_dragOff.x);
                    float newBaseY = (mPos.y - g_dragOff.y);
                    S_anchorX = newBaseX / W;
                    S_anchorY = newBaseY / H;
                } else g_dragging = false;
            }
        }

        float nameOffY = rowH * 0.50f;
        float dateOffY = rowH * 0.95f;

        vec2 panelOrg = vec2(baseX + dispX - padX, baseY + dispY - padY);
        vec2 panelSz  = vec2(tableW + padX * 2.0f, tableH + padY * 2.0f);

        nvg::BeginPath();
        nvg::Rect(panelOrg, panelSz);
        nvg::FillColor(S_colBg);
        nvg::Fill();
        nvg::StrokeWidth(kBorderW);
        nvg::StrokeColor(S_colBorder);
        nvg::Stroke();
        nvg::ClosePath();

        float sepProgress = (dragActive || infiniteHold)
                          ? 1.0f
                          : Math::Clamp(float(Math::Min(now - g_animStartMS, S_sepGrowMS))
                          / float(S_sepGrowMS), 0.0f, 1.0f);

        for (uint i = 0; i < cache.results.Length; ++i) {
            const Physics::Rule@ r = cache.results[i].rule;
            vec2 rowLT = vec2(baseX + dispX, baseY + dispY + i * stepY);

            string labelTxt = Prefs::GetLabel(r.name, r.name);
            DrawTextOutlined(labelTxt, rowLT + vec2(0, nameOffY), rowH * 0.54f, S_colOutline, S_colText);

            /* date label */
            if (S_showDate) {
                string dateStr;
                     if (r.minDate == "" && r.maxDate != "") dateStr = "≤ " + r.maxDate;
                else if (r.minDate != "" && r.maxDate == "") dateStr = "≥ " + r.minDate;
                else if (r.minDate != "" && r.maxDate != "") {
                    string minTrim = r.minDate.SubStr(0, r.minDate.Length - 9);
                    string maxTrim = r.maxDate.SubStr(0, r.maxDate.Length - 9);
                    dateStr = minTrim + " … " + maxTrim;
                }

                DrawTextOutlined(dateStr, rowLT + vec2(0, dateOffY), rowH * 0.40f, S_colOutline, S_colText);
            }

            /* icon */
            if (S_showIcon && r.icon != Physics::ViewIcon::NONE) {
                nvg::Texture@ tex = ImageAssets::IconToTexture(r.icon);
                if (tex !is null) {
                    vec2 pos = rowLT + vec2(textW + spacer, 0);
                    nvg::BeginPath();
                    nvg::Rect(pos, vec2(iconW, iconW));
                    nvg::FillPaint(nvg::TexturePattern(pos, vec2(iconW, iconW), 0, tex, 1));
                    nvg::Fill();
                    nvg::ClosePath();
                }
            }

            /* separator */
            if (i < cache.results.Length - 1) {
                float y = rowLT.y + rowH + gap * 0.5f;
                float halfLen = (tableW * sepProgress) * 0.5f;
                float xL = rowLT.x;
                float xR = xL + tableW;

                nvg::BeginPath();
                nvg::MoveTo(vec2(xL, y));
                nvg::LineTo(vec2(xL + halfLen, y));
                nvg::MoveTo(vec2(xR - halfLen, y));
                nvg::LineTo(vec2(xR, y));
                nvg::StrokeWidth(1.0f);
                nvg::StrokeColor(S_colSep);
                nvg::Stroke();
                nvg::ClosePath();
            }
        }
    }
}
