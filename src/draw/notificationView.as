namespace Notification {

    [Setting hidden] bool S_enableNotifyView = true;
    [Setting category="General" name="Notification duration (ms)" min="1000" max="15000"]
    int S_duration = 6000;

    void OnResultsReady(const string &in exeBuild) {
        if (!S_enableNotifyView) return;
        auto cache = Physics::g_Result;
        if (!cache.ready) return;

        for (uint i = 0; i < cache.results.Length; ++i) {
            Show(cache.results[i].rule, exeBuild);
        }
    }

    void Show(const Physics::Rule@ r, const string &in exeBuild) {

        string cond;
        if (r.minDate == "" && r.maxDate != "") {
            cond = "is lower than  " + r.maxDate;
        } else if (r.minDate != "" && r.maxDate == "") {
            cond = "is higher than " + r.minDate;
        } else if (r.minDate != "" && r.maxDate != "") {
            cond = "is between " + r.minDate + " and " + r.maxDate;
        } else {
            cond = "triggered a special detector";
        }
        string msg = "exeBuild " + exeBuild + " " + cond + ".";

        string bar;
        switch (r.icon) {
            case Physics::ViewIcon::PNG_WATER:  bar = "\\$ade██████\\$7fd██████\\$4ed██████\\$088██████\\$008██████\\$0ff██████"; break;
            case Physics::ViewIcon::PNG_ICE1:   bar = "\\$3cf████████████████████████████████████"; break;
            case Physics::ViewIcon::PNG_ICE2:   bar = "\\$bdf████████████████████████████████████"; break;
            case Physics::ViewIcon::PNG_ICE3:   bar = "\\$afe████████████████████████████████████"; break;
            case Physics::ViewIcon::PNG_WOOD:   bar = "\\$b86████████████████████████████████████"; break;
            case Physics::ViewIcon::PNG_BUMPER: bar = "\\$654██████\\$fb0██████\\$654██████\\$654██████\\$b31██████\\$654██████"; break;
            default:                            bar = "";
        }

        UI::ShowNotification("Patch Warner", msg + "\n" + bar + "\\$z",
                             vec4(1, .5, .1, .5), S_duration);
    }
}
