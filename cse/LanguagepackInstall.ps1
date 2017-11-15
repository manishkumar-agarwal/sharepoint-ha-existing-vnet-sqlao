<# Custom Script for Windows to install a file from Azure Storage using the staging folder created by the deployment script #>
param (
    [string]$artifactsLocation1 = "https://rsgnaem20cvmstg1.blob.core.windows.net/servicelanguagepacks/LanguagePacks.zip",
	[string]$artifactsLocation2 = "https://rsgnaem20cvmstg1.blob.core.windows.net/servicelanguagepacks/LanguagePacksSP1.zip",
	[string]$artifactsLocation3 = "https://rsgnaem20cvmstg1.blob.core.windows.net/2016-cu/CUJan2016.zip"
    )

Add-Type -AssemblyName System.IO.Compression.FileSystem
$ProgressPreference = 'SilentlyContinue'

$source = $artifactsLocation1 # "https://rsgnaem20cvmstg1.blob.core.windows.net/servicelanguagepacks/LanguagePacks.zip"
$dest = "D:\"
#New-Item -Path $dest -ItemType directory
Invoke-WebRequest $source -OutFile "$dest\LanguagePacks.zip"

Write-Host "Downloading of language pack is complete"

$zipfile = "D:\LanguagePacks.zip"

$outpath = "D:\LanguagePacks"

[System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)


Get-ChildItem -path "D:\LanguagePacks" -recurse | ?{$_.Name -eq "setup.exe"} |%{Write-Host "Installing at" $_.FullName; Start-Process -filepath $_.FullName -ArgumentList "/config .\files\setupsilent\config.xml" -wait}

$source = $artifactsLocation2 # "https://rsgnaem20cvmstg1.blob.core.windows.net/servicelanguagepacks/LanguagePacksSP1.zip"

Invoke-WebRequest $source -OutFile "$dest\LanguagePacksSP1.zip"

Write-Host "Downloading of language pack SP1 is complete"

$zipfile = "D:\LanguagePacksSP1.zip"

$outpath = "D:\LanguagePacksSP1"

[System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)

Get-ChildItem -path "D:\LanguagePacksSP1" -recurse | ?{$_.Extension -eq ".exe"} |%{Write-Host "Installing at" $_.FullName; Start-Process -filepath $_.FullName /passive -wait}

$source = $artifactsLocation3 # "https://rsgnaem20cvmstg1.blob.core.windows.net/2016-cu/CUJan2016.zip"

$wc = New-Object net.webclient
$wc.Downloadfile($source, "$dest\CUJan2016.zip")

Write-Host "Downloading of CU is complete"

$zipfile = "D:\CUJan2016.zip"

$outpath = "D:\CUJan2016"

[System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)

Get-ChildItem -path "D:\CUJan2016" -recurse | ?{$_.Extension -eq ".exe"} |%{Write-Host "Installing at" $_.FullName; Start-Process -filepath $_.FullName /passive -wait}

Write-Host "Completed installation successfully"

