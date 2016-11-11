if ($PSVersionTable.PSVersion.Major -lt 5){
    Write-Host "Powershell version 5+ is required"
    return
}

iwr "https://download.microsoft.com/download/E/A/E/EAE6F7FC-767A-4038-A954-49B8B05D04EB/ExpressAdv%2064BIT/SQLEXPRADV_x64_ENU.exe" -OutFile "SQLEXPR_x64_ENU.exe"
.\SQLEXPR_x64_ENU.exe /QS /ACTION=Install /FEATURES=SQL,Tools /INSTANCENAME=MSSQLSERVER /SQLSVCACCOUNT="administrator" /SQLSVCPASSWORD="wP3YzoV5cNSS" /SQLSYSADMINACCOUNTS="administrator" /AGTSVCACCOUNT="NT AUTHORITY\Network Service"  /IACCEPTSQLSERVERLICENSETERMS  
