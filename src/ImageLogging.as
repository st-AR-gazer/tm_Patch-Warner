[Setting category="General" name="Use Visual Image Indicator" description="Use a visual image indicator instead of the default text indicator"]
bool doVisualImageInducator = true;


uint timeWoodTriggered = 0;
uint timeIce1Triggered = 0;
uint timeIce2Triggered = 0;

const uint displayDuration = 5000;

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

void drawTexture(nvg::Texture@ texture, int index = 0) {
    log("Drawing texture", LogLevel::Info, 28);

    float aspectRatio = 304.0f / 322.0f;
    float screenWidth = Draw::GetWidth();
    float screenHeight = Draw::GetHeight();
    float imageSize = screenHeight * 0.2f;
    float imageWidth = imageSize * aspectRatio;

    float xOffset = screenWidth * 0.1f;

    xOffset += (imageWidth + (imageWidth * 0.125f)) * index;

    auto pos = vec2(xOffset, screenHeight / screenHeight ); 
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

bool shouldDisplay(uint triggeredTime) {
    uint currentTime = Time::Now;
    log("Current time: " + currentTime + " " + "Triggered time: " + triggeredTime + " display duration: " + displayDuration, LogLevel::Info, 55);
    return currentTime - triggeredTime < displayDuration;
}

void Render() {
    // Single texture conditions
    if (conditionForWood) {
        if (shouldDisplay(timeWoodTriggered)) {
            drawTexture(textureWood, 0);
        } else {
            timeWoodTriggered = Time::Now;
        }
    }

    if (conditionForIce1) {
        if (shouldDisplay(timeIce1Triggered)) {
            drawTexture(textureIce1, 0);
        } else {
            timeIce1Triggered = Time::Now;
        }
    }

    if (conditionForIce2) {
        if (shouldDisplay(timeIce2Triggered)) {
            drawTexture(textureIce2, 0);
        } else {
            timeIce2Triggered = Time::Now;
        }
    }

    // Combination conditions
    if (conditionForWood && conditionForIce1) {
        if (shouldDisplay(timeWoodTriggered) && shouldDisplay(timeIce1Triggered)) {
            array<nvg::Texture@> textures = {textureWood, textureIce1};
            drawMultipleTextures(textures, textures.Length);
        } else {
            timeWoodTriggered = Time::Now;
            timeIce1Triggered = Time::Now;
        }
    }

    if (conditionForWood && conditionForIce2) {
        if (shouldDisplay(timeWoodTriggered) && shouldDisplay(timeIce2Triggered)) {
            array<nvg::Texture@> textures = {textureWood, textureIce2};
            drawMultipleTextures(textures, textures.Length);
        } else {
            timeWoodTriggered = Time::Now;
            timeIce2Triggered = Time::Now;
        }
    }

    if (conditionForIce1 && conditionForIce2) {
        if (shouldDisplay(timeIce1Triggered) && shouldDisplay(timeIce2Triggered)) {
            array<nvg::Texture@> textures = {textureIce1, textureIce2};
            drawMultipleTextures(textures, textures.Length);
        } else {
            timeIce1Triggered = Time::Now;
            timeIce2Triggered = Time::Now;
        }
    }
}
