namespace TableView {

    [Setting hidden]
    bool S_enableTableView = true;
    [Setting hidden]
    bool S_showDate = true;
    [Setting hidden]
    bool S_showIcon = true;

    [Setting hidden]
    float S_anchorX = 0.05f;
    [Setting hidden]
    float S_anchorY = 0.65f;

    void Render() {
        if (!S_enableTableView) return;
        auto cache = Physics::g_Result;
        if (!cache.ready || cache.results.IsEmpty()) return;

        float W = Draw::GetWidth();
        float H = Draw::GetHeight();
        vec2  org = vec2(W * S_anchorX, H * S_anchorY);

        float rowH  = 0.03f * H;
        float iconW = rowH;
        float textW = 0.30f * W;

        for (uint i = 0; i < cache.results.Length; ++i) {
            const Physics::Rule@ r = cache.results[i].rule;
            vec2 base = org + vec2(0, i * rowH);

            nvg::BeginPath();
            nvg::FontSize(rowH * 0.60f);
            nvg::FillColor(vec4(1,1,1,1));
            nvg::Text(base, r.name.Replace("-", " "));

            if (S_showDate) {
                nvg::FontSize(rowH * 0.40f);
                nvg::FillColor(vec4(0.85f,0.85f,0.85f,1));

                string maxDateStr = (r.maxDate == "") ? "NOLIMIT" : r.maxDate;
                string minDateStr = (r.minDate == "") ? "NOLIMIT" : r.minDate;
                nvg::Text(base + vec2(0, rowH * 0.60f), maxDateStr + " < " + minDateStr);
            }
            nvg::ClosePath();

            if (S_showIcon && r.icon != Physics::ViewIcon::NONE) {
                nvg::Texture@ t = ImageAssets::IconToTexture(r.icon);
                if (t !is null) {
                    vec2 p  = base + vec2(textW, 0);
                    vec2 sz = vec2(iconW, iconW);
                    nvg::BeginPath();
                    nvg::Rect(p, sz);
                    nvg::FillPaint(nvg::TexturePattern(p, sz, 0, t, 1));
                    nvg::Fill();
                    nvg::ClosePath();
                }
            }
        }
    }
}
