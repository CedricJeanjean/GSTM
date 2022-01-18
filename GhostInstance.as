/*
todo: bug 

Weird observation, every 65th time you add a specific ghost, it is impossible to
remove.

When you add a ghost it will get an id like 2. When you remove then add the same
ghost it will get an id like 0x01000002 and then 0x02000002, 0x03000002,
0x04000002...

It doesn't matter if you redownload the same ghost and get a new
CGhostGameScript instance, successive adds of the same ghost will end up with
this behaviour (or maybe it's simply cached? nevermind using the Nadeo
leaderboard widget with the same ghost acquired from a different URL behaves the
same, even if you alternate between them)

When you get to 0x3f000002 and then re-add (the 65th time), it will wrap and the
ghost will successfully be added, and return the id 0x00000002

However when you attempt to remove this ghost it will silently fail, and the
ghost will stick around forever, (or until you call Ghost_RemoveAll(), which
also resets ids?)

After, in this example, the next re-added ghost will get the id 0x00000003
(generally the next available unprefixed-base-id-thing, I think) and behave
correctly until it wraps around again, creating another unremovable ghost

Nevermind, it also happens to ghosts from the Nadeo records widget

click click click click click click click

*/
#if DEBUG
int ghostCount = 0;
#endif
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
#if DEBUG
            // ghost.Nickname = "" + ghostCount++ + "-" + ghost.Trigram;
#endif
            log("Going to add a ghost... " + ghost.Nickname);

            if (Setting_Ghost_NamePrefix.Length > 0 && name.SubStr(0, Setting_Ghost_NamePrefix.Length) != Setting_Ghost_NamePrefix) {
                ghost.Nickname = Setting_Ghost_NamePrefix + name;
            }
            auto player = ControlledPlayer;
            if(ms != 0)
            {
                instance = PlaygroundScript.Ghost_AddWithOffset(ghost, true, -ms);
            }
            else
            {
                instance = PlaygroundScript.Ghost_AddWithOffset(ghost, true, -100);
            }
            // ExploreNod(marker);
            ghost.Nickname = name;
            // poor ol ghostmgr why dont u work
            // syncInstance = PlaygroundScript.GhostMgr.Ghost_AddWaypointSynced(ghost, true);
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
            // PlaygroundScript.GhostMgr.Ghost_Remove(syncInstance);
            log("Cleaned up ghost " + instance.Value);
        }
        haveGhost = false;
    }
}