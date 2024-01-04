[Setting category="General" name="Use Visual Image Indicator" description="Use a visual image indicator instead of the default text indicator"]
bool doVisualImageInducator = true;


float animationStartTime = 0;
bool isAnimating = false;

void UpdateAndDrawImage(const string &in imagePath, float screenWidth, float screenHeight) {
    auto imageWidth = 322;
    auto imageHeight = 304;

    nvg::Texture@ texture = nvg::LoadTexture(imagePath);
    nvg::Paint imgPaint = nvg::TexturePattern(vec2(0, 0), vec2(322, 304), 0, texture, 1.0f);
    nvg::BeginPath();
    nvg::Rect(0, 0, imageWidth, imageHeight);
    nvg::FillPaint(imgPaint);
    nvg::Fill();
}

void NotifyVisualImageIce() {
    UpdateAndDrawImage("src/img/ice1.png", Draw::GetWidth(), Draw::GetHeight());
}

void NotifyVisualImageIce2() {
    UpdateAndDrawImage("src/img/ice2.png", Draw::GetWidth(), Draw::GetHeight());
}

void NotifyVisualImageWood() {
    UpdateAndDrawImage("src/img/wood.png", Draw::GetWidth(), Draw::GetHeight());
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
