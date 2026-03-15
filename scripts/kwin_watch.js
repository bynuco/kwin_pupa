// Persistent KWin script - pencere listesini kwinrc'ye yazar
// Grup: [Script-kwin_pupa_windows] içinde windowsJson anahtarı

function updateWindows() {
    var wins = workspace.stackingOrder;
    var active = workspace.activeWindow;
    var activeId = active ? String(active.internalId) : "";

    var result = [];
    for (var i = 0; i < wins.length; i++) {
        var w = wins[i];
        if (w.skipTaskbar || w.skipSwitcher) continue;

        var uuid  = String(w.internalId);
        var title = String(w.caption || "").replace(/\\/g, "\\\\").replace(/"/g, '\\"');
        var appid = String(w.resourceClass || "").toLowerCase();

        result.push({
            title: title,
            appId: appid,
            uuid: uuid,
            activated: (uuid === activeId)
        });
    }

    writeConfig("windowsJson", JSON.stringify(result));
}

workspace.windowAdded.connect(updateWindows);
workspace.windowRemoved.connect(updateWindows);
workspace.windowActivated.connect(updateWindows);

updateWindows();
