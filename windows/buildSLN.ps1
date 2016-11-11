RMDIR "C:\JenkinsBuilds\epons.developersworkspace.co.za" /S /Q
MKDIR "C:\JenkinsBuilds\epons.developersworkspace.co.za"

"C:\Program Files\Git\bin\git" clone https://developersworkspace@bitbucket.org/developersworkspace/epons.git "C:\JenkinsWorkspaces\epons.developersworkspace.co.za"
"C:\JenkinsWorkspaces\epons.developersworkspace.co.za\SourceCode\EPONS\.nuget\nuget.exe" restore "C:\JenkinsWorkspaces\epons.developersworkspace.co.za\SourceCode\EPONS\EPONS.sln"

"C:\Program Files (x86)\MSBuild\14.0\Bin\MSBuild.exe" /m /t:clean;Rebuild /p:Configuration=EPONS;BuildingProject=true;OutDir="C:\JenkinsBuilds\epons.developersworkspace.co.za" "C:\JenkinsWorkspaces\epons.developersworkspace.co.za\SourceCode\EPONS\EPONS.sln"