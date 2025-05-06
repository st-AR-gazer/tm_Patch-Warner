/* core/Preferences.as
   ───────────────────
   Persist per-patch settings to JSON files.

   • enabled state  → PatchWarnerPrefs.json
   • custom label   → PatchWarnerLabels.json
*/
namespace Prefs {

    /* file names ------------------------------------------------------- */
    const string kEnabledFile = IO::FromStorageFolder("PatchWarnerPrefs.json");
    const string kLabelFile   = IO::FromStorageFolder("PatchWarnerLabels.json");

    /* dictionaries in memory ------------------------------------------- */
    dictionary g_enabled;   // rule → bool
    dictionary g_label;     // rule → string

    /* ── enabled state ───────────────────────────────────────────────── */
    bool GetEnabled(const string &in rule, bool defVal = true) {
        return g_enabled.Exists(rule) ? bool(g_enabled[rule]) : defVal;
    }
    void SetEnabled(const string &in rule, bool state) {
        g_enabled[rule] = state;  SaveEnabled();
    }
    void LoadEnabled() {
        if (!IO::FileExists(kEnabledFile)) return;
        Json::Value j = Json::FromFile(kEnabledFile);
        if (j.GetType() != Json::Type::Object) return;
        auto keys = j.GetKeys();
        for (uint i = 0; i < keys.Length; ++i)
            g_enabled[keys[i]] = bool(j[keys[i]]);
    }
    void SaveEnabled() {
        Json::Value root = Json::Object();
        array<string> keys = g_enabled.GetKeys();
        for (uint i = 0; i < keys.Length; ++i)
            root[keys[i]] = Json::Value(bool(g_enabled[keys[i]]));
        Json::ToFile(kEnabledFile, root);
    }

    /* ── custom label -------------------------------------------------- */
    string GetLabel(const string &in rule, const string &in defVal) {
        return g_label.Exists(rule) ? string(g_label[rule]) : defVal;
    }
    void SetLabel(const string &in rule, const string &in label) {
        if (label == "") g_label.Delete(rule);
        else             g_label[rule] = label;
        SaveLabels();
    }
    void LoadLabels() {
        if (!IO::FileExists(kLabelFile)) return;
        Json::Value j = Json::FromFile(kLabelFile);
        if (j.GetType() != Json::Type::Object) return;
        auto keys = j.GetKeys();
        for (uint i = 0; i < keys.Length; ++i)
            g_label[keys[i]] = string(j[keys[i]]);
    }
    void SaveLabels() {
        Json::Value root = Json::Object();
        array<string> keys = g_label.GetKeys();
        for (uint i = 0; i < keys.Length; ++i)
            root[keys[i]] = Json::Value(string(g_label[keys[i]]));
        Json::ToFile(kLabelFile, root);
    }

    /* ── apply on plugin load ----------------------------------------- */
    void ApplyToRules() {
        for (uint i = 0; i < Physics::RULES.Length; ++i) {
            auto@ r = Physics::RULES[i];
            r.enabled = GetEnabled(r.name, r.enabled);
        }
    }
}
