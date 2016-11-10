Import-Module C:\scripts\dwtools.psm1 -Force
param($buildNumber)

$sourcePath = "C:\Sites\epons.developersworkspace.co.za\*"
$zippedLocaPath = "C:\Builds"
$zippedRemotePath = "C:\Builds"

$destinationPath = "C:\Sites\EPONS\Demo"

$p1 = Join-Path -Path $zippedLocaPath -ChildPath "$buildNumber.zip"
$p2 = Join-Path -Path $zippedRemotePath -ChildPath "$buildNumber.zip"

Compress-Archive -Path $sourcePath -DestinationPath $p1
RemoteCopyFile -sourceFile $p1 -destinationFile $zippedRemotePath -computerName "197.96.137.125" -username "sadfm" -password "Galjoen501"
UnzipOnRemote -sourceFile $p2 -destinationPath $destinationPath -computerName "197.96.137.125" -username "sadfm" -password "Galjoen501"

# RemoteCopy -sourcePath "C:\Sites\epons.developersworkspace.co.za\*" -destinationpath "C:\Sites\EPONS\Demo\" -computerName "197.96.137.125" -username "sadfm" -password "Galjoen501"