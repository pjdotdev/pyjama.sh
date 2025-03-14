# Define the paths for BGInfo and the configuration file
$bginfoDir = "$env:APPDATA\bginfo"
$bginfoPath = "$bginfoDir\bginfo.exe"
$configFilePath = "$bginfoDir\config.bgi"

# Remove the BGInfo executable and configuration file if they exist
if (Test-Path $bginfoPath) {
    Remove-Item -Path $bginfoPath -Force
    Write-Host "Removed BGInfo executable at $bginfoPath."
} else {
    Write-Host "BGInfo executable not found at $bginfoPath."
}

if (Test-Path $configFilePath) {
    Remove-Item -Path $configFilePath -Force
    Write-Host "Removed BGInfo configuration file at $configFilePath."
} else {
    Write-Host "BGInfo configuration file not found at $configFilePath."
}

# Remove the entire BGInfo directory
if (Test-Path $bginfoDir) {
    Remove-Item -Path $bginfoDir -Recurse -Force
    Write-Host "Removed BGInfo directory at $bginfoDir."
} else {
    Write-Host "BGInfo directory not found at $bginfoDir."
}

# Reset the desktop background to black
$blackBackground = "C:\Windows\Web\Wallpaper\Windows\img0.jpg"  # Default Windows wallpaper path
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper -Value $blackBackground
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters

Write-Host "Desktop background reset to black."

# Remove environment variables
[System.Environment]::SetEnvironmentVariable("BGINFO_PATH", $null, [System.EnvironmentVariableTarget]::User)
[System.Environment]::SetEnvironmentVariable("BGINFO_CONFIG", $null, [System.EnvironmentVariableTarget]::User)

Write-Host "Environment variables removed."
