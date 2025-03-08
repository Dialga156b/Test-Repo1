@echo off

start steam://rungameid/1388770

timeout /t 2 /nobreak >nul

powershell -NoProfile -Command "Add-Type -AssemblyName System.Windows.Forms; $n = New-Object System.Windows.Forms.NotifyIcon; $n.Icon = [System.Drawing.SystemIcons]::Information; $n.Visible = $true; $n.ShowBalloonTip(5000, 'Notification', 'get playing lil boy', [System.Windows.Forms.ToolTipIcon]::None); Start-Sleep -Seconds 6; $n.Dispose();"
