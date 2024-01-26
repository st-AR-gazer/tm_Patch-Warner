auto fidFile;

bool isMapLoaded = false;

bool conditionForIce1 = false;
bool conditionForIce2 = false;
bool conditionForIce3 = false;
bool conditionForWood = false;
bool conditionForBumper = false;

bool hasPlayedOnThisMap = false;

void Update(float dt) {
    time();
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

    auto scene = cast<ISceneVis@>(app.GameScene);
    if (scene is null) return;

    CSystemFidFile@ fidFile = cast<CSystemFidFile>(app.RootMap.MapInfo.Fid);
    if (fidFile is null) return;

    if (!isMapLoaded) {
        log("Map load check started...", LogLevel::Info, 59);
        OnMapLoad();
        isMapLoaded = true;
        log("Map load check completed.", LogLevel::Info, 62);
    }
}

void CheckAndUpdateCondition(const string &in exeBuild, const string &in minDate, const string &in maxDate, 
                             bool showFeatureFlag, bool imageDisplayConditionVariable, const string &in logMessage, 
                             const string &in notifyMessage, bool showIceText, bool showNotifyWarnWithIce) {
                                
    bool isBeforeMaxDate = maxDate.Length == 0 || exeBuild < maxDate;
    bool isAfterOrEqualMinDate = exeBuild >= minDate;

    if ((isBeforeMaxDate && isAfterOrEqualMinDate) || (maxDate.Length == 0 && exeBuild < minDate)) {
        if (!showFeatureFlag) {
            if (doVisualImageInducator) {
                if (showIceText) log(logMessage, LogLevel::Warn, 75);
                if (showIceText) return;

                imageDisplayConditionVariable = true;
            }
            if (showIceText) {
                drawGenIce(exeBuild, showNotifyWarnWithIce, logMessage, notifyMessage);
                return;
            }
            log(logMessage, LogLevel::Warn, 75);
            NotifyWarn(notifyMessage);
        }
    }
}

void OnMapLoad() {
    string exeBuild = GetExeBuildFromXML();
    log("Exe build: " + exeBuild, LogLevel::Info, 68);

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

    CheckAndUpdateCondition(exeBuild, "",                 "2022-05-19_15_03", showIce1,    conditionForIce1,   iceLogMsg1   , iceWarnMsg1,    showIceText, showNotifyWarnWithIce);
    CheckAndUpdateCondition(exeBuild, "2022-05-19_15_03", "2023-04-28_17_34", showIce2,    conditionForIce2,   iceLogMsg2   , iceWarnMsg2,    showIceText, showNotifyWarnWithIce);
    CheckAndUpdateCondition(exeBuild, "2023-04-28_17_34",                 "", showIce3,    conditionForIce3,   iceLogMsg3   , iceWarnMsg3,    showIceText, showNotifyWarnWithIce);
    CheckAndUpdateCondition(exeBuild, "2023-11-15_11_56",                 "", showWood1,   conditionForWood,   woodLogMsg1  , woodWarnMsg1,   false, false);
    CheckAndUpdateCondition(exeBuild, "2020-12-22_13_18",                 "", showBumper1, conditionForBumper, bumperLogMsg1, bumperWarnMsg1, false, false);

    CountdownTime = 10000;

    log("OnMapLoad function finished.", LogLevel::Info, 105);   
}
