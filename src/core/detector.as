namespace Physics {
    class Result { const Rule@ rule; }
    class ResultCache { bool ready = false; Result[] results; }
    ResultCache g_Result;
}

void Physics_RunChecks() {
    Physics::g_Result.ready = false;
    Physics::g_Result.results.Resize(0);

    string exeBuild = Detectors::GetExeBuild();
    log("ExeBuild: " + exeBuild, LogLevel::Debug, 14, "Physics_RunChecks");

    for (uint i = 0; i < Physics::RULES.Length; ++i) {
        const Physics::Rule@ r = Physics::RULES[i];
        if (r.IsTriggered(exeBuild)) {
            Physics::Result res; @res.rule = r;
            Physics::g_Result.results.InsertLast(res);
        }
    }
    Physics::g_Result.ready = true;

    Notification::OnResultsReady(exeBuild);
    ImageView::OnMapChanged();
}
