param(
        [string]$sourcePath,
        [string]$buildPath,
        [string]$buildNumber,
        [string]$gitUrl,
        [string]$gitBranch,
        [string]$relativeSLNPath,
        [string]$relativeNugetPath
    )

$currentSourcePath = Join-Path -Path $sourcePath -ChildPath $buildNumber

# Remove-Item -Recurse -Force $currentSourcePath
# New-Item $currentSourcePath -ItemType Directory

# git.exe clone -b $gitBranch $gitUrl $currentSourcePath

$currentSLNPath = Join-Path -Path $currentSourcePath -ChildPath $relativeSLNPath
$currentNugetPath = Join-Path -Path $currentSourcePath -ChildPath $relativeNugetPath

Invoke-Expression -Command "$currentNugetPath update -self"
Invoke-Expression -Command "$currentNugetPath restore $currentSLNPath"

$currentBuildPath = Join-Path -Path $buildPath -ChildPath $buildNumber

$msBuildPath = "C:\Program Files (x86)\MSBuild\14.0\Bin\MSBuild.exe"
$args = "/m /t:clean;Rebuild /p:Configuration=Release;BuildingProject=true;OutDir=`"$currentBuildPath`" `"$currentSLNPath`""

Start-Process -FilePath $msBuildPath -ArgumentList "$args"

