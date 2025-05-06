namespace ImageView {
    [Setting hidden] bool  S_enableImageView = true;

    [Setting hidden] bool  S_strip_useVisualIndicator = false;
    [Setting hidden] float S_strip_xOffset = 0.10f;
    [Setting hidden] float S_strip_yOffset = 0.00f;
    [Setting hidden] float S_strip_imageSize = 0.10f;

    [Setting hidden min=1000 max=15000]
    int S_strip_duration = 10000;

    [Setting hidden min=0.0 max=10000.0]
    float S_strip_fadeDuration = 3000.0f;

    uint g_Countdown = 0;
    uint g_LastTick  = 0;

    void OnMapChanged() {
        g_Countdown = S_strip_duration;
        g_LastTick  = Time::Now;
    }

    void Tick() {
        uint now = Time::Now;

        if (g_LastTick == 0) { g_LastTick = now; return; }

        uint dt = now - g_LastTick;
        g_LastTick = now;

        if (g_Countdown > dt) g_Countdown -= dt;
        else                  g_Countdown = 0;
    }

    void Render() {
        if (!S_enableImageView || !ImageView::S_strip_useVisualIndicator) return;
        auto cache = Physics::g_Result;
        if (!cache.ready || cache.results.IsEmpty()) return;

        array<nvg::Texture@> icons;
        for (uint i = 0; i < cache.results.Length; ++i) {
            auto t = ImageAssets::IconToTexture(cache.results[i].rule.icon);
            if (t !is null) icons.InsertLast(t);
        }
        if (icons.IsEmpty()) return;

        DrawStrip(icons);
        Tick();
    }

    void DrawStrip(const array<nvg::Texture@>@ icons) {
        float aspect   = 304.0f / 322.0f;
        float W        = Draw::GetWidth();
        float H        = Draw::GetHeight();
        float hImg     = H * ImageView::S_strip_imageSize;
        float wImg     = hImg * aspect;

        float baseX = W * ImageView::S_strip_xOffset;
        float baseY = H * (1.0f - ImageView::S_strip_yOffset) - hImg;

        float stripW = (icons.Length > 0)
                     ? (wImg + (icons.Length - 1) * wImg * 1.125f)
                     : 0.0f;

        baseX = Math::Clamp(baseX, 0.0f, Math::Max(0.0f, W - stripW));
        baseY = Math::Clamp(baseY, 0.0f, Math::Max(0.0f, H - hImg));

        float fadeDur   = S_strip_fadeDuration;
        float fadeStart = float(S_strip_duration) - fadeDur;
        float a = 1.0f;
        if (g_Countdown > fadeStart)
            a = 1.0f - float(g_Countdown - fadeStart) / fadeDur;
        else if (g_Countdown < fadeDur)
            a = float(g_Countdown) / fadeDur;
        a = Math::Clamp(a, 0.0f, 1.0f);

        for (uint i = 0; i < icons.Length; ++i) {
            vec2 pos = vec2(baseX + i * wImg * 1.125f, baseY);
            vec2 sz  = vec2(wImg, hImg);

            nvg::BeginPath();
            nvg::Rect(pos, sz);
            nvg::FillPaint(nvg::TexturePattern(pos, sz, 0.0f, icons[i], a));
            nvg::Fill();
            nvg::ClosePath();
        }
    }
}
