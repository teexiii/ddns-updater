Set WshShell = CreateObject("WScript.Shell")
WshShell.Run chr(34) & "change-dns.bat" & Chr(34), 0
Set WshShell = Nothing
