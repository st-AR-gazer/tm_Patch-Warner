[Setting category="General" name="Length of displayed warning messages"]
int warningMessageLength = 6000;

void NotifyWarnWater(const string &in msg) { // Water
    UI::ShowNotification("Patch Warner", msg + "\n" + "\\$ade██████\\$7fd██████\\$4ed██████\\$088██████\\$008██████\\$0ff██████" + "\\$z", vec4(1, .5, .1, .5), warningMessageLength);
}

void NotifyWarnIce(const string &in msg) { // Ice Gen1
    UI::ShowNotification("Patch Warner", msg + "\n" + "\\$3cf" + "████████████████████████████████████" + "\\$z", vec4(1, .5, .1, .5), warningMessageLength);
}
void NotifyWarnIce2(const string &in msg) { // Ice Gen2
    UI::ShowNotification("Patch Warner", msg + "\n" + "\\$bdf" + "████████████████████████████████████" + "\\$z", vec4(1, .5, .1, .5), warningMessageLength);
}
void NotifyWarnIce3(const string &in msg) { // Ice Gen3
    UI::ShowNotification("Patch Warner", msg + "\n" + "\\$afe" + "████████████████████████████████████" + "\\$z", vec4(1, .5, .1, .5), warningMessageLength);
}

// colors are fixed, they need to be ajusted for the new color scheme...

void NotifyWarn(const string &in msg) { // Wood
    UI::ShowNotification("Patch Warner", msg + "\n" + "\\$b86" + "████████████████████████████████████" + "\\$z", vec4(1, .5, .1, .5), warningMessageLength);
}

void NotifyWarnBumper(const string &in msg) { // Bumper
    UI::ShowNotification("Patch Warner", msg + "\n" + "\\$654██████\\$fb0██████\\$654██████\\$654██████\\$b31██████\\$654██████" + "\\$z", vec4(1, .5, .1, .5), warningMessageLength);
}

void NotifyInfo(const string &in msg) {
    UI::ShowNotification("Patch Warner", msg, vec4(.3, 1, .1, .5), warningMessageLength);
}



enum LogLevel {
    Info,
    InfoG,
    Warn,
    Error,
    Test,
    D,
    _
};

[Setting category="~DEV" name="Show debug logs"]
bool doDevLogging = false;


[Setting category="~DEV" name="Show Info logs (INFO)"]
bool showInfoLogs = true;

[Setting category="~DEV" name="Show InfoG logs (INFO-G)"]
bool showInfoGLogs = true;

[Setting category="~DEV" name="Show Warn logs (WARN)"]
bool showWarnLogs = true;

[Setting category="~DEV" name="Show Error logs (ERROR)"]
bool showErrorLogs = true;

[Setting category="~DEV" name="Show Test logs (TEST)"]
bool showTestLogs = true;

[Setting category="~DEV" name="Show Debug logs (D)"]
bool showDLogs = true;

[Setting category="~DEV" name="Show Placeholder logs (PLACEHOLDER)"]
bool showPlaceholderLogs = true;


void log(const string &in msg, LogLevel level = LogLevel::Info, int line = -1) {
    string lineInfo = line >= 0 ? (" " + line) : " ";
    bool doLog = false;

    switch(level) {
        case LogLevel::Info:  doLog = showInfoLogs;        break;
        case LogLevel::InfoG: doLog = showInfoGLogs;       break;
        case LogLevel::Warn:  doLog = showWarnLogs;        break;
        case LogLevel::Error: doLog = showErrorLogs;       break;
        case LogLevel::Test:  doLog = showTestLogs;        break;
        case LogLevel::D:     doLog = showDLogs;           break;
        case LogLevel::_:     doLog = showPlaceholderLogs; break;
    }

    if (!doDevLogging) return;

    if (doLog) {
        switch(level) {
            case LogLevel::Info:  print("\\$0ff[INFO]  " +       "\\$z" + "\\$0cc" + lineInfo + "\\$z" + msg); break;
            case LogLevel::InfoG: print("\\$0f0[INFO-G]" +       "\\$z" + "\\$0c0" + lineInfo + "\\$z" + msg); break;
            case LogLevel::Warn:  print("\\$ff0[WARN]  " +       "\\$z" + "\\$cc0" + lineInfo + "\\$z" + msg); break;
            case LogLevel::Error: print("\\$f00[ERROR] " +       "\\$z" + "\\$c00" + lineInfo + "\\$z" + msg); break;
            case LogLevel::Test:  print("\\$aaa[TEST]  " +       "\\$z" + "\\$aaa" + lineInfo + "\\$z" + msg); break;
            case LogLevel::D:     print("\\$777[D]     " +       "\\$z" + "\\$777" + lineInfo + "\\$z" + msg); break;
            case LogLevel::_:     print("\\$333[PLACEHOLDER] " + "\\$z" + "\\$333" + lineInfo + "\\$z" + msg); break;
        }
    }
}