<#
    ╔══════════════════════════════════════════════════════════════════════╗
    ║                     Spicetify Auto-Apply Launcher                    ║
    ╠══════════════════════════════════════════════════════════════════════╣
    ║ Script Name : RunSpicetifyOnStartup.ps1                              ║
    ║ Description :                                                        ║
    ║   - Terminates Spotify if running                                    ║
    ║   - Runs 'spicetify.exe auto' first                                  ║
    ║   - If auto output lacks 'Spicetify up-to-date', runs 'update'       ║
    ║   - Logs all activity to 'RunSpicetify.log' (overwrite on each run)  ║
    ║                                                                      ║
    ║ Author      : IdaEdz                                                 ║
    ║ Created     : 2025-05-08                                             ║
    ║ Target OS   : Windows (PowerShell 5.1+)                              ║
    ╚══════════════════════════════════════════════════════════════════════╝
#>

# Get path of this script
$scriptPath = $MyInvocation.MyCommand.Path
$scriptDir = Split-Path $scriptPath
$logFile = Join-Path $scriptDir "RunSpicetify.log"

# Overwrite the log file at start
"" | Out-File -FilePath $logFile -Encoding utf8

# Logging function
function Log {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $message" | Out-File -FilePath $logFile -Append -Encoding utf8
}

# Start logging
Log "----- Starting Spicetify Startup Script -----"

try {
    # Kill Spotify if running
    $spotifyProcesses = Get-Process -Name "Spotify" -ErrorAction SilentlyContinue
    if ($spotifyProcesses) {
        Log "Spotify is running. Attempting to terminate..."
        $spotifyProcesses | ForEach-Object {
            try {
                $_.Kill()
                Log "Terminated Spotify (PID $($_.Id))"
            } catch {
                Log "Failed to terminate Spotify (PID $($_.Id)): $_"
            }
        }
    } else {
        Log "Spotify is not running."
    }

    # Set working directory to the standard user profile
    $workingDir = Join-Path $env:USERPROFILE "AppData\Roaming\Spotify"
    Set-Location $workingDir
    Log "Changed working directory to: $workingDir"

    # Define Spicetify executable
    $spicetifyExe = Join-Path $env:USERPROFILE "AppData\Local\spicetify\spicetify.exe"

    # Rrun 'update'
    Log "Running: spicetify.exe update"
    $updateOutput = & "$spicetifyExe" update 2>&1
    $updateExitCode = $LASTEXITCODE
    $updateOutput | ForEach-Object { Log "update: $_" }

    if ($updateExitCode -ne 0) {
        Log "ERROR: spicetify.exe update failed with exit code $updateExitCode. Aborting."
        Log "----- Script exited early due to update failure -----`n"
        exit $updateExitCode
    }

    Log "Spicetify successfully updated."

    # Run 'auto' and capture output
    Log "Running: spicetify.exe auto"
    $autoOutput = & "$spicetifyExe" auto 2>&1
    $autoOutput | ForEach-Object { Log "auto: $_" }

    Log "----- Script finished successfully -----`n"
}
catch {
    Log "ERROR: $_"
    Log "----- Script crashed -----`n"
}
