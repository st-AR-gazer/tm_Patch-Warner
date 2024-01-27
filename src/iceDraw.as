void drawGenIce(const string &in exeBuild, bool showNotifyWarnWithIce, 
                const string &in logMessage, const string &in notifyMessage) {

    // Textcolour/location
    vec4 textColor;
    int generation = 0;

    if (exeBuild < "2022-05-19_15_03") {
        generation = 1;
        textColor = vec4(109, 229, 253, 255); // Transparancy gets overwriten later
    } 
    if (exeBuild >= "2022-05-19_15_03" && exeBuild < "2023-04-28_17_34") {
        generation = 2;
        textColor = vec4(177, 209, 254, 255); // Transparancy gets overwriten later
    } 
    if (exeBuild > "2023-04-28_17_34") {
        generation = 3;
        textColor = vec4(186, 253, 252, 255); // Transparancy gets overwriten later
    }
    // Textcolour/location

    textColorForGenIce = textColor;
    generationForGenIce = generation;

    if (!showIceText) {
        shouldRenderGenIce = false;
        return;
    }

    shouldRenderGenIce = true;

    log(logMessage, LogLevel::Warn, 32);
}

bool shouldRenderGenIce = false;
vec4 textColorForGenIce;
int generationForGenIce;

void renderGenIce() {
    if (!shouldRenderGenIce || CountdownTime <= 0) return;

    // float totalDuration = 8000;
    // float fadeDuration = 1;

    // float transparency = calcTransparency(totalDuration, fadeDuration);
    float transparency = 1.0f;
    if (CountdownTime < 2000) { transparency = 0.0f; }

    textColorForGenIce.w = transparency * textColorForGenIce.w;

    nvg::BeginPath();
    nvg::FontSize(120.0);
    nvg::FillColor(textColorForGenIce);
    nvg::Text(vec2(Draw::GetWidth() / 4.7, 100), "Gen " + generationForGenIce);
    nvg::ClosePath();
}