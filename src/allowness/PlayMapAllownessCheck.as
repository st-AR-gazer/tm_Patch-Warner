//  ___ _           __  __           _                 _     _   _ _                             __  __         _ 
// | _ \ |__ _ _  _|  \/  |__ _ _ __| |   ___  __ __ _| |   /_\ | | |_____ __ ___ _  ___ ______ |  \/  |___  __| |
// |  _/ / _` | || | |\/| / _` | '_ \ |__/ _ \/ _/ _` | |  / _ \| | / _ \ V  V / ' \/ -_|_-<_-< | |\/| / _ \/ _` |
// |_| |_\__,_|\_, |_|  |_\__,_| .__/____\___/\__\__,_|_| /_/ \_\_|_\___/\_/\_/|_||_\___/__/__/ |_|  |_\___/\__,_|
//             |__/            |_|                                                                                
//  GAMEMODE ALLOWNESS MOD

namespace PlayMapAllowness {

    class PlayMapAllowness : AllowCheck::IAllownessCheck {
        bool isAllowed = false;
        bool initialized = false;
        
        void Initialize() {
            OnMapLoad();
            initialized = true;
        }
        bool IsInitialized() { return initialized; }
        bool IsConditionMet() { return isAllowed; }
        string GetDisallowReason() { return isAllowed ? "" : "Cannot check for physics changes, you do not have permissions to play local maps."; }

        // 

        void OnMapLoad() {
            isAllowed = Permissions::PlayLocalMap();
            if (!isAllowed && GetDisallowReason() != "") log("Cannot check for physics changes, you do not have permissions to play local maps.", LogLevel::Warn, 26, "OnMapLoad");
        }  
    }

    AllowCheck::IAllownessCheck@ CreateInstance() {
        return PlayMapAllowness();
    }

}