# Silent Install ELK 
## https://www.elastic.co/guide/en/elasticsearch/reference/current/windows.html

#--------------------------------------------------------------------------------------------------------
# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/set-psdebug?view=powershell-7.1
Set-PSDebug -Trace 2 #turns script debugging features on and off, sets the trace level

$VerbosePreference = "continue"
Write-Output $VerbosePreference
#--------------------------------------------------------------------------------------------------------

# Path for the Workdir
$workdir = "C:\tmp\"

# Check if work directory exists if not create it

If (Test-Path -Path $workdir -PathType Container)
{ Write-Host "$workdir already exists" -ForegroundColor Red}
ELSE
{ New-Item -Path $workdir  -ItemType directory }

# Download the installer     

$source = "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.15.2.msi"           
#specific version
# $source = "https://download.mozilla.org/?product=firefox-51.0.1-SSL&os=win64&lang=en-US"
$destination = "$workdir\elasticsearch-7.15.2.msi"

# Check if Invoke-Webrequest exists otherwise execute WebClient

if (Get-Command 'Invoke-Webrequest')
{
     Invoke-WebRequest $source -OutFile $destination
}
else
{
    $WebClient = New-Object System.Net.WebClient
    $webclient.DownloadFile($source, $destination)
}

# Start the installation
# By default, msiexec.exe does not wait for the installation process to complete
# To wait on the process to finish and ensure that %ERRORLEVEL% is set accordingly
Set-Location -Path $destination
start /wait msiexec.exe /i elasticsearch-7.15.2.msi /qn
# Start-Process -FilePath "msiexec.exe" -ArgumentList "/i elasticsearch-7.15.2.msi /qn"
# a log file for the installation process can be found within the %TEMP% directory
# a randomly generated name adhering to the format MSI<random>.LOG
start /wait msiexec.exe /i elasticsearch-7.15.2.msi /qn /l install.log
# Start-Process -FilePath "msiexec.exe" -ArgumentList "# Wait few Seconds for the installation to finish"

# Wait few Seconds for the installation to finish

Start-Sleep -s 45

# Remove the installer

Remove-Item -Force Set-Location -Path $destination


