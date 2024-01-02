[Setting category="General" name="Use Visual Image Indicator" description="Use a visual image indicator instead of the default text indicator"]
bool doVisualImageInducator = true;


float animationStartTime = 0;
bool isAnimating = false;

void StartAnimation() {
    animationStartTime = Time::get_Now();
    isAnimating = true;
}

void UpdateAndDrawImage(const string &in imagePath, float screenWidth, float screenHeight) {
    // Image dimensions
    float imageWidth = screenWidth / 9;
    float aspectRatio = 322.0f / 304.0f;
    float imageHeight = imageWidth * aspectRatio;

    // Position calculations
    float startX = screenWidth / 4;
    float startY = -imageHeight;
    float endY = screenHeight / 4;

    // Time calculations
    float currentTime = Time::get_Now();
    float animationDuration = 5;
    float progress = Math::Min(1.0f, (currentTime - animationStartTime) / animationDuration);


    float yPos;
    if (isAnimating) {
        yPos = Math::Lerp(startY, endY, progress);
        if (progress >= 1.0f) {
            isAnimating = false;
        }
    } else {
        yPos = endY;
    }

    nvg::Texture@ texture = nvg::LoadTexture(imagePath);
    nvg::Paint imgPaint = nvg::TexturePattern(vec2(startX, yPos), vec2(imageWidth, imageHeight), 0, texture, 1.0f);
    nvg::BeginPath();
    nvg::Rect(startX, yPos, imageWidth, imageHeight);
    nvg::FillPaint(imgPaint);
    nvg::Fill();
}

void NotifyVisualImageIce() {
    UpdateAndDrawImage("/src/img/ice1.png", Draw::GetWidth(), Draw::GetHeight());
}

void NotifyVisualImageIce2() {
    UpdateAndDrawImage("/src/img/ice2.png", Draw::GetWidth(), Draw::GetHeight());
}

void NotifyVisualImageWood() {
    UpdateAndDrawImage("/src/img/wood.png", Draw::GetWidth(), Draw::GetHeight());
}
