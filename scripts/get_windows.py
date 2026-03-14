#!/usr/bin/env python3
"""KWin pencerelerini DBus + journalctl ile listeler. Çıktı: JSON array (id, title)."""
import subprocess
import sys
import json
import os
import re
import time
from datetime import datetime

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
DEFAULT_SCRIPT = os.path.join(SCRIPT_DIR, "list_windows.js")

def get_list_of_windows(script_path):
    datetime_now = datetime.now()
    try:
        # KWin script yükle, script numarasını al
        out = subprocess.run(
            ["dbus-send", "--print-reply", "--dest=org.kde.KWin",
             "/Scripting", "org.kde.kwin.Scripting.loadScript", "string:" + script_path],
            capture_output=True, text=True, timeout=5
        )
        if out.returncode != 0:
            return []
        # dbus cevabından script numarası veya object path (örn. "/Scripting/Script1")
        raw = out.stdout.strip()
        reg = "0"
        if "/Scripting/Script" in raw:
            m = re.search(r"/Scripting/Script(\d+)", raw)
            if m:
                reg = m.group(1)
        else:
            for line in reversed(raw.split("\n")):
                line = line.strip()
                if line.isdigit():
                    reg = line
                    break
                if "int32" in line or "uint" in line:
                    parts = line.split()
                    if len(parts) >= 2 and parts[-1].isdigit():
                        reg = parts[-1]
                        break

        script_obj = "/Scripting/Script" + reg
        subprocess.run(
            ["dbus-send", "--print-reply", "--dest=org.kde.KWin",
             script_obj, "org.kde.kwin.Script.run"],
            shell=False, timeout=2, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
        )
        subprocess.run(
            ["dbus-send", "--print-reply", "--dest=org.kde.KWin",
             script_obj, "org.kde.kwin.Script.stop"],
            shell=False, timeout=2, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
        )

        time.sleep(0.15)  # journalctl'un KWin çıktısını görmesi için

        since = datetime_now.strftime("%Y-%m-%d %H:%M:%S")
        out = subprocess.run(
            ["journalctl", "_COMM=kwin_wayland", "-o", "cat", "--since", since, "-n", "100"],
            capture_output=True, text=True, timeout=3
        )
        if out.returncode != 0:
            return []
        lines = out.stdout.rstrip().split("\n")
        result = []
        for line in lines:
            line = line.strip()
            if line.startswith("js:"):
                line = line[3:].strip()
            if "\t" in line and not line.startswith("error"):
                parts = line.split("\t", 1)
                result.append({"id": parts[0].strip(), "title": (parts[1].strip() if len(parts) > 1 else "") or "Pencere"})
            elif line and not line.startswith("error"):
                result.append({"id": str(len(result)), "title": line or "Pencere"})
        return result
    except Exception:
        return []

if __name__ == "__main__":
    script_path = sys.argv[1] if len(sys.argv) > 1 else DEFAULT_SCRIPT
    print(json.dumps(get_list_of_windows(script_path)))
