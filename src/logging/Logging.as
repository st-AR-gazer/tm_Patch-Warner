[Setting category="General" name="Length of displayed warning messages"]
int warningMessageLength = 6000;

void NotifyWarnIce(const string &in msg) { // Ice Gen1
    UI::ShowNotification("Patch Warner", msg + "\n" + "\\$3cf" + "████████████████████████████████████" + "\\$z", vec4(1, .5, .1, .5), warningMessageLength);
}
void NotifyWarnIce2(const string &in msg) { // Ice Gen2
    UI::ShowNotification("Patch Warner", msg + "\n" + "\\$bdf" + "████████████████████████████████████" + "\\$z", vec4(1, .5, .1, .5), warningMessageLength);
}
void NotifyWarnIce3(const string &in msg) { // Ice Gen2
    UI::ShowNotification("Patch Warner", msg + "\n" + "\\$afe" + "████████████████████████████████████" + "\\$z", vec4(1, .5, .1, .5), warningMessageLength);
}
// colors are fixed, they need to be ajusted for the new color scheme...

void NotifyWarn(const string &in msg) { // Wood
    UI::ShowNotification("Patch Warner", msg + "\n" + "\\$b86" + "████████████████████████████████████" + "\\$z", vec4(1, .5, .1, .5), warningMessageLength);
}

void NotifyWarnBumper(const string &in msg) { // Ice Gen2
    UI::ShowNotification("Patch Warner", msg + "\n" + "\\$654██████\\$fb0██████\\$654██████\\$654██████\\$b31██████\\$654██████" + "\\$z", vec4(1, .5, .1, .5), warningMessageLength);
}

void NotifyInfo(const string &in msg) {
    UI::ShowNotification("Patch Warner", msg, vec4(.3, 1, .1, .5), warningMessageLength);
}



enum LogLevel {
    Info,
    InfoG,
    Warn,
    Error
};

[Setting category="General" name="Show debug logs"]
bool doDevLogging = true;

void log(const string &in msg, LogLevel level = LogLevel::Info, int line = -1) {
    string lineInfo = line >= 0 ? "" + line : " ";
    if (doDevLogging) {
        switch(level) {
            case LogLevel::Info: 
                print("\\$0ff[INFO]  " + " \\$fff" + "\\$0cc"+lineInfo+" \\$fff" + msg); 
                break;
            case LogLevel::InfoG: 
                print("\\$0f0[INFO-G]" + " \\$fff" + "\\$0c0"+lineInfo+" \\$fff" + msg); 
                break;
            case LogLevel::Warn: 
                print("\\$ff0[WARN]  " + " \\$fff" + "\\$cc0"+lineInfo+" \\$fff" + msg); 
                break;
            case LogLevel::Error: 
                print("\\$f00[ERROR] " + " \\$fff" + "\\$c00"+lineInfo+" \\$fff" + msg); 
                break;
        }
    }
}