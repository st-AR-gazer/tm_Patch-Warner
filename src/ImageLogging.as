[Setting category="General" name="Use Visual Image Indicator" description="Use a visual image indicator instead of the default text indicator"]
bool doVisualImageInducator = true;


nvg::Texture@ textureWood;
nvg::Texture@ textureIce1;
nvg::Texture@ textureIce2;

void loadTextures() {
    @textureWood = nvg::LoadTexture("src/img/wood.png");
    @textureIce1 = nvg::LoadTexture("src/img/ice1.png");
    @textureIce2 = nvg::LoadTexture("src/img/ice2.png");
}

void drawMultipleTextures(array<nvg::Texture@> textures, int count) {
    for (int i = 0; i < count; i++) {
        drawTexture(textures[i], i);
    }
}

[Setting category="General" name="XOffset" description="XOffset of the visual display"]
float xOffsetDrawing = 0.1f;

void drawTexture(nvg::Texture@ texture, int index = 0) {
    log("Drawing texture", LogLevel::Info, 16);

    float aspectRatio = 304.0f / 322.0f;
    float screenWidth = Draw::GetWidth();
    float screenHeight = Draw::GetHeight();
    float imageSize = screenHeight * 0.2f;
    float imageWidth = imageSize * aspectRatio;

    float xOffset = screenWidth * xOffsetDrawing;
    xOffset += (imageWidth + (imageWidth * 0.125f)) * index;

    float yOffset = screenHeight / screenHeight - 1;

    auto pos = vec2(xOffset, yOffset); 
    auto size = vec2(imageWidth, imageSize);

    if (texture !is null) {
        nvg::Reset();
        nvg::BeginPath();
        nvg::Rect(pos, size);
        nvg::FillPaint(nvg::TexturePattern(pos, size, 0.0f, @texture, 1.0f));
        nvg::Fill();
        nvg::ClosePath();
    }
}

void Render() {
    if (conditionForWood) {
        log("Condition for drawing texture met: Wood", LogLevel::Info, 16);
        drawTexture(textureWood, 0);
    } else if (conditionForIce1) {
        log("Condition for drawing texture met: Ice1", LogLevel::Info, 16);
        drawTexture(textureIce1, 0);
    } else if (conditionForIce2) {
        log("Condition for drawing texture met: Ice2", LogLevel::Info, 16);
        drawTexture(textureIce2, 0);
    }

    if (conditionForWood && conditionForIce1) {
        log("Condition for drawing texture met: Wood and Ice1", LogLevel::Info, 16);
        array<nvg::Texture@> textures = {textureWood, textureIce1};
        drawMultipleTextures(textures, 2);
    } else if (conditionForWood && conditionForIce2) {
        log("Condition for drawing texture met: Wood and Ice2", LogLevel::Info, 16);
        array<nvg::Texture@> textures = {textureWood, textureIce2};
        drawMultipleTextures(textures, 2);
    } else if (conditionForIce1 && conditionForIce2) { // cannot happen btw xdd
        log("Condition for drawing texture met: Ice1 and Ice2", LogLevel::Info, 16);
        array<nvg::Texture@> textures = {textureIce1, textureIce2};
        drawMultipleTextures(textures, 2);
    }
}
