void Main() {
    Prefs::LoadEnabled();
    Prefs::LoadLabels();
    Prefs::ApplyToRules();
    
    ImageAssets::LoadTextures();
    startnew(MapTracker::MapMonitor);
}