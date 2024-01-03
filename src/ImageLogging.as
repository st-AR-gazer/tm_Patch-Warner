[Setting category="General" name="Use Visual Image Indicator" description="Use a visual image indicator instead of the default text indicator"]
bool doVisualImageInducator = true;


float animationStartTime = 0;
bool isAnimating = false;

void UpdateAndDrawImage(const string &in imagePath, float screenWidth, float screenHeight) {
    // print("test");
    float animationDuration = 2.0;
    float stayDuration = 5.0;

    // Image dimensions
    float imageWidth = screenWidth / 9;
    float aspectRatio = 322.0f / 304.0f;
    float imageHeight = imageWidth * aspectRatio;

    float startY = 0;
    float endY = screenHeight / 4;

    float currentTime = Time::get_Now();
    float elapsedTime = currentTime - animationStartTime;
    float totalDuration = animationDuration + stayDuration;
    float progress = elapsedTime / animationDuration;

    if (elapsedTime > totalDuration) {
        isAnimating = false;
    }

    float yPos = startY;
    if (isAnimating) {
        if (elapsedTime <= animationDuration) {
            yPos = Math::Lerp(startY, endY, progress);
        } else {
            yPos = endY;
        }
    }

    nvg::Texture@ texture = nvg::LoadTexture(imagePath);
    nvg::Paint imgPaint = nvg::TexturePattern(vec2(0, yPos), vec2(100, 100), 0, texture, 1.0f);
    nvg::BeginPath();
    nvg::Rect(0, yPos, imageWidth, imageHeight);
    nvg::FillPaint(imgPaint);
    nvg::Fill();
}

void StartAnimation() {
    animationStartTime = Time::get_Now();
    isAnimating = true;
}

void NotifyVisualImageIce() {
    UpdateAndDrawImage("/src/img/ice1.png", Draw::GetWidth(), Draw::GetHeight());
    if (!hasPlayedOnThisMap) {
        StartAnimation();
        hasPlayedOnThisMap = true;
    }
}

void NotifyVisualImageIce2() {
    UpdateAndDrawImage("/src/img/ice2.png", Draw::GetWidth(), Draw::GetHeight());
    if (!hasPlayedOnThisMap) {
        StartAnimation();
        hasPlayedOnThisMap = true;
    }
}

void NotifyVisualImageWood() {
    UpdateAndDrawImage("/src/img/wood.png", Draw::GetWidth(), Draw::GetHeight());
    if (!hasPlayedOnThisMap) {
        StartAnimation();
        hasPlayedOnThisMap = true;
    }
}

void Render() {
    if (conditionForIce1) {
        NotifyVisualImageIce();
    }
    if (conditionForIce2) {
        NotifyVisualImageIce2();
    }
    if (conditionForWood) {
        NotifyVisualImageWood();
    }
}
