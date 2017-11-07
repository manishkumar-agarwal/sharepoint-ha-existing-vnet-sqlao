<# Custom Script for Windows to install a file from Azure Storage using the staging folder created by the deployment script #>
param (
    [string]$artifactsLocation
    )

Add-Type -AssemblyName System.IO.Compression.FileSystem


$source = $artifactsLocation # "https://wtwsql16rgdiag268.blob.core.windows.net/languagepacks/LanguagePacks.zip"
$dest = "D:\"
#New-Item -Path $dest -ItemType directory
Invoke-WebRequest $source -OutFile "$dest\LanguagePacks.zip"

$zipfile = "D:\LanguagePacks.zip"

$outpath = "D:\"

[System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)


Get-ChildItem -path "D:\LanguagePacks" -recurse | ?{$_.Name -eq "setup.exe"} |%{Write-Host "Installing at" $_.FullName; Start-Process -filepath $_.FullName -ArgumentList "/config .\files\setupsilent\config.xml" -wait}
