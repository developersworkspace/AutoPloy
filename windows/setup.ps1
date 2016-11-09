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

function CheckIfWebApplicationExist ($site, $app) {
    $webApplications = Get-WebApplication -Site $site
    for ($i = 0; $i -lt $webApplications.Length; $i ++ ){
        if ($webApplications[$i].Name -eq $name) {
            return 1
        }
    }
    return 0
}

if ($PSVersionTable.PSVersion.Major -lt 3){
    Write-Host "Powershell version 3+ is required"
    return
}

# iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex

# choco install urlrewrite

Write-Host "Creating IIS Sites directories"
$result = mkdir "D:\Sites\Passport\Portal"
Set-Content -Value "Hello World !!! Deployed using powershell" -Path "D:\Sites\Passport\Portal\index.html"

$appPoolExist = CheckIfAppPoolExist -name "PassportPool"
if ($appPoolExist -eq 0) {
    Write-Host "Creating app pool"
    $result = New-WebAppPool -Name "PassportPool" -Force
}

$websiteExist = CheckIfWebsiteExist -name "Passport"
if ($websiteExist -eq 0) {
    Write-Host "Creating website"
    $result = New-Website -Name "Passport" -PhysicalPath "D:\Sites\Passport" -ApplicationPool "PassportPool"  -Port 8080
}

$webApplicationExist = CheckIfWebApplicationExist -site "Passport" -app "Portal"
if ($webApplicationExist -eq 0) {
    Write-Host "Creating web application"
    $result = New-WebApplication -Name "Portal" -Site "Passport" -PhysicalPath "D:\Sites\Passport\Portal" -ApplicationPool "PassportPool" 
}


$appPool = Get-Item IIS:\AppPools\PassportPool;
$appPool.processModel.userName = 'administrator';
$appPool.processModel.password = 'Eur0m0nit0r';
$appPool.processModel.identityType = 3;
$appPool | Set-Item
$appPool.Stop();
$appPool.Start();

$website = Get-Item "IIS:\Sites\Passport" 
$website.virtualDirectoryDefaults.userName = "administrator"
$website.virtualDirectoryDefaults.password = "Eur0m0nit0r"
$website | Set-Item


Write-Host "Press any key to continue ..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

Write-Host "Cleaning up"

Remove-Item -Recurse -Force "D:\Sites\Passport"

Remove-WebApplication -Name "Portal" -Site "Passport"
Remove-Website -Name "Passport"
Remove-WebAppPool -Name "PassportPool"
