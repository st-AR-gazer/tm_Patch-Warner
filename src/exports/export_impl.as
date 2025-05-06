namespace PatchWarner {
    string GetActivePhysicsChangesJSON() {
        Json::Value root = Json::Object();

        if (_Game::IsMapLoaded() && Physics::g_Result.ready) {
            dictionary triggered;
            for (uint i = 0; i < Physics::g_Result.results.Length; ++i)
                triggered[Physics::g_Result.results[i].rule.name] = true;

            for (uint i = 0; i < Physics::RULES.Length; ++i) {
                string key = Physics::RULES[i].name;
                root[key]  = Json::Value(triggered.Exists(key));
            }
        } else {
            for (uint i = 0; i < Physics::RULES.Length; ++i)
                root[Physics::RULES[i].name] = Json::Value(false);
        }

        return Json::Write(root);
    }
}
