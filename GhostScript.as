class GhostScript {
    CGameGhostScript@ ghostScript = null;

    GhostInstance@ ghost = null;
    private int ms = 0;
    private string realname;

    private bool _wantGhost = true;
    bool wantGhost {
        get { return _wantGhost; }
        set {
            _wantGhost = value;
            if (_wantGhost) {
                AddGhostInstance();
            } else {
                RemoveGhostInstance();
            }
        }
    }

    bool haveGhost {
        get {
            if (this.ghost is null)
                return false;
            return this.ghost.haveGhost;
        }
    }

    private bool wantRelease = false;

    GhostScript(CGameGhostScript@ ghostScript, string realname, bool wantRelease = false) {
        @this.ghostScript = ghostScript;
        this.wantRelease = wantRelease;
        this.realname = realname;
    }

    GhostScript(CGameGhostScript@ ghostScript, int ms, bool wantRelease = false) {
        @this.ghostScript = ghostScript;
        this.wantRelease = wantRelease;
        this.ms = ms;
    }

    ~GhostScript() {
        log("~GhostScript()");
        ReleaseGhost();
    }

    void ReleaseGhost() {
        RemoveGhost();
        if (wantRelease && ghostScript !is null && PlaygroundScript !is null && PlaygroundScript.DataFileMgr !is null) {
            for (uint i = 0; i < PlaygroundScript.DataFileMgr.Ghosts.Length; i++) {
                if (PlaygroundScript.DataFileMgr.Ghosts[i].Id.Value == ghostScript.Id.Value) {
                    log("Releasing ghostscript " + ghostScript.Id.Value + " (" + ghostScript.Nickname + ")");
                    PlaygroundScript.DataFileMgr.Ghost_Release(ghostScript.Id);
                    break;
                }
            }
            @ghostScript = null;
        }
    }

    private void AddGhostInstance() {
        if (ghostScript !is null) {
            RemoveGhostInstance();
            ghostScript.Nickname = realname;
            @this.ghost = GhostInstance(ghostScript, ms);
        }
    }

    private void RemoveGhostInstance() {
        if (this.ghost !is null) {
            this.ghost.RemoveGhost();
        }
        @this.ghost = null;
    }

    void AddGhost() {
        RemoveGhost();
        wantGhost = true;
    }

    void RemoveGhost() {
        wantGhost = false;
    }

    void ModifyGhost(int ms){
        this.ms = ms;
        AddGhostInstance();
    }

    void Reset() {
        if (haveGhost) {
            RemoveGhostInstance();
            AddGhostInstance();
        }
    }
}
