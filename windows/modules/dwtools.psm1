function RemoteCopyFolder ($sourcePath, $destinationPath, $computerName, $username, $password) {
    
    $secpasswd = ConvertTo-SecureString $password -AsPlainText -Force
    $computerCredentials = New-Object System.Management.Automation.PSCredential ($username, $secpasswd)

    $session = New-PSSession -ComputerName $computerName -Credential $computerCredentials

    Invoke-Command -Session $session -ScriptBlock {
        param($path)
        Get-ChildItem -Path $path -Include * | remove-Item -recurse
    } -ArgumentList $destinationPath

    Copy-Item -ToSession $session -Path $sourcePath -Destination $destinationPath -Recurse 

    Remove-PSSession –Session $session
}

function RemoteCopyFile ($sourceFile, $destinationFile, $computerName, $username, $password) {
    
    $secpasswd = ConvertTo-SecureString $password -AsPlainText -Force
    $computerCredentials = New-Object System.Management.Automation.PSCredential ($username, $secpasswd)

    $session = New-PSSession -ComputerName $computerName -Credential $computerCredentials

    Invoke-Command -Session $session -ScriptBlock {
        param($path)
        Remove-Item $path -Force -Recurse
        New-Item -Path $path -ItemType Directory
    } -ArgumentList $destinationFile

    Copy-Item -ToSession $session -Path $sourceFile -Destination $destinationFile -Force

    Remove-PSSession –Session $session
}

function UnzipOnRemote ($sourceFile, $destinationPath, $computerName, $username, $password) {
    
    $secpasswd = ConvertTo-SecureString $password -AsPlainText -Force
    $computerCredentials = New-Object System.Management.Automation.PSCredential ($username, $secpasswd)

    $session = New-PSSession -ComputerName $computerName -Credential $computerCredentials

    Invoke-Command -Session $session -ScriptBlock {
        param($path)
        Remove-Item $path -Force -Recurse
        New-Item -Path $path -ItemType Directory
    } -ArgumentList $destinationPath
    
    Invoke-Command -Session $session -ScriptBlock {
        param($sourceFile, $destinationPath)
        
        Add-Type -Assembly "System.IO.Compression.FileSystem"
        [io.compression.zipfile]::ExtractToDirectory($sourceFile, $destinationPath)
        # Expand-Archive -Path $sourcePath -DestinationPath $destinationPath
    } -ArgumentList $sourceFile, $destinationPath

    Remove-PSSession –Session $session
}

Export-ModuleMember RemoteCopyFolder
Export-ModuleMember RemoteCopyFile
Export-ModuleMember UnzipOnRemote