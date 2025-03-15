# Install.ps1
# Define the paths for BGInfo and the configuration file
$bginfoDir = "$env:APPDATA\bginfo"
$bginfoPath = "$bginfoDir\bginfo.exe" 
$configFilePath = "$bginfoDir\config.bgi"

# Create the directory if it doesn't exist
if (-Not (Test-Path $bginfoDir)) {
    New-Item -ItemType Directory -Path $bginfoDir -Force
}

# Download BGInfo if it doesn't exist
if (-Not (Test-Path $bginfoPath)) {
    Write-Host "Downloading BGInfo from https://live.sysinternals.com/Bginfo.exe..."
    Invoke-WebRequest -Uri "https://live.sysinternals.com/Bginfo.exe" -OutFile $bginfoPath
    Write-Host "BGInfo downloaded to $bginfoPath."
} else {
    Write-Host "BGInfo already exists at $bginfoPath."
}

# Check if the configuration file exists
if (-Not (Test-Path $configFilePath)) {
    Write-Host "BGInfo configuration file not found at $configFilePath. Downloading from GitHub..."
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/pjdotdev/pyjama.sh/main/config.bgi" -OutFile $configFilePath
    Write-Host "Configuration file downloaded to $configFilePath."
} else {
    Write-Host "BGInfo configuration file already exists at $configFilePath."
}

# Set the environment variables
[System.Environment]::SetEnvironmentVariable("BGINFO_PATH", $bginfoPath, [System.EnvironmentVariableTarget]::User)
[System.Environment]::SetEnvironmentVariable("BGINFO_CONFIG", $configFilePath, [System.EnvironmentVariableTarget]::User)

Write-Host "Environment variables set:"
Write-Host "BGINFO_PATH = $bginfoPath"
Write-Host "BGINFO_CONFIG = $configFilePath"

# Define the paths for the fetch and refresh scripts
$fetchScriptUrl = "https://pyjama.sh/scripts/fetch.ps1"
$refreshScriptUrl = "https://pyjama.sh/scripts/source.ps1"
$taskName = "BGInfoUpdate"

# Create a scheduled task to run the fetch and refresh scripts at 6 AM daily
$actionFetch = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$fetchScriptUrl`""
$actionRefresh = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$refreshScriptUrl`""

$triggerFetch = New-ScheduledTaskTrigger -Daily -At "06:00"
$triggerRefresh = New-ScheduledTaskTrigger -AtLogOn

# Register the scheduled tasks
Register-ScheduledTask -Action $actionFetch -Trigger $triggerFetch -TaskName "$taskName-Fetch" -User "$env:USERNAME" -RunLevel Highest
Register-ScheduledTask -Action $actionRefresh -Trigger $triggerRefresh -TaskName "$taskName-Refresh" -User "$env:USERNAME" -RunLevel Highest

Write-Host "Scheduled tasks created to run fetch at 6 AM daily and refresh at user login."
