.\buildSLN.ps1 -sourcePath "C:\Temp\sources" -buildPath "C:\Temp\builds" -buildNumber "001" -gitUrl "https://developersworkspace@bitbucket.org/developersworkspace/epons.git" -relativeNugetPath "SourceCode\EPONS\.nuget\nuget.exe" -relativeSLNPath "SourceCode\EPONS\EPONS.sln" -gitBranch "QueryObjects"
Start-Sleep -s 30

New-Item -Path "C:\Temp\builds\001\_PublishedWebsites\EPONS.Teddy.Presentation\bin\roslyn" -ItemType Directory

Copy-Item -Path "C:\temp\builds\001\roslyn\*" -Destination "C:\Temp\builds\001\_PublishedWebsites\EPONS.Teddy.Presentation\bin\roslyn"

# .\deployWebsiteToRemote.ps1 -ipAddress 197.96.137.125 -username "\sadfm" -password "Galjoen501" -sourcePath "C:\Temp\builds\001\_PublishedWebsites\EPONS.Teddy.Presentation\*" -zippedLocalPath "C:\temp\deploys" -zippedRemotePath "C:\temp\deploys" -destinationPath "C:\Sites\EPONS\Demo" -buildNumber "001"

.\deployWebsiteToRemote.ps1 -ipAddress 68.169.45.49 -username "\administrator" -password "MidericK96" -sourcePath "C:\Temp\builds\001\_PublishedWebsites\EPONS.Teddy.Presentation\*" -zippedLocalPath "C:\temp\deployslocal" -zippedRemotePath "C:\temp\deploysremote" -destinationPath "C:\Sites\epons.developersworkspace.co.za" -buildNumber "001"