# kwin_pupa

Bottom bar’daki pencere listesi için oturumu `startup.sh` ile başlatın. KWin script çıktısı `tee` ile `/tmp/kwin_pupa_stdout.log` dosyasına yazılır; Python yardımcısı bu dosyadan okur. Liste boş kalırsa terminalde test için:

```bash
cd /path/to/kwin_pupa
KWIN_PUPA_DEBUG=1 python3 scripts/get_windows.py
# Hata ayıklama: cat /tmp/kwin_pupa_windows_debug.txt
```