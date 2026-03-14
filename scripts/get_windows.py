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
DEBUG = os.environ.get("KWIN_PUPA_DEBUG") == "1"
DEBUG_FILE = "/tmp/kwin_pupa_windows_debug.txt"

def log(msg):
    if DEBUG:
        with open(DEBUG_FILE, "a", encoding="utf-8") as f:
            f.write(msg + "\n")

def get_list_of_windows(script_path):
    script_path = os.path.abspath(script_path)
    datetime_now = datetime.now()
    try:
        log("loadScript: " + script_path)
        out = subprocess.run(
            ["dbus-send", "--print-reply", "--dest=org.kde.KWin",
             "/Scripting", "org.kde.kwin.Scripting.loadScript", "string:" + script_path],
            capture_output=True, text=True, timeout=5
        )
        if DEBUG:
            log("loadScript returncode=%s stdout=%r stderr=%r" % (out.returncode, out.stdout[:500] if out.stdout else "", out.stderr[:300] if out.stderr else ""))
        if out.returncode != 0:
            return []

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
        log("script_obj=" + script_obj)
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

        time.sleep(0.3)

        def parse_window_lines(lines):
            result = []
            for line in lines:
                line = line.strip()
                if line.startswith("js:"):
                    line = line[3:].strip()
                if "\t" in line and not line.startswith("error"):
                    parts = line.split("\t", 1)
                    result.append({"id": parts[0].strip(), "title": (parts[1].strip() if len(parts) > 1 else "") or "Pencere"})
                elif line and not line.startswith("error") and not line.startswith("method ") and "KWIN_PUPA" not in line:
                    result.append({"id": str(len(result)), "title": line or "Pencere"})
            return result

        # 1) Önce log dosyasından oku (startup.sh ile tee kullanılıyorsa)
        log_path = os.environ.get("KWIN_PUPA_STDOUT_LOG", "/tmp/kwin_pupa_stdout.log")
        if os.path.isfile(log_path):
            try:
                with open(log_path, "r", encoding="utf-8", errors="ignore") as f:
                    content = f.read()
                if "KWIN_PUPA_WINDOWS_START" in content and "KWIN_PUPA_WINDOWS_END" in content:
                    start = content.rfind("KWIN_PUPA_WINDOWS_START") + len("KWIN_PUPA_WINDOWS_START")
                    end = content.rfind("KWIN_PUPA_WINDOWS_END")
                    block = content[start:end].strip()
                    lines = [l.strip() for l in block.split("\n") if l.strip()]
                    result = parse_window_lines(lines)
                    if result:
                        return result
            except Exception as e:
                if DEBUG:
                    log("log file read: " + str(e))

        # 2) journalctl yedek
        since = datetime_now.strftime("%Y-%m-%d %H:%M:%S")
        for since_arg in [since, "1 min ago"]:
            out = subprocess.run(
                ["journalctl", "_COMM=kwin_wayland", "-o", "cat", "--since", since_arg, "-n", "150", "--no-pager"],
                capture_output=True, text=True, timeout=5
            )
            if out.returncode != 0:
                continue
            lines = (out.stdout or "").rstrip().split("\n")
            result = parse_window_lines(lines)
            if result:
                return result
        return []
    except Exception as e:
        if DEBUG:
            log("exception: " + str(e))
        return []

if __name__ == "__main__":
    script_path = sys.argv[1] if len(sys.argv) > 1 else DEFAULT_SCRIPT
    print(json.dumps(get_list_of_windows(script_path)))
