if ($PSVersionTable.PSVersion.Major -lt 5){
    Write-Host "Powershell version 5+ is required"
    return
}

Import-Module ServerManager

Add-WindowsFeature Web-Server -IncludeAllSubFeature


