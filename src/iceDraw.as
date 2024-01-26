void drawGenIce(const string &in exeBuild, bool showNotifyWarnWithIce, 
                const string &in logMessage, const string &in notifyMessage) {

    // Location
    float screenWidth = Draw::GetWidth();
    float screenHeight = Draw::GetHeight();

    float xOffset = screenWidth * xOffsetDrawing;
    float yOffset = screenHeight / screenHeight - 1;

    yOffset += custYOffest * screenHeight;
    // Location

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

    float transparancy;
    if (CountdownTime > 8000) { // start 
        transparancy = 1.0f - ((CountdownTime - 8000) / 3000.0f);
    } else if (CountdownTime > 3000) { // middle
        transparancy = 1.0f;
    } else { // end
        transparancy = CountdownTime / 3000.0f;
    }
    transparancy = Math::Clamp(transparancy, 0.0f, 1.0f);

    textColor.w = transparancy * textColor.w;

    if (CountdownTime == 0) return;

    // Drawing the text with transparency
    nvg::BeginPath();
    nvg::FontSize(18.0);
    nvg::FillColor(textColor);
    nvg::TextAlign(nvg::Align::Left | nvg::Align::Top);
    nvg::Text(vec2(xOffset, yOffset), "Gen " + generation);
    nvg::ClosePath();

    if (showNotifyWarnWithIce) {
        NotifyWarn(notifyMessage);
    }
    log(logMessage, LogLevel::Warn, 81);
}