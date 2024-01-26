void drawGenIce(const string &in exeBuild, bool showNotifyWarnWithIce, const string &in logMessage, const string &in notifyMessage) {

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
    if (exeBuild >= "2022-05-19_15_03") {
        generation = 3;
        textColor = vec4(172, 210, 254, 255);
    } else if (exeBuild >= "2022-03-01_10_00") {
        generation = 2;
        textColor = vec4(178, 252, 252, 255);
    } else {
        generation = 1;
        textColor = vec4(76, 230, 255, 255);
    }

    switch (generation) {
        case 1:
            break;
        case 2:
            break;
        case 3:
            break;
        default:
            break;
    }
    // Textcolour/location

    // Draw
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