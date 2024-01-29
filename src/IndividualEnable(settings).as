// Water patch warnings

[Setting category="Enable Individual Warnings" name="Water 1 (The first water update)" description="Enable or dissable the first water warning"]
bool showWater1 = true;

// Ice patch warnings
[Setting category="Enable Individual Warnings" name="Ice 1 (The first Ice update)" description="Enable or dissable the first ice warning"]
bool showIce1 = true;

[Setting category="Enable Individual Warnings" name="Ice 2 (The second Ice update)" description="Enable or dissable the second ice warning"]
bool showIce2 = true;

[Setting category="Enable Individual Warnings" name="Ice 3 (The third Ice update)" description="Enable or dissable the third ice warning"]
bool showIce3 = false;

// Wood patch warnings
[Setting category="Enable Individual Warnings" name="Wood" description="Enable or dissable the wood warning"]
bool showWood1 = true;

// Bumper patch warnings
[Setting category="Enable Individual Warnings" name="Bumper" description="Enable or dissable the bumper warning"]
bool showBumper1 = true;



[Setting category="Enable Individual Warnings" name="Show Ice Generation" description="Shows the generation of ice instead the normal ice warning"]
bool showIceText = false;

[Setting category="Enable Individual Warnings" name="Show Ice Generation (text size)" description="Shows the generation of ice instead the normal ice warning"]
float showIceTextSize = 120.0f;

[Setting category="Enable Individual Warnings" name="Show Ice Generation (offset Y)" description="Shows the generation of ice instead the normal ice warning"]
int showIceTextOffestY = Draw::GetWidth() / 4.7;

[Setting category="Enable Individual Warnings" name="Show Ice Generation (offset X)" description="Shows the generation of ice instead the normal ice warning"]
int showIceTextOffestX = 100;




[Setting category="Enable Individual Warnings" name="Show other notifications with ice generation" description="A setting to show other notifications with the ice generation warning"]
bool showNotifyWarnWithIce = true;