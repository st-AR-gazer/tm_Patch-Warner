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
    if (fidFile is null) { 
        // log("fidFile is null in MapCheck.", LogLevel::Warn, 48);
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
        log("Map load check started...", LogLevel::Info, 59);
        OnMapLoad();
        isMapLoaded = true;
        log("Map load check completed.", LogLevel::Info, 62);
    }
}

void OnMapLoad() {
    string exeBuild = GetExeBuildFromXML();
    log("Exe build: " + exeBuild, LogLevel::Info, 68);

    if (exeBuild < "2022-05-19_15_03") {
        if (!showIce1) {
            if (doVisualImageInducator) {
                conditionForIce1 = true;
            } else {
                log("The exebuild is less than 2022-05-19_15_03. Warning ice physics-1.", LogLevel::Warn, 74);
                NotifyWarnIce("This map's exeBuild: '" + exeBuild + "' indicates that it was uploaded BEFORE the first ice update, the medal times may be affected.");
            }
        }
    }
    if (exeBuild < "2023-04-28_17_34" && exeBuild >= "2022-05-19_15_03") {
        if (!showIce2) {
            if (doVisualImageInducator) {
                conditionForIce2 = true;

            } else {
                log("The exebuild falls between 2023-04-28_17_34 and 2022-05-19_15_03. Warning ice physics-2.", LogLevel::Warn, 83);
                NotifyWarnIce2("This map's exeBuild: '" + exeBuild + "' falls BETWEEN the two ice updates, the medal times may be affected.");
            }
        }
    }
    if (exeBuild > "2022-05-19_15_03") {
        if (!showIce3) {
            if (doVisualImageInducator) {
                conditionForIce3 = true;

            } else {
                log("The exebuild is less than 2022-05-19_15_03. Warning ice physics-1.", LogLevel::Warn, 74);
                NotifyWarnIce3("This map's exeBuild: '" + exeBuild + "' indicates that it was uploaded AFTER the latest ice update, the medal times are not affected, but it's nice to know anyway.");
            }
        }
    }
    // Ice ^^^

    if (exeBuild < "2020-12-22_13_18") {
        if (!showBumper1) {
            if (doVisualImageInducator) {
                conditionForBumper = true;
            } else {
                log("The exebuild is less than 2020-12-22_13_18. Warning bumper physics.", LogLevel::Warn, 91);
                NotifyWarnBumper("This map's exeBuild: '" + exeBuild + "' indicates that it was uploaded BEFORE the the bumper update, the medal times may be affected.");
            }
        }
    }
    // Bumper ^^^

    if (exeBuild < "2023-11-15_11_56") {
        if (!showWood1) {
            if (doVisualImageInducator) {
                conditionForWood = true;
            } else {
                log("The exebuild is less than 2023-11-15_11_56. Warning wood physics.", LogLevel::Warn, 99);
                NotifyWarn("This map's exeBuild: '" + exeBuild + "' indicates that this map was uploaded BEFORE the wood update, all wood on this map will behave like tarmac (road).");
            }
        }
    }
    // Wod

    CountdownTime = 10000;

    log("OnMapLoad function finished.", LogLevel::Info, 105);
    
}