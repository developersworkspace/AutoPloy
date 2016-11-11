if ($PSVersionTable.PSVersion.Major -lt 5){
    Write-Host "Powershell version 5+ is required"
    return
}

iwr "https://download.microsoft.com/download/E/E/D/EEDF18A8-4AED-4CE0-BEBE-70A83094FC5A/BuildTools_Full.exe" -OutFile "BuildTools_Full.exe"
.\BuildTools_Full.exe /q /norestart

iwr "https://download.microsoft.com/download/0/B/C/0BC321A4-013F-479C-84E6-4A2F90B11269/vs_community.exe" -OutFile "vs_community.exe"
.\vs_community.exe /q /norestart