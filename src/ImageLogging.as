[Setting category="General" name="Use Visual Image Indicator" description="Use a visual image indicator instead of the default text indicator"]
bool doVisualImageInducator = true;


float animationStartTime = 0;
bool isAnimating = false;

void StartAnimation() {
    animationStartTime = Time::get_Now();
    isAnimating = true;
}

void UpdateAndDrawImage(const string &in imagePath, float screenWidth, float screenHeight) {
    print("test");
    // Image dimensions
    float imageWidth = screenWidth / 9;
    float aspectRatio = 322.0f / 304.0f;
    float imageHeight = imageWidth * aspectRatio;

    // Fixed position at (0,0)
    float startX = 0;
    float startY = 0;

    // Load and draw the image
    nvg::Texture@ texture = nvg::LoadTexture(imagePath);
    nvg::Paint imgPaint = nvg::TexturePattern(vec2(startX, startY), vec2(imageWidth, imageHeight), 0, texture, 1.0f);
    nvg::BeginPath();
    nvg::Rect(startX, startY, imageWidth, imageHeight);
    nvg::FillColor(vec4(255, 255, 255, 255));
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
