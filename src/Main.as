void Main() {
#if DEPENDENCY_BETTERCHAT
    OnLoad_BetterChat();
#endif

    Prefs::LoadEnabled();
    Prefs::LoadLabels();
    Prefs::ApplyToRules();
    
    ImageAssets::LoadTextures();
    startnew(MapTracker::MapMonitor);
}