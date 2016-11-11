if ($PSVersionTable.PSVersion.Major -lt 5){
    Write-Host "Powershell version 5+ is required"
    return
}

iwr "http://mirrors.jenkins-ci.org/windows-stable/latest" -OutFile "jenkinszip"
Expand-Archive -Path "jenkins.zip" -DestinationPath "jenkins"
msiexec /i "jenkins\jenkins.msi" /quiet /qb /norestart