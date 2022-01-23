class GhostInstance {
    bool haveGhost;
    MwId instance;
    MwId syncInstance;
    wstring name;
    string trigram;
    string countryPath;
    uint time;

    bool IsVisible {
        get {
            if (!haveGhost || PlaygroundScript is null) { return false; }
            return PlaygroundScript.Ghost_IsVisible(instance);
        }
    }

    bool IsFinished {
        get {
            if (!haveGhost || PlaygroundScript is null) { return false; }
            return PlaygroundScript.Ghost_IsReplayOver(instance);
        }
    }

    vec3 Position {
        get {
            if (!haveGhost || PlaygroundScript is null) { return vec3(); }
            return PlaygroundScript.Ghost_GetPosition(instance);
        }
    }

    GhostInstance(CGameGhostScript@ ghost, int ms) {
        if (ghost is null) {
            haveGhost = false;
        } else {
            if(ms != 0)
            {
                name = ghost.Nickname +"-"+ms+"ms";
            }
            else
            {
                name = ghost.Nickname +"-"+100+"ms";
            }
            trigram = ghost.Trigram;
            countryPath = ghost.CountryPath;

            log("Going to add a ghost... " + ghost.Nickname);

            if (Setting_Ghost_NamePrefix.Length > 0 && name.SubStr(0, Setting_Ghost_NamePrefix.Length) != Setting_Ghost_NamePrefix) {
                ghost.Nickname = Setting_Ghost_NamePrefix + name;
            }
            auto player = ControlledPlayer;
            if(ms != 0){
                instance = PlaygroundScript.Ghost_AddWithOffset(ghost, true, -ms);
            }
            else{
                instance = PlaygroundScript.Ghost_AddWithOffset(ghost, true, -100);
            }

            ghost.Nickname = name;

            log("added ghost instance: " + Text::Format("%08x", instance.Value) + ", " + instance.GetName() + ", " + ghost.Nickname);
            if (ghost.Result !is null)
                time = ghost.Result.Time;
            haveGhost = true;
        }
    }

    ~GhostInstance() {
        log("~GhostInstance()");
        RemoveGhost();
    }

    void RemoveGhost() {
        if (!haveGhost)
            return;
        if (PlaygroundScript !is null) {
            log("Cleaning up ghost " + instance.Value);
            PlaygroundScript.Ghost_Remove(instance);
        }
        haveGhost = false;
    }
}