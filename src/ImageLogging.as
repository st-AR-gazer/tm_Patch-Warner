[Setting category="General" name="Use Visual Image Indicator" description="Use a visual image indicator instead of the default text indicator"]
bool doVisualImageInducator = true;


dictionary<string, nvg::Texture@> loadedTextures;

void LoadTexture(const string &in path) {
    if (!loadedTextures.exists(path)) {
        @loadedTextures[path] = nvg::LoadTexture(path);
    }
}

void UpdateAndDrawImage(nvg::Texture@ texture, float screenWidth, float screenHeight) {
    nvg::Reset();

    auto imgSize = vec2(322, 304);
    auto imgPos = vec2(screenWidth / 4 - imgSize.x / 2, screenHeight - screenHeight);

    nvg::BeginPath();
    nvg::Rect(imgPos, imgSize);
    nvg::FillPaint(nvg::TexturePattern(imgPos, imgSize, 0, @texture, 1.0f));
    nvg::Fill();
    nvg::ClosePath();
}

void LoadAllTextures() {
    LoadTexture("src/img/ice1.png");
    LoadTexture("src/img/ice2.png");
    LoadTexture("src/img/wood.png");
}

void NotifyVisualImageIce() {
    UpdateAndDrawImage(loadedTextures["src/img/ice1.png"], Draw::GetWidth(), Draw::GetHeight());
}

void NotifyVisualImageIce2() {
    UpdateAndDrawImage(loadedTextures["src/img/ice2.png"], Draw::GetWidth(), Draw::GetHeight());
}

void NotifyVisualImageWood() {
    UpdateAndDrawImage(loadedTextures["src/img/wood.png"], Draw::GetWidth(), Draw::GetHeight());
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

