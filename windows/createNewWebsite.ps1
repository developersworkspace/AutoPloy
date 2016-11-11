param(
        [string]$path,
        [string]$username,
        [string]$password,
        [string]$websiteName,
        [string]$appPoolName,
        [int]$port
    )

if ($PSVersionTable.PSVersion.Major -lt 5){
    Write-Host "Powershell version 5+ is required"
    return
}


Import-Module WebAdministration

function CheckIfWebsiteExist ($name) {
    $websites = Get-Website
    for ($i = 0; $i -lt $websites.Length; $i ++ ){
        if ($websites[$i].Name -eq $name) {
            return 1
        }
    }
    return 0
}

function CheckIfAppPoolExist ($name) {
    $appPools = Get-ChildItem -path IIS:\AppPools
    for ($i = 0; $i -lt $appPools.Length; $i ++ ){
        if ($appPools[$i].Name -eq $name) {
            return 1
        }
    }
    return 0
}

$result = mkdir $path
Set-Content -Value "Hello World !!!" -Path "$path\index.html"


$appPoolExist = CheckIfAppPoolExist -name $appPoolName
if ($appPoolExist -eq 0) {
    $result = New-WebAppPool -Name $appPoolName -Force
}

$websiteExist = CheckIfWebsiteExist -name $websiteName
if ($websiteExist -eq 0) {
    $result = New-Website -Name$websiteName -PhysicalPath $path -ApplicationPool $appPoolName  -Port $port
}


$appPool = Get-Item "IIS:\AppPools\$appPoolName";
$appPool.processModel.userName = $username;
$appPool.processModel.password = $password;
$appPool.processModel.identityType = 3;
$appPool | Set-Item
$appPool.Stop();
$appPool.Start();

$website = Get-Item "IIS:\Sites\$websiteName" 
$website.virtualDirectoryDefaults.userName = $username
$website.virtualDirectoryDefaults.password = $password
$website | Set-Item