void Main() {
#if DEPENDENCY_BETTERCHAT
    PatchWarnerChat::OnLoad_BetterChat();
#endif

    Prefs::LoadEnabled();
    Prefs::LoadLabels();
    Prefs::ApplyToRules();
    
    ImageAssets::LoadTextures();
    startnew(MapTracker::MapMonitor);
}