
CTrackMania@ App {
    get {
        return cast<CTrackMania@>(GetApp());
    }
}

CGameManiaAppTitle@ Menu {
    get {
        if (App.MenuManager is null) { return null; }
        return App.MenuManager.MenuCustom_CurrentManiaApp;
    }
}

CSmArenaRulesMode@ PlaygroundScript {
    get {
        return cast<CSmArenaRulesMode@>(App.PlaygroundScript);
    }
}

CSmArenaClient@ CurrentPlayground {
    get {
        return cast<CSmArenaClient@>(App.CurrentPlayground);
    }
}

CTrackManiaNetwork@ Network {
    get {
        return cast<CTrackManiaNetwork@>(App.Network);
    }
}

CGameManiaAppPlayground@ ClientManiaAppPlayground {
    get {
        if (Network is null) { return null; }
        return Network.ClientManiaAppPlayground;
    }
}

CGameTerminal@ GameTerminal {
    get {
        if (CurrentPlayground is null
            || CurrentPlayground.GameTerminals.Length < 1) {
            return null;
        }
        return CurrentPlayground.GameTerminals[0];
    }
}

CSmPlayer@ ControlledPlayer {
    get {
        if (GameTerminal is null) { return null; }
        return cast<CSmPlayer@>(GameTerminal.ControlledPlayer);
    }
}

CSmPlayer@ GUIPlayer {
    get {
        if (GameTerminal is null) { return null; }
        return cast<CSmPlayer@>(GameTerminal.GUIPlayer);
    }
}
