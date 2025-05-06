# Physics Update Checker (& warner)

Over the years Nadeo has been continuasly 'improving' the game with physics changes, and at this point, keeping track of what maps have what physics can become pretty combersome... So, I decided to make this plugin as a a solution to this problem!

---

## What the plugin does

| ✓                                                                                                                                                                           | Feature |
| ---------------------------------------------------------------------------------------------------------------------- | ------- |
| **Auto-detects** every loaded map and compares its *exeBuild* timestamp (and special flags such as legacy-wood) against a curated rule-set. |         |
| **Warns you instantly** when you are playing on a map where physics changes might have an inpact 														|         |
| **Very customisable** positions, sizes, timing, colours and per-patch on/off toggles for all possible patches can be edited |         |
| **Exports an API** so other plugins can query the current map's physics with one call.                                      |         |

---

## For developers

Patch Warner exposes a single shared function:

```angelscript
namespace PatchWarner {
    import string GetActivePhysicsChangesJSON() from "PatchWarner";
}
```

`GetActivePhysicsChangesJSON()` returns a JSON string like

```json
{
  "Water-1": true,
  "Ice-1":   false,
  "Ice-2":   false,
  "Ice-3":   true,
  "Wood":    true,
  "Bumper":  false
}
```
A definitive list of rule keys lives at the bottom of [`src/core/rules.as`](https://github.com/st-AR-gazer/tm_Patch-Warner/blob/main/src/core/rules.as).

* **true**  → that physics variant is active on the current map
* **false** → not active

Add `dependencies = ["PatchWarner"]` to your own plugin's `info.toml`, call the function, parse the JSON, and react however you like, be that showing the user a popup, a warning about a broken skip being avalible, or something completely different!

Feel free to use this in any of your other projects! <3
