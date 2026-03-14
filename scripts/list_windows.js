// KWin script: liste pencereleri (Plasma 6: windowList)
// Çıktı KWIN_PUPA_STDOUT_LOG veya journal'dan okunur
print('KWIN_PUPA_WINDOWS_START');
try {
    var list = typeof workspace.windowList === 'function' ? workspace.windowList() : workspace.clientList();
    for (var i = 0; i < list.length; i++) {
        var w = list[i];
        var cap = w.caption || w.title || '';
        var id = w.internalId !== undefined ? String(w.internalId) : String(i);
        print(id + '\t' + cap);
    }
} catch (e) {
    print('error\t' + e);
}
print('KWIN_PUPA_WINDOWS_END');
