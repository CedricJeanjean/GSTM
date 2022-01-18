// Openplanet settings:

[Setting name="Enable scrubbing when spectating with the records widget"]
bool Setting_Ghost_RecordsSpectate = true;

[Setting name="Add your current race when scrubbing"]
bool Setting_Ghost_AddCurrentRace = true;

[Setting name="Remove launched respawns from current race ghost"]
bool Setting_Ghost_TruncateCPs = false;

[Setting name="Precision Window Time"]
float Setting_Slider_PrecisionWindow = 10;

[Setting name="Precision Hold Key"]
VirtualKey Setting_Slider_PrecisionKey = VirtualKey::Control;

// OSD
[Setting name="Hide OSD while moving" description="Hide the OSD while your car is moving regardless of whether or not the mouse has moved, it will only be visible when your car is stopped"]
bool Setting_OSD_Hide = false;

[Setting name="Slider X" min=0 max=1]
float Setting_OSD_Pos_X = 0.22;

[Setting name="Slider Y" min=0 max=1]
float Setting_OSD_Pos_Y = 0.95;

[Setting name="Slider Bar Width"]
float Setting_OSD_Pos_W = 690.0;

[Setting name="Slider Bar Height"]
float Setting_OSD_Pos_H = 20.0;

[Setting name="Slider Font Size"]
float Setting_OSD_FontSize = 16.0;

[Setting name="Slider Button Width"]
float Setting_OSD_ButtWidth = 30.0;

[Setting name="Slider Button Height"]
float Setting_OSD_ButtHeight = 35.0;

[Setting name="Ghost nickname prefix"]
string Setting_Ghost_NamePrefix = "$cdf$i";

[Setting name="Current race nickname"]
string Setting_Ghost_CurrentRaceName = "Current race";
