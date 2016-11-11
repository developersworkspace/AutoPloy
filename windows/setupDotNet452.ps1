if ($PSVersionTable.PSVersion.Major -lt 5){
    Write-Host "Powershell version 5+ is required"
    return
}

iwr "https://download.microsoft.com/download/E/2/1/E21644B5-2DF2-47C2-91BD-63C560427900/NDP452-KB2901907-x86-x64-AllOS-ENU.exe" -OutFile "NDP452-KB2901907-x86-x64-AllOS-ENU.exe"
.\NDP452-KB2901907-x86-x64-AllOS-ENU.exe /q /norestart
