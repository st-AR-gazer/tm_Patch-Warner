namespace Physics {

    enum ViewIcon { NONE, PNG_WATER, PNG_ICE1, PNG_ICE2, PNG_ICE3, PNG_WOOD, PNG_BUMPER }
    funcdef bool DetectorFunc();

    class Rule {
        string        name;
        string        minDate;
        string        maxDate;
        bool          includeMax;
        ViewIcon      icon;
        DetectorFunc@ altDetector;
        bool          enabled = true;

        Rule(const string &in _name,
             const string &in _minDate,
             const string &in _maxDate,
             bool          _includeMax,
             ViewIcon      _icon,
             DetectorFunc@ _alt = null)
        {
            name        = _name;
            minDate     = _minDate;
            maxDate     = _maxDate;
            includeMax  = _includeMax;
            icon        = _icon;
            @altDetector= _alt;
        }

        bool IsTriggered(const string &in exeBuild) const {
            if (!enabled) return false;
            if (altDetector !is null && altDetector()) return true;

            bool lo = (minDate == "" || exeBuild >= minDate);
            bool hi = includeMax
                    ? (maxDate == "" || exeBuild <= maxDate)
                    : (maxDate == "" || exeBuild <  maxDate);
            return lo && hi;
        }
    }

    /**
     * ─────────────────────────────────────────────────────────────
     * # How to add a rule
     *   Copy the template line below, then edit the values.
     *
     *   Constructor signature:
     *     @Rule( NAME , MIN_DATE , MAX_DATE , INCLUDE_MAX , ICON , ALT_DETECTOR? )
     *
     *   • NAME (string)            –  Use the pattern "[physics]-[iteration]".
     *   • MIN_DATE (string)        –  Inclusive lower-bound timestamp
     *                                 ("" means “no lower limit”).
     *   • MAX_DATE (string)        –  Upper-bound timestamp.
     *                                 ("" means “no upper limit”).
     *   • INCLUDE_MAX (bool)       –  If true the MAX_DATE itself is included
     *                                 in the range check (<=).  Otherwise < .
     *   • ICON (ViewIcon)          –  Which PNG to show in the UI.
     *   • ALT_DETECTOR (DetectorFunc) [optional]
     *                              –  Extra predicate for special cases
     *                                 (e.g. IsLegacyWood).  Pass null/@nullptr
     *                                 if not needed.
     *
     *   Dates MUST use the normalised format:
     *        YYYY-MM-DD_HH-MM-SS
     *   ...because Detectors::GetExeBuild() returns that.
     *
     * # Template
     *
     * @Rule("[physics]-[iter]", "2020-01-02_10-30-00", "2025-12-05_05-20-00", true,  ViewIcon::PNG_[type], null),
     *
     * ─────────────────────────────────────────────────────────────
     */

    const string k = ""; // No limit
    Rule@[] RULES = {
        @Rule("Water-1",  k,                    "2022-09-30_10-13-00", true,  ViewIcon::PNG_WATER),
        @Rule("Ice-1",    k,                    "2022-05-19_15-03-00", false, ViewIcon::PNG_ICE1),
        @Rule("Ice-2",   "2022-05-19_15-03-00", "2023-04-28_17-34-00", true,  ViewIcon::PNG_ICE2),
        @Rule("Ice-3",   "2023-04-28_17-34-00",  k,                    false, ViewIcon::PNG_ICE3),
        @Rule("Bumper-1", k,                    "2020-12-22_13-18-00", true,  ViewIcon::PNG_BUMPER),

        @Rule("Wood",     k,                    "2023-11-15_11-56-00", false, ViewIcon::PNG_WOOD,
              @Detectors::Wood::IsLegacyWood)
    };
}
