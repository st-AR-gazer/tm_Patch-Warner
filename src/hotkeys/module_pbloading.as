
namespace Hotkey_PatchWarnerNotificationModule {
    
    namespace Trigger_Internal {

        void ShowPatchWarnerNotification() { Physics_RunChecks(); }

    }

    class Module : Hotkeys::IHotkeyModule {
        string GetId() { return "Patch Warner UI Toggle"; }
        array<string> acts = {
            "Show Patch Warner Notification"
        };
        array<string> GetAvailableActions() { return acts; }

        string GetActionDescription(const string &in act) {
            if (act == "Show Patch Warner Notification") return "Displays the Patch Warner notification.";
            return "";
        }

        bool ExecuteAction(const string &in act, Hotkeys::Hotkey@ /*hk*/) {
            if (act == "Show Patch Warner Notification") { Trigger_Internal::ShowPatchWarnerNotification(); return true; }
            return false;
        }
    }

    Hotkeys::IHotkeyModule@ CreateInstance() { return Module(); }
    void Initialize() {
        const string PLUGIN = Meta::ExecutingPlugin().Name;
        @g_pbMod = Hotkey_PatchWarnerNotificationModule::CreateInstance();
        Hotkeys::RegisterModule(PLUGIN, g_pbMod);
    }
}

Hotkeys::IHotkeyModule@ g_pbMod;

// Plugin entry for this module
auto PatchWarnerNotificationmod_initializer = startnew(Hotkey_PatchWarnerNotificationModule::Initialize);
// Unload handler to unregister the module
class Hotkey_PatchWarnerNotificationModule_OnUnload { ~Hotkey_PatchWarnerNotificationModule_OnUnload() { if (g_pbMod !is null) Hotkeys::UnregisterModule(Meta::ExecutingPlugin().Name, g_pbMod); } }
Hotkey_PatchWarnerNotificationModule_OnUnload PatchWarnerNotificationmod_unloader;