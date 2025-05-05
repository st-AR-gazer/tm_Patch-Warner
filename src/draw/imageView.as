namespace ImageView {

    [Setting hidden] bool S_enableImageView = true;

    uint g_Countdown = 10000;
    uint g_LastTick  = 0;

    void OnMapChanged() { g_Countdown = 10000; }

    void Tick() {
        uint now = Time::Now;
        if (g_Countdown > 0) {
            g_Countdown = (g_Countdown > now - g_LastTick)
                        ? g_Countdown - (now - g_LastTick)
                        : 0;
        }
        g_LastTick = now;
    }

    void Render() {
        if (!S_enableImageView || !ImageAssets::S_useVisualIndicator) return;
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
        float hImg     = H * ImageAssets::S_imageSize;
        float wImg     = hImg * aspect;

        float baseX    = W * ImageAssets::S_xOffset;
        float baseY    = H * (1.0f - ImageAssets::S_yOffset) - hImg;

        float a = 1.0f;
        if (g_Countdown > 8000)      a = 1.0f - float(g_Countdown - 8000) / 3000.0f;
        else if (g_Countdown < 3000) a = float(g_Countdown) / 3000.0f;
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
