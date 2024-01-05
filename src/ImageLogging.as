[Setting category="General" name="Use Visual Image Indicator" description="Use a visual image indicator instead of the default text indicator"]
bool doVisualImageInducator = true;




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
    if (currentTime - triggeredTime < displayDuration) return true; 
    return false;
}

uint timeWoodTriggered = 0;
uint timeIce1Triggered = 0;
uint timeIce2Triggered = 0;

uint countdownTimeWood = 0;
uint countdownTimeIce1 = 0;
uint countdownTimeIce2 = 0;

void Render() {
    // Single texture conditions

    updateCountdown(countdownTimeWood, displayDuration, timeWoodTriggered);
    updateCountdown(countdownTimeIce1, displayDuration, timeIce1Triggered);
    updateCountdown(countdownTimeIce2, displayDuration, timeIce2Triggered);
    
    if (conditionForWood && countdownTimeWood > 0) {
        drawTexture(textureWood, 0);
    }

    if (conditionForIce1 && countdownTimeIce1 > 0) {
        drawTexture(textureIce1, 0);
    }

    if (conditionForIce2 && countdownTimeIce2 > 0) {
        drawTexture(textureIce2, 0);
    }

    // Combination conditions
    if (conditionForWood && conditionForIce1 && countdownTimeWood > 0 && countdownTimeIce1 > 0) {
        array<nvg::Texture@> textures = {textureWood, textureIce1};
        drawMultipleTextures(textures, 2);
    }

    if (conditionForWood && conditionForIce2 && countdownTimeWood > 0 && countdownTimeIce2 > 0) {
        array<nvg::Texture@> textures = {textureWood, textureIce2};
        drawMultipleTextures(textures, 2);
    }

    if (conditionForIce1 && conditionForIce2 && countdownTimeIce1 > 0 && countdownTimeIce2 > 0) {
        array<nvg::Texture@> textures = {textureIce1, textureIce2};
        drawMultipleTextures(textures, 2);
    }

    // Check if conditions are met to start the countdown
    if (conditionForWood && timeWoodTriggered == -1) {
        timeWoodTriggered = Time::Now;
        countdownTimeWood = displayDuration;
    }

    if (conditionForIce1 && timeIce1Triggered == -1) {
        timeIce1Triggered = Time::Now;
        countdownTimeIce1 = displayDuration;
    }

    if (conditionForIce2 && timeIce2Triggered == -1) {
        timeIce2Triggered = Time::Now;
        countdownTimeIce2 = displayDuration;
    }
}
