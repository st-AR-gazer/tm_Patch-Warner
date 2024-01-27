auto fidFile;

bool isMapLoaded = false;

bool conditionForIce1 = false;
bool conditionForIce2 = false;
bool conditionForIce3 = false;
bool conditionForWood = false;
bool conditionForBumper = false;

bool hasPlayedOnThisMap = false;

void Update(float dt) {
    // log("" + CountdownTime, LogLevel::Info, 13);
    time();
    renderGenIce();

    if (showIceText) {
        doVisualImageInducator = false;
    }
}

void Main() {
    loadTextures();
    while (true) {
        MapCheck();
        sleep(500);
    }
}

void MapCheck() {

    CTrackMania@ app = cast<CTrackMania>(GetApp());
    if (app is null) return;

    auto playground = cast<CSmArenaClient>(app.CurrentPlayground);
    if (playground is null || playground.Arena.Players.Length == 0) {
        isMapLoaded = false;
        conditionForIce1 = false;
        conditionForIce2 = false;
        conditionForIce3 = false;
        conditionForWood = false;
        conditionForBumper = false;
        hasPlayedOnThisMap = false;
        return;
    }
    
    auto script = cast<CSmScriptPlayer>(playground.Arena.Players[0].ScriptAPI);
    if (script is null) return;

    ISceneVis@ scene = cast<ISceneVis@>(app.GameScene);
    if (scene is null) return;

    CSystemFidFile@ fidFile = cast<CSystemFidFile>(app.RootMap.MapInfo.Fid);
    if (fidFile is null) {
        isMapLoaded = false;
        conditionForIce1 = false;
        conditionForIce2 = false;
        conditionForIce3 = false;
        conditionForWood = false;
        conditionForBumper = false;
        hasPlayedOnThisMap = false;
        return;
    }
    
    if (!isMapLoaded) {
        log("Map load check started...", LogLevel::Info, 62);
        OnMapLoad();
        isMapLoaded = true;
        log("Map load check completed.", LogLevel::Info, 65);
    }
}

void CheckAndUpdateCondition(const string &in exeBuild, const string &in minDate, const string &in maxDate, 
                             const string &in currentWarn, bool showFeatureFlag, bool &out specificConditionVariable, 
                             const string &in logMessage, const string &in notifyMessage, bool showIceText, 
                             bool showNotifyWarnWithIce) {
    
    bool isBeforeMaxDate = maxDate == "" || exeBuild < maxDate;
    bool isAfterOrEqualMinDate = exeBuild >= minDate;

    if ((isAfterOrEqualMinDate && isBeforeMaxDate) || (exeBuild < minDate && maxDate == "") || (exeBuild < maxDate && minDate == "")) {
        if (showFeatureFlag) {
            if (doVisualImageInducator && !showIceText) {
                specificConditionVariable  = true;
                return;
            } 
            if (showIceText) {
                drawGenIce(exeBuild, showNotifyWarnWithIce, logMessage, notifyMessage);
                if (!showNotifyWarnWithIce) return;
                if (currentWarn == "Wood")   { NotifyWarn(notifyMessage); } 
                if (currentWarn == "Bumper") { NotifyWarnBumper(notifyMessage); }
                return;
            }
            if (!showIceText) {
                if (currentWarn == "Ice1")   { NotifyWarnIce(notifyMessage); } 
                if (currentWarn == "Ice2")   { NotifyWarnIce2(notifyMessage); }
                if (currentWarn == "Ice3")   { NotifyWarnIce3(notifyMessage); } 
            }
            if (currentWarn == "Wood")   { NotifyWarn(notifyMessage); } 
            if (currentWarn == "Bumper") { NotifyWarnBumper(notifyMessage); }

            log(logMessage, LogLevel::Warn, 97);
            return;
            
        }
    }

    specificConditionVariable = false;
}


void OnMapLoad() {
    string exeBuild = GetExeBuildFromXML();
    log("Exe build: " + exeBuild, LogLevel::Info, 108);

    CountdownTime = 10000;

    string iceLogMsg1     = "The exebuild is less than 2022-05-19_15_03. Warning ice physics-1.";
    string iceLogMsg2     = "The exebuild falls between 2022-05-19_15_03 and 2023-04-28_17_34. Warning ice physics-2.";
    string iceLogMsg3     = "The exebuild is more than 2023-04-28_17_34. Warning ice physics-3";
    string woodLogMsg1    = "The exebuild is less than 2023-11-15_11_56. Warning wood physics-1.";
    string bumperLogMsg1  = "The exebuild is less than 2020-12-22_13_18. Warning bumper physics-1."; 

    string iceWarnMsg1    = "This map's exeBuild: '" + exeBuild + "' indicates that it was uploaded BEFORE the first ice update, the medal times may be affected.";
    string iceWarnMsg2    = "This map's exeBuild: '" + exeBuild + "' falls BETWEEN the two ice updates, the medal times may be affected.";
    string iceWarnMsg3    = "This map's exeBuild: '" + exeBuild + "' indicates that it was uploaded AFTER the latest ice update, the medal times are not affected, but it's nice to know anyway.";
    string woodWarnMsg1   = "This map's exeBuild: '" + exeBuild + "' indicates that this map was uploaded BEFORE the wood update, all wood on this map will behave like tarmac (road).";
    string bumperWarnMsg1 = "This map's exeBuild: '" + exeBuild + "' indicates that it was uploaded BEFORE the bumper update, the medal times may be affected.";

    CheckAndUpdateCondition(exeBuild, "",                 "2022-05-19_15_03", "Ice1",   showIce1,    conditionForIce1,   iceLogMsg1,    iceWarnMsg1,    showIceText, showNotifyWarnWithIce);
    CheckAndUpdateCondition(exeBuild, "2022-05-19_15_03", "2023-04-28_17_34", "Ice2",   showIce2,    conditionForIce2,   iceLogMsg2,    iceWarnMsg2,    showIceText, showNotifyWarnWithIce);
    CheckAndUpdateCondition(exeBuild, "2023-04-28_17_34", "9999-99-99_99_99", "Ice3",   showIce3,    conditionForIce3,   iceLogMsg3,    iceWarnMsg3,    showIceText, showNotifyWarnWithIce);
    CheckAndUpdateCondition(exeBuild, "",                 "2023-11-15_11_56", "Wood",   showWood1,   conditionForWood,   woodLogMsg1,   woodWarnMsg1,   showIceText, showNotifyWarnWithIce);
    CheckAndUpdateCondition(exeBuild, "",                 "2020-12-22_13_18", "Bumper", showBumper1, conditionForBumper, bumperLogMsg1, bumperWarnMsg1, showIceText, showNotifyWarnWithIce);

    log(conditionForBumper + " bumper, " + conditionForWood + " wood, " + conditionForIce1 + " ice1, " + conditionForIce2 + " ice2, " + conditionForIce3 + " ice3", LogLevel::Info, 128);

    log("OnMapLoad function finished.", LogLevel::Info, 131);   
}
