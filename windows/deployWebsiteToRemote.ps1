param(
        [string]$ipAddress,
        [string]$username,
        [string]$password,
        [string]$sourcePath,
        [string]$zippedLocalPath,
        [string]$zippedRemotePath,
        [string]$destinationPath,
        [string]$buildNumber
    )

Import-Module $PSScriptRoot\modules\dwtools.psm1 -Force

$p1 = Join-Path -Path $zippedLocalPath -ChildPath "$buildNumber.zip"
$p2 = Join-Path -Path $zippedRemotePath -ChildPath "$buildNumber.zip"

# Compress-Archive -Path $sourcePath -DestinationPath $p1
Add-Type -Assembly "System.IO.Compression.FileSystem"
[System.IO.Compression.ZipFile]::CreateFromDirectory($sourcePath, $p1)


RemoteCopyFile -sourceFile $p1 -destinationFile $zippedRemotePath -computerName $ipAddress -username $username -password $password
UnzipOnRemote -sourceFile $p2 -destinationPath $destinationPath -computerName $ipAddress -username $username -password $password
Test-WsMan 94.236.64.178
# .\deployWebsiteToRemote.ps1 -ipAddress 94.236.64.178 -username "\administrator" -password "Eur0m0nit0r" -sourcePath "D:\Publish\*" -zippedLocalPath "C:\temp" -zippedRemotePath "C:\temp" -destinationPath "C:\Sites\redact.euromonitor.local" -buildNumber "001"
# .\deployWebsiteToRemote.ps1 -ipAddress dv-healthmonitor-sa -username "\administrator" -password "Eur0m0nit0r" -sourcePath "D:\Publish\*" -zippedLocalPath "C:\temp" -zippedRemotePath "C:\temp" -destinationPath "D:\Web Applications - Redact" -buildNumber "001"