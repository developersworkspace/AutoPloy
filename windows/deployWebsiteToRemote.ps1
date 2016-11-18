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

Remove-Item -Path $p1
Compress-Archive -Path $sourcePath -DestinationPath $p1

RemoteCopyFile -sourceFile $p1 -destinationFile $zippedRemotePath -computerName $ipAddress -username $username -password $password
UnzipOnRemote -sourceFile $p2 -destinationPath $destinationPath -computerName $ipAddress -username $username -password $password
