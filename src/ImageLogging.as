[Setting category="General" name="Use Visual Image Indicator" description="Use a visual image indicator instead of the default text indicator"]
bool doVisualImageInducator = true;









/*nvg::Texture@ texture;

void loadTextureDirect(const string &in path) {
    @texture = nvg::LoadTexture(path);
}

void Render() {
    if (texture is null) {
        loadTextureDirect("src/img/wood.png");
    }

    vec2 pos = vec2(0, 0);
    vec2 size = vec2(500, 200);
    nvg::BeginPath();
    nvg::Rect(pos, size);
    nvg::FillPaint(nvg::TexturePattern(pos, size, 0.0f, @texture, 1.0f));
    nvg::Fill();
    nvg::ClosePath();
}*/

void UpdateAndDrawImage(const string &in imagePath, float screenWidth, float screenHeight) {
    imgSize = vec2(322, 304);
    imgPos = vec2(screenWidth / 4 - imgSize.x / 2, screenHeight - screenHeight);


    nvg::Texture@ texture = nvg::LoadTexture("src/img/wood.png");

    nvg::BeginPath();
    nvg::Rect(imgPos, imgSize);
    nvg::FillPaint(nvg::TexturePattern(imgPos, imgSize, 0, @texture, 1.0f));
    nvg::Fill();
    nvg::ClosePath();
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
    if (true) {
        NotifyVisualImageWood();
    }
}

