# Spicetify Auto-Apply Launcher

## Description

The `RunSpicetifyOnStartup.ps1` script is designed to automate the application of Spicetify themes or extensions each time you log in. Specifically, it will:

- Terminate Spotify if it’s currently running.
- Execute `spicetify.exe auto`.
- If the output indicates Spicetify is not up-to-date, it runs `spicetify.exe update`.
- Log all actions to `RunSpicetify.log` (overwritten each run).

The script automatically uses the current user's profile folder and is compatible with Windows systems running PowerShell 5.1 or newer.

---

## Requirements

- Windows with PowerShell 5.1 or newer (pre-installed on most systems)
- [Spicetify](https://github.com/spicetify/spicetify-cli) installed and configured correctly

---

## Usage

1. **Download or clone** this repository.

2. **No path modifications required**: The script uses `%USERPROFILE%` to dynamically reference the current user’s home directory.

3. **Set up Task Scheduler** to run the script automatically at login (see below).

---

## How to Set Up Task Scheduler

1. **Open Task Scheduler**  
   Press `Win + R`, type `taskschd.msc`, and press Enter.

2. **Create a new task**  
   In the right panel, click **Create Task**.

3. **General tab**  
   - **Name**: `Spicetify Auto-Apply`  
   - **Description**: Run Spicetify auto and update on startup  
   - **Security options**:
     - Select **Run only when user is logged on**
     - Uncheck **Run with highest privileges**

4. **Triggers tab**  
   - Click **New**
   - Set **Begin the task** to **At logon**
   - (Optional) Add another trigger for **At startup**

5. **Actions tab**  
   - Click **New**
   - **Action**: Start a program  
   - **Program/script**: `powershell`  
   - **Add arguments**:  
     ```
     -ExecutionPolicy Bypass -File "C:\path\to\RunSpicetifyOnStartup.ps1"
     ```
     Replace the path with the actual location of the script.

6. **Conditions tab**  
   - Leave unchecked unless you want specific conditions (e.g., run only on AC power)

7. **Settings tab**  
   - (Recommended) Check **Allow task to be run on demand**

8. **Finish**  
   - Click **OK** to save the task

---

## Log File

A log file named `RunSpicetify.log` is created in the same directory as the script. It contains:

- Whether Spotify was found and terminated
- The result of `spicetify.exe auto` and `spicetify.exe update`
- Any errors encountered during execution

---

## Troubleshooting

- **Spicetify not updating**  
  Ensure `spicetify.exe` is properly installed and its path is correctly referenced in the script.

- **Script not running**  
  Double-check the Task Scheduler settings:  
  - Task runs **at logon**  
  - **Not** set to run with elevated privileges  
  - Correct script path used in **Actions** tab

---

## License

This script is released under the [MIT License](LICENSE).
