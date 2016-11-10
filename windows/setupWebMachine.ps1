if ($PSVersionTable.PSVersion.Major -lt 5){
    Write-Host "Powershell version 5+ is required"
    return
}

Import-Module ServerManager

Add-WindowsFeature Web-Server -IncludeAllSubFeature

iwr "https://download.microsoft.com/download/E/2/1/E21644B5-2DF2-47C2-91BD-63C560427900/NDP452-KB2901907-x86-x64-AllOS-ENU.exe" -OutFile "NDP452-KB2901907-x86-x64-AllOS-ENU.exe"
.\NDP452-KB2901907-x86-x64-AllOS-ENU.exe /q /norestart


iwr "https://download.microsoft.com/download/E/A/E/EAE6F7FC-767A-4038-A954-49B8B05D04EB/ExpressAdv%2064BIT/SQLEXPRADV_x64_ENU.exe" -OutFile "SQLEXPR_x64_ENU.exe"
.\SQLEXPR_x64_ENU.exe /QS /ACTION=Install /FEATURES=SQL,Tools /INSTANCENAME=MSSQLSERVER /SQLSVCACCOUNT="administrator" /SQLSVCPASSWORD="wP3YzoV5cNSS" /SQLSYSADMINACCOUNTS="administrator" /AGTSVCACCOUNT="NT AUTHORITY\Network Service"  /IACCEPTSQLSERVERLICENSETERMS  


iwr "http://mirrors.jenkins-ci.org/windows-stable/latest" -OutFile "jenkins-2.19.2.zip"
Expand-Archive -Path "jenkins-2.19.2.zip" -DestinationPath "jenkins"
msiexec /i "jenkins\jenkins.msi" /quiet /qb /norestart