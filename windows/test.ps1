Set-ExecutionPolicy Unrestricted
iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex
choco feature enable -n=allowGlobalConfirmation
choco install python