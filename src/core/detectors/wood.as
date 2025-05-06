namespace Detectors {
namespace Wood {
    bool   g_ready       = false;
    uint16 g_offMapFlags = 0xFFFF; // will be ChallengeParameters + 0x8

    bool IsLegacyWood() {
        if (!g_ready) Init();
        if (!g_ready || g_offMapFlags == 0xFFFF) return false;  // fallback

        CTrackMania@ app = cast<CTrackMania>(GetApp());
        if (app is null || app.RootMap is null) return false;

        uint flags = Dev::GetOffsetUint32(app.RootMap, g_offMapFlags);
        return (flags & 0x2) != 0;      // bit-1 → old-wood
    }

    void Init() {
        try {
            uint16 offChallengeParams = GetOffset("CGameCtnChallenge", "ChallengeParameters");
            g_offMapFlags = offChallengeParams + 0x8;   // +0x8 per Editor++
            g_ready = true;
        } catch {
            log("Wood detector: failed to resolve offsets – old-wood check disabled.", LogLevel::Warn, 23, "Init");
            g_ready = false;
        }
    }

    uint16 GetOffset(const string &in className, const string &in memberName) {
        const Reflection::MwClassInfo@ ty = Reflection::GetType(className);
        if (ty is null) log("Unknown type: " + className, LogLevel::Debug, 30, "GetOffset");

        const Reflection::MwMemberInfo@ mem = ty.GetMember(memberName);
        if (mem is null) log("Bad member: " + memberName, LogLevel::Debug, 33, "GetOffset");

        if (mem.Offset == 0xFFFF) log("Invalid offset (0xFFFF) for " + className + "::" + memberName, LogLevel::Debug, 35, "GetOffset");

        return mem.Offset;
    }
}
}

// Thank you XertroV for doing all the hard work with getting the offsets and such!
// Couldn't have done it without you :peepoHeart:!