Set-ExecutionPolicy RemoteSigned
if ($PSVersionTable.PSVersion.Major -lt 3){
    Write-Host "Powershell version 3+ is required"
    return
}

iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex

choco install googlechrome
choco install notepadplusplus
