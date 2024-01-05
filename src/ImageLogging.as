[Setting category="General" name="Use Visual Image Indicator" description="Use a visual image indicator instead of the default text indicator"]
bool doVisualImageInducator = true;


nvg::Texture@ textureWood;
nvg::Texture@ textureIce1;
nvg::Texture@ textureIce2;

void loadTextures() {
    @textureWood = nvg::LoadTexture("path/to/wood.png");
    @textureIce1 = nvg::LoadTexture("path/to/ice1.png");
    @textureIce2 = nvg::LoadTexture("path/to/ice2.png");
}

void drawTexture(nvg::Texture@ texture) {
    log("Drawing texture", LogLevel::Info, 16);


    auto pos = vec2(200, 0);
    auto size = vec2(200, 0);

    if (texture !is null) {
        nvg::Reset();
        nvg::BeginPath();
        nvg::Rect(pos, size);
        nvg::FillPaint(nvg::TexturePattern(pos, size, 0.0f, @texture, 1.0f));
        nvg::Fill();
        nvg::ClosePath();
    }
}

void NotifyVisualImageIce() {
    drawTexture(textureWood);
}

void NotifyVisualImageIce2() {
    drawTexture(textureIce1);
}

void NotifyVisualImageWood() {
    drawTexture(textureIce2);
}

void Render() {
    if (conditionForWood) {
        log("Condition for drawing texture met: Wood", LogLevel::Info, 16);

        NotifyVisualImageWood();
    }
    if (conditionForIce1) {
        log("Condition for drawing texture met: Ice1", LogLevel::Info, 16);

        NotifyVisualImageIce();
    }
    if (conditionForIce2) {
        log("Condition for drawing texture met: Ice2", LogLevel::Info, 16);

        NotifyVisualImageIce2();
    }
}

