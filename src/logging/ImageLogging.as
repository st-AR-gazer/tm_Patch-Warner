[Setting category="General" name="Use Visual Image Indicator" description="Use a visual image indicator instead of the default text indicator"]
bool doVisualImageInducator = false;


nvg::Texture@ textureIce1;
nvg::Texture@ textureIce2;
nvg::Texture@ textureIce3;
nvg::Texture@ textureWood;
nvg::Texture@ textureBumper;
nvg::Texture@ textureWater;

void loadTextures() {
    @textureIce1   = nvg::LoadTexture("src/img/ice1.png");
    @textureIce2   = nvg::LoadTexture("src/img/ice2.png");
    @textureIce3   = nvg::LoadTexture("src/img/ice3.png");
    @textureWood   = nvg::LoadTexture("src/img/wood.png");
    @textureBumper = nvg::LoadTexture("src/img/bumper.png");
    @textureWater = nvg::LoadTexture("src/img/water.png");
}


[Setting category="General" name="XOffset" description="XOffset of the visual display"]
float xOffsetDrawing = 0.1f;

[Setting category="General" name="YOffset" description="YOffset of the visual display"]
float custYOffest = 0.0f;

[Setting category="General" name="Image Size" description="Size of the visual image"]
float custImageSize = 0.1f;


void drawTexture(nvg::Texture@ texture, int index = 0) {
    float aspectRatio = 304.0f / 322.0f;
    float screenWidth = Draw::GetWidth();
    float screenHeight = Draw::GetHeight();
    float imageSize = screenHeight * custImageSize;
    float imageWidth = imageSize * aspectRatio;

    float xOffset = screenWidth * xOffsetDrawing;
    xOffset += (imageWidth + (imageWidth * 0.125f)) * index;

    float yOffset = screenHeight / screenHeight - 1;

    auto pos = vec2(xOffset, yOffset + (custYOffest * screenHeight)); 
    auto size = vec2(imageWidth, imageSize);

    float transparancy;
    if (CountdownTime > 8000) { // start 
        transparancy = 1.0f - ((CountdownTime - 8000) / 3000.0f);
    } else if (CountdownTime > 3000) { // middle
        transparancy = 1.0f;
    } else { // end
        transparancy = CountdownTime / 3000.0f;
    }

    transparancy = Math::Clamp(transparancy, 0.0f, 1.0f);

    if (CountdownTime == 0) return;
    if (!doVisualImageInducator) return;

    if (texture !is null) {
        nvg::Reset();
        nvg::BeginPath();
        nvg::Rect(pos, size);
        nvg::FillPaint(nvg::TexturePattern(pos, size, 0.0f, @texture, transparancy));
        nvg::Fill();
        nvg::ClosePath();
    }
}

void Render() {
    array<nvg::Texture@> texturesToDraw;

    if (conditionForIce1) {
        texturesToDraw.InsertLast(textureIce1);
    }
    if (conditionForIce2) {
        texturesToDraw.InsertLast(textureIce2);
    }
    if (conditionForIce3) {
        texturesToDraw.InsertLast(textureIce3);
    }
    if (conditionForWood) {
        texturesToDraw.InsertLast(textureWood);
    }
    if (conditionForBumper) {
        texturesToDraw.InsertLast(textureBumper);
    }
    if (conditionForWater1) {
        texturesToDraw.InsertLast(textureWater);
    }

    drawMultipleTextures(texturesToDraw, texturesToDraw.Length);
}

void drawMultipleTextures(array<nvg::Texture@> textures, int count) {
    for (int i = 0; i < count; i++) {
        drawTexture(textures[i], i);
    }
}