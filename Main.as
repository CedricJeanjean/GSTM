/*
Exemple url:
Karjen 06 : https://trackmania.io/api/download/ghost/55098c6f-90a6-45e2-bcc4-8720426d14ae
Rotaker 06 : https://trackmania.io/api/download/ghost/27a2e892-1c81-4dc3-96f2-541094854a6a
*/

array<GhostScript@> temporaryGhosts;
string input = "";
bool triggerDownload = false;
bool windowVisible = false;
int ms = 100;

void AddTemporaryGhost(CGameGhostScript@ ghost) {
    string realname = ghost.Nickname;
    auto gs = GhostScript(ghost, realname, true);
    gs.wantGhost = true;
    temporaryGhosts.InsertLast(gs);
}

void AddTemporaryGhost(CGameGhostScript@ ghost, int ms) {
    auto gs = GhostScript(ghost, ms, true);
    gs.wantGhost = true;
    temporaryGhosts.InsertLast(gs);
}

void ClearTemporaryGhosts() {
    for (uint i = 0; i < temporaryGhosts.Length; i++) {
        temporaryGhosts[i].ReleaseGhost();
    }
    temporaryGhosts = {};
}

void ClearTemporaryGhosts(int i) {
    temporaryGhosts[i].ReleaseGhost();
}

void ModifyTemporyGhosts(int i, int ms)
{
    temporaryGhosts[i].ModifyGhost(ms);
}

CGameDataFileManagerScript@ TryGetDataFileMgr()
{
    CTrackMania@ app = cast<CTrackMania>(GetApp());
    if (app !is null)
    {
        CSmArenaRulesMode@ playgroundScript = cast<CSmArenaRulesMode>(app.PlaygroundScript);
        if (playgroundScript !is null)
        {
            CGameDataFileManagerScript@ dataFileMgr = cast<CGameDataFileManagerScript>(playgroundScript.DataFileMgr);
            if (dataFileMgr !is null)
            {
                return dataFileMgr;
            }
        }
    }
    return null;
}

void resetGhosts()
{
	auto player = ControlledPlayer;
	int startTime = (PlaygroundScript.Now - player.ScriptAPI.CurrentRaceTime)-100;
    PlaygroundScript.Ghosts_SetStartTime(startTime);
}

void addGhostNormalStart()
{
	auto dataFileMgr2 = TryGetDataFileMgr();
	CWebServicesTaskResult_GhostScript@ result = dataFileMgr2.Ghost_Download("", input);
	uint timeout = 20000;
	uint currentTime = 0;
	while (result.Ghost is null && currentTime < timeout)
	{
		currentTime += 100;
		sleep(100);
	}
	CGameGhostScript@ ghost = cast<CGameGhostScript>(result.Ghost);
	AddTemporaryGhost(ghost);
}

void Main() {
	int lastRaceTime = 1000000;
	while(true)
	{
        auto app = cast<CTrackMania>(GetApp());
        if (app.RootMap is null) {
            ClearTemporaryGhosts();
        }
        
        auto player = ControlledPlayer;
		if (player !is null) {
            lastRaceTime = raceTime;
        }

        if(triggerDownload)
        {
            addGhostNormalStart();
            triggerDownload = false;
        }
		sleep(200);
	}
}

void RenderMenu()
{
    if (UI::MenuItem("\\$999" + Icons::Download + "\\$z GSTM", "", windowVisible))
    {
        windowVisible = !windowVisible;
    }
}

void RenderInterface()
{
    if (windowVisible)
    {
        auto app = cast<CTrackMania>(GetApp());
        if (app.RootMap is null) {
			return;
		}

        UI::Begin("Ghost Start Time Modifier", windowVisible, UI::WindowFlags::NoCollapse | UI::WindowFlags::AlwaysAutoResize);
        UI::Text("Entrez l'url du ghost :");
        input = UI::InputText("Ghost URL",input);
        UI::SameLine();
        if (!triggerDownload && UI::Button("Create ghost"))
        {
            triggerDownload = true;
        }
        if(temporaryGhosts.Length != 0)
        {
            UI::Text("Current ghosts :");
        }
        
        for (uint i = 0; i < temporaryGhosts.Length; i++) {
            if(temporaryGhosts[i].ghost != null)
            {
                UI::Text(temporaryGhosts[i].ghost.name);
                UI::SameLine();
                if(UI::Button("Delete "+i))
                {
                    ClearTemporaryGhosts(i);
                }
                UI::SameLine();
                UI::Text("Delay : ");
                UI::SameLine();
                ms = UI::InputInt("ms : "+i,ms,1);
                UI::SameLine();
                if(UI::Button("Validate "+i))
                {
                    ModifyTemporyGhosts(i, ms);
                }
            }
        }

        UI::End();
    }
}