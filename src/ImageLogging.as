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

void UpdateTime() {
    float currentFrameTime = Time::get_Now();
    float deltaTime = currentFrameTime - lastFrameTime;
    lastFrameTime = currentFrameTime;
    elapsedTime += deltaTime;
}

float elapsedTime = 0.0f;
float lastFrameTime = 0.0f;


void drawTexture(nvg::Texture@ texture, int index = 0) {
    log("Drawing texture", LogLevel::Info, 22);

    float aspectRatio = 304.0f / 322.0f;
    float screenWidth = Draw::GetWidth();
    float screenHeight = Draw::GetHeight();
    float imageSize = screenHeight * 0.2f;
    float imageWidth = imageSize * aspectRatio;

    float xOffset = screenWidth * 0.141f;
    float yOffset = (imageSize + 10.0f) * index;

    float animationDuration = 2.0f;
    float stayDuration = 4.0f;
    float totalDuration = animationDuration * 2 + stayDuration;
    
    float cycleTime = elapsedTime;
    while (cycleTime >= totalDuration) {
        cycleTime -= totalDuration;
    }

    float normalizedTime = cycleTime / totalDuration;
    
    if (normalizedTime < animationDuration / totalDuration) {
        xOffset = Math::Lerp(-imageWidth, screenWidth * 0.141f, normalizedTime / (animationDuration / totalDuration));
    } else if (normalizedTime < (animationDuration + stayDuration) / totalDuration) {
        xOffset = screenWidth * 0.141f;
    } else {
        xOffset = Math::Lerp(screenWidth * 0.141f, -imageWidth, (normalizedTime - (animationDuration + stayDuration) / totalDuration) / (animationDuration / totalDuration));
    }
    

    xOffset += (imageWidth + (imageWidth * 0.125f)) * index;

    auto pos = vec2(xOffset, yOffset); // some more logic is required here when animations are added (needs an offset)
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
        log("Condition for drawing texture met: Wood", LogLevel::Info, 49);
        drawTexture(textureWood, 0);
    } else if (conditionForIce1) {
        log("Condition for drawing texture met: Ice1", LogLevel::Info, 52);
        drawTexture(textureIce1, 0);
    } else if (conditionForIce2) {
        log("Condition for drawing texture met: Ice2", LogLevel::Info, 55);
        drawTexture(textureIce2, 0);
    }

    if (conditionForWood && conditionForIce1) {
        log("Condition for drawing texture met: Wood and Ice1", LogLevel::Info, 60);
        array<nvg::Texture@> textures = {textureWood, textureIce1};
        drawMultipleTextures(textures, 2);
    } else if (conditionForWood && conditionForIce2) {
        log("Condition for drawing texture met: Wood and Ice2", LogLevel::Info, 64);
        array<nvg::Texture@> textures = {textureWood, textureIce2};
        drawMultipleTextures(textures, 2);
    } else if (conditionForIce1 && conditionForIce2) { // cannot happen btw xdd
        log("Condition for drawing texture met: Ice1 and Ice2", LogLevel::Info, 68);
        array<nvg::Texture@> textures = {textureIce1, textureIce2};
        drawMultipleTextures(textures, 2);
    }
}
