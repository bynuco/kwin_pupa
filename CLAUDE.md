# Project Rules

## Genel
Bu proje bir KWin/Wayland masaüstü dağıtımıdır. Belirli bir bilgisayara özel yapılandırma yazılmaz; her şey taşınabilir (portable) olmalıdır.

## Yapılandırma Kuralları
- Sabit makine adı, kullanıcı adı, veya dosya yolu **yazma**. Bunlar için environment variable ya da dinamik değişken kullan.
- `WAYLAND_DISPLAY`, `XDG_RUNTIME_DIR` gibi değişkenler her zaman fallback ile yazılmalı (örn. `${WAYLAND_DISPLAY:-wayland-0}`).
- `/home/kullanıcıadı/...` gibi sabit path'ler yasak; `$HOME` veya script-relative path kullan.
