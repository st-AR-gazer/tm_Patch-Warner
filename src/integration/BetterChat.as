#if DEPENDENCY_BETTERCHAT

namespace PatchWarnerChat {

    string BuildMessage() {
        if (!_Game::IsMapLoaded() || !Physics::g_Result.ready) return "$<$bbb" + Icons::InfoCircle + "$>  No map loaded.";

        string body;
        for (uint i = 0; i < Physics::g_Result.results.Length; ++i) {
            const Physics::Rule@ r = Physics::g_Result.results[i].rule;
            string label = Prefs::GetLabel(r.name, r.name);
            if (body.Length > 0) body += ", ";
            body += "$<$ff0" + label + "$>";
        }

        if (body.Length == 0) return "$<$0a0" + Icons::Check + "$>  No special physics changes on this map.";

        return "$<$db4" + Icons::ExclamationTriangle + "$>  Physics warnings: " + body;
    }

    class PatchCommand : BetterChat::ICommand {
        bool m_broadcast;
        PatchCommand(bool sendToAll) { m_broadcast = sendToAll; }

        string Icon()        { return "\\$db4" + Icons::ExclamationTriangle; }
        string Description() { return m_broadcast
                                    ? "Posts current Patch-Warner warnings to chat."
                                    : "Shows current Patch-Warner warnings locally."; }

        void Run(const string &in args) {
            string msg = BuildMessage();
            if (m_broadcast) {
                BetterChat::SendChatMessage(msg);
            } else {
                BetterChat::AddSystemLine(msg);
            }
        }
    }

    void Register() {
        /* broadcast */
        BetterChat::RegisterCommand("patch", @PatchCommand(true));
        BetterChat::RegisterCommand("pw", @PatchCommand(true));
        /* local-only */
        BetterChat::RegisterCommand("lpatch", @PatchCommand(false));
        BetterChat::RegisterCommand("lpw", @PatchCommand(false));
    }

    void Unregister() {
        BetterChat::UnregisterCommand("patch");
        BetterChat::UnregisterCommand("pw");
        BetterChat::UnregisterCommand("lpatch");
        BetterChat::UnregisterCommand("lpw");
    }

}

void OnLoad_BetterChat() { PatchWarnerChat::Register(); }
void OnDestroy() { PatchWarnerChat::Unregister(); }

#endif
// ^^^ DEPENDENCY_BETTERCHAT