namespace MapTracker {
    string oldMapUid = "";

    void MapMonitor() {
        while (true) {
            sleep(273);
            if (!_Game::IsPlayingMap()) { oldMapUid = ""; continue; }
            if (get_CurrentMapUID() == oldMapUid) continue;
            if (!get_CurrentMapUID() != "") { oldMapUid = ""; continue; }

            while (!_Game::IsPlayingMap()) yield();

            log("Map changed to: " + get_CurrentMapUID(), LogLevel::Debug, 15, "MapMonitor");

            /* -- Permissions gate -- */

            uint timeout = 500;
            uint startTime = Time::Now;
            AllowCheck::ConditionStatus status = AllowCheck::ConditionStatus::UNCHECKED;
            AllowCheck::InitializeAllowCheck();
            while (status == AllowCheck::ConditionStatus::UNCHECKED) {
                if (Time::Now - startTime > timeout) { NotifyWarn("Condition check timed out (" + timeout + " ms)."); break; }
                yield();
                status = AllowCheck::ConditionCheckStatus();
            }

            if (status == AllowCheck::ConditionStatus::ALLOWED) {

                Physics_RunChecks();

            } else {
                NotifyWarn("You cannot check for physics changes on this map: \n" + AllowCheck::DissalowReason());
            }

            oldMapUid = get_CurrentMapUID();
        }
    }
}

string get_CurrentMapUID() {
    if (_Game::IsMapLoaded()) {
        CTrackMania@ app = cast<CTrackMania>(GetApp());
        if (app is null) return "";
        CGameCtnChallenge@ map = app.RootMap;
        if (map is null) return "";
        return map.MapInfo.MapUid;
    }
    return "";
}

string get_CurrentMapName() {
    if (_Game::IsMapLoaded()) {
        CTrackMania@ app = cast<CTrackMania>(GetApp());
        if (app is null) return "";
        CGameCtnChallenge@ map = app.RootMap;
        if (map is null) return "";
        return map.MapInfo.Name;
    }
    return "";
}