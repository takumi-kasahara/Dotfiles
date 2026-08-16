using namespace System.IO

[CmdletBinding()]
param (
  [switch]
  $SymLink,
  [switch]
  $Force
)

Set-StrictMode -Version Latest
Set-Location -LiteralPath $PSScriptRoot

$shell = New-Object -ComObject 'Shell.Application'
class Installer {
  hidden [hashtable[]] $Sources = @()
  hidden [string[]] $Destinations = @()
  [Installer] Source([string]$path, [string]$name) {
    $this.Sources += @{
      Path = $path
      Name = $name
    }
    return $this
  }
  [Installer] Source([string]$path) {
    return $this.Source($path, $null)
  }
  [Installer] Destination([string]$path) {
    $this.Destinations += $path
    return $this
  }
  [Installer] Destination2([string]$path) {
    $this.Destinations += [WildcardPattern]::Escape($path) | Split-Path -Parent
    return $this
  }
  [void] Install() {
    foreach ($dest in $this.Destinations.GetEnumerator() | Sort-Object -Property Name) {
      if (-not (Test-Path -LiteralPath $dest)) {
        Write-Warning -Message "$dest not found."
        continue
      }
      foreach ($src in $this.Sources.GetEnumerator() | Sort-Object -Property Name) {
        if (-not (Test-Path -Path $src.Path)) {
          Write-Warning -Message "$($src.Path) not found."
          continue
        }
        Get-Item -Path $src.Path |
        ForEach-Object {
          $relative = $_.FullName.StartsWith($PSScriptRoot) ? (Resolve-Path -LiteralPath $_ -Relative) : ($_.FullName -replace [regex]::Escape($env:USERPROFILE), '~')
          $resolved = (Resolve-Path -LiteralPath $_).Path
          $name = $src.Name
          if (-not $name) {
            $name = Split-Path -Path $resolved -Leaf
          }
          $target = $dest | Join-Path -ChildPath $name
          $isLink = (Test-Path -LiteralPath $target) -and ($null -ne (Get-Item -LiteralPath $target -Force).LinkType)
          try {
            if ($SymLink -or -not $resolved.StartsWith($PSScriptRoot)) {
              if ((Test-Path -LiteralPath $target) -and (Get-Item -LiteralPath $target -Force).LinkTarget -ieq $resolved) {
                "Skiped:`t$relative`t->`t$($target -replace [regex]::Escape($env:USERPROFILE), '~')" | Out-Host
                return
              }
              $arguments = @{
                Path  = $dest
                Value = $resolved
                Name  = $name
              }
              if (Test-Path -LiteralPath $target) {
                "Replace:`t$relative`t->`t$($target -replace [regex]::Escape($env:USERPROFILE), '~')" | Out-Host
                Remove-Item -LiteralPath $target -Recurse -Force:$Force
              } else {
                "Create:`t$relative`t->`t$($target -replace [regex]::Escape($env:USERPROFILE), '~')" | Out-Host
              }
              New-Item @arguments -ItemType SymbolicLink -Force:$Force
            } else {
              if (Test-Path -LiteralPath $target) {
                $srcItem = Get-Item -LiteralPath $target -Force
                $destItem = Get-Item -LiteralPath $resolved -Force
                if (-not $isLink) {
                  if ($srcItem.PSIsContainer -and $destItem.PSIsContainer) {
                    $srcFiles = Get-ChildItem -LiteralPath $target -Recurse -File |
                    ForEach-Object {
                      @{
                        Path = $_.FullName.Substring($srcItem.FullName.Length).TrimStart('\')
                        Hash = (Get-FileHash -LiteralPath $_.FullName).Hash
                      }
                    }
                    $destFiles = Get-ChildItem -LiteralPath $resolved -Recurse -File |
                    ForEach-Object {
                      @{
                        Path = $_.FullName.Substring($destItem.FullName.Length).TrimStart('\')
                        Hash = (Get-FileHash -LiteralPath $_.FullName).Hash
                      }
                    }
                    if (@(Compare-Object -ReferenceObject $srcFiles -DifferenceObject $destFiles -Property Path, Hash).Count -eq 0) {
                      "Skiped:`t$relative`t->`t$($target -replace [regex]::Escape($env:USERPROFILE), '~')" | Out-Host
                      return
                    }
                  }
                  if (-not $srcItem.PSIsContainer -and -not $destItem.PSIsContainer) {
                    if ((Get-FileHash -LiteralPath $target).Hash -eq (Get-FileHash -LiteralPath $resolved).Hash) {
                      "Skiped:`t$relative`t->`t$($target -replace [regex]::Escape($env:USERPROFILE), '~')" | Out-Host
                      return
                    }
                  }
                }
                "Replace:`t$relative`t->`t$($target -replace [regex]::Escape($env:USERPROFILE), '~')" | Out-Host
                Remove-Item -LiteralPath $target -Recurse -Force:$Force
              }
              if (-not (Test-Path -LiteralPath $target)) {
                "Create:`t$relative`t->`t$($target -replace [regex]::Escape($env:USERPROFILE), '~')" | Out-Host
              }
              Copy-Item -LiteralPath $resolved -Destination $target -Recurse -Force:$Force
            }
          } catch [UnauthorizedAccessException] {
            Write-Error -ErrorRecord $_
          } catch {
            Write-Warning -Message $_.Exception.Message
          }
        }
      }
    }
  }
}

#region Local
[Installer]::new().
Source($shell.NameSpace('shell:SavedPictures').Self.Path).
Destination($shell.NameSpace('shell:Downloads').Self.Path).
Install()
#endregion

#region Application
# Firefox
[Installer]::new().
Source('Firefox\user.js').
Destination(($env:LOCALAPPDATA | Join-Path -ChildPath 'Packages\Mozilla.MozillaFirefoxNightly_jag0gd4e3s9p2\LocalCache\Roaming\Mozilla\Firefox\Profiles\Default')).
Install()

# Tor Browser
# winget install --id TorProject.TorBrowser --exact --location %LOCALAPPDATA%\Programs
[Installer]::new().
Source('Firefox\user.tor.js', 'user.js').
Destination(($env:LOCALAPPDATA | Join-Path -ChildPath 'Programs\Browser\TorBrowser\Data\Browser\profile.default')).
Install()

# Thunderbird
[Installer]::new().
Source('Thunderbird\user.js').
Destination(($env:LOCALAPPDATA | Join-Path -ChildPath 'Packages\MozillaThunderbird.MozillaThunderbird_jag0gd4e3s9p2\LocalCache\Roaming\Thunderbird\Profiles\Default')).
Install()

# Visual Studio Code
# https://code.visualstudio.com/docs/agent-customization/prompt-files#_prompt-file-locations
[Installer]::new().
Source('Code\*.json').
Source('Code\prompts').
Source('Code\snippets').
Destination(($env:APPDATA | Join-Path -ChildPath 'Code\User')).
Destination(($env:APPDATA | Join-Path -ChildPath 'Code - Insiders\User')).
Install()
# https://learn.microsoft.com/en-us/visualstudio/ide/mcp-servers?view=visualstudio
[Installer]::new().
Source('Code\mcp.json', '.mcp.json').
Destination($env:USERPROFILE).
Install()

# Eclipsecod
[Installer]::new().
Source('Eclipse\*.json').
Destination(($env:USERPROFILE | Join-Path -ChildPath '.theia-ide')).
Install()

# ILSpy
[Installer]::new().
Source('ICSharpCode\ILSpy.xml').
Destination(($env:APPDATA | Join-Path -ChildPath 'ICSharpCode')).
Install()

# LINQPad
[Installer]::new().
Source('LINQPad\LocalUserOptions.xml').
Source('LINQPad\WindowLayout.xml').
Destination(($env:LOCALAPPDATA | Join-Path -ChildPath 'LINQPad')).
Install()

# Rubberduck
[Installer]::new().
Source('Rubberduck\rubberduck.config').
Destination(($env:APPDATA | Join-Path -ChildPath 'Rubberduck')).
Install()

# Notepad++
[Installer]::new().
Source('Notepad++\*.xml').
Destination(($env:APPDATA | Join-Path -ChildPath 'Notepad++')).
Install()

# WinMerge
[Installer]::new().
Source('WinMerge\MergePlugins').
Destination(($env:APPDATA | Join-Path -ChildPath 'WinMerge')).
Install()
[Installer]::new().
Source('WinMerge\Filters').
Destination(($shell.NameSpace('shell:Personal').Self.Path | Join-Path -ChildPath 'WinMerge')).
Install()

# AstroGrep
[Installer]::new().
Source('AstroGrep\*.config').
Destination(($env:APPDATA | Join-Path -ChildPath 'AstroGrep')).
Install()

# RStudio
[Installer]::new().
Source('RStudio\rstudio-prefs.json').
Destination(($env:APPDATA | Join-Path -ChildPath 'RStudio')).
Install()

# Sumatra PDF
[Installer]::new().
Source('SumatraPDF\SumatraPDF-settings.txt').
Destination(($env:LOCALAPPDATA | Join-Path -ChildPath 'SumatraPDF')).
Install()
#endregion

#region Development
# Git
$edit = Get-Command -Name edit.exe -ErrorAction SilentlyContinue
if ($edit) {
  git.exe config --global core.editor $edit.Source.Replace([Path]::DirectorySeparatorChar, [Path]::AltDirectorySeparatorChar)
  setx.exe EDITOR "`"$($edit.Source)`""
} else {
  git.exe config --global --unset core.editor
}
$gpg = Get-Command -Name gpg.exe -ErrorAction SilentlyContinue
if ($gpg) {
  [Installer]::new().
  Source('GnuPG\gpg-agent.conf').
  Destination(($env:APPDATA | Join-Path -ChildPath 'gnupg')).
  Install()
  git.exe config set --global gpg.program $gpg.Source.Replace([Path]::DirectorySeparatorChar, [Path]::AltDirectorySeparatorChar)
} else {
  git.exe config unset --global gpg.program
}
$ssh = Get-Command -Name ssh.exe -ErrorAction SilentlyContinue
if ($ssh) {
  git.exe config set --global core.sshCommand $ssh.Source.Replace([Path]::DirectorySeparatorChar, [Path]::AltDirectorySeparatorChar)
} else {
  git.exe config unset --global core.sshCommand
}
$ssh_keygen = Get-Command -Name ssh-keygen.exe -ErrorAction SilentlyContinue
if ($ssh_keygen) {
  git.exe config set --global gpg.ssh.program $ssh_keygen.Source.Replace([Path]::DirectorySeparatorChar, [Path]::AltDirectorySeparatorChar)
} else {
  git.exe config unset --global gpg.ssh.program
}
Copy-Item -LiteralPath ($PSScriptRoot | Join-Path -ChildPath 'Git\ignore') -Destination ($env:USERPROFILE | Join-Path -ChildPath '.config\git') -Force
[Installer]::new().
Source('Git\gitconfig').
Destination(($env:ProgramFiles | Join-Path -ChildPath 'Git\etc')).
Install()
[Installer]::new().
Source('Git\.profile').
Source('Git\.bashrc').
Source('Git\.bash_aliases').
Source('Git\.bash_logout').
Source('Git\.gitconfig').
Source('Git\.gitmessage.txt').
Source('Git\.inputrc').
Source('Git\.minttyrc').
Source('Git\.vimrc').
Destination($env:USERPROFILE).
Install()
[Installer]::new().
Source('Git\*.sh').
Destination(($env:LOCALAPPDATA | Join-Path -ChildPath 'Programs')).
Install()

# Copilot
# https://code.visualstudio.com/docs/agent-customization/agent-skills#_create-a-skill
# https://code.visualstudio.com/docs/agent-customization/custom-agents#_custom-agent-file-locations
# https://code.visualstudio.com/docs/agent-customization/custom-instructions#_instructions-file-locations
[Installer]::new().
Source('.agents').
Destination($env:USERPROFILE).
Install()
[Installer]::new().
Source('.copilot\*.json').
Source('.copilot\agents').
Source('.copilot\instructions').
Source('.copilot\skills').
Destination(($env:USERPROFILE | Join-Path -ChildPath '.copilot')).
Install()

# Subversion
[Installer]::new().
Source('Subversion\config').
Source('Subversion\servers').
Destination(($env:APPDATA | Join-Path -ChildPath 'Subversion')).
Install()
[Installer]::new().
Source('Subversion\*.bat').
Destination(($env:LOCALAPPDATA | Join-Path -ChildPath 'Programs')).
Install()

# npm
[Installer]::new().
Source('npm\.npmrc').
Destination($env:USERPROFILE).
Install()

# Dev Drive
# https://learn.microsoft.com/en-us/windows/dev-drive/
$devDrive = Get-Volume |
Where-Object -Property FileSystem -EQ 'ReFS' |
Select-Object -ExpandProperty DriveLetter -First 1
if ($devDrive) {
  $cache = "$($devDrive):\.cache"
  setx.exe XDG_CACHE_HOME "$cache"
  if ((Get-Command -Name npm.cmd -ErrorAction SilentlyContinue)) {
    $npm = "$($devDrive):\npm-cache"
    npm.cmd config set --global cache="$npm"
    setx.exe NPM_CONFIG_CACHE "$npm"
  }
  if ((Get-Command -Name nuget.exe -ErrorAction SilentlyContinue)) {
    $nuget = "$($devDrive):\.nuget\packages"
    nuget.exe config -set globalPackagesFolder="$nuget"
    setx.exe NUGET_PACKAGES "$nuget"
  }
  if ((Get-Command -Name pip.exe -ErrorAction SilentlyContinue)) {
    $pip = "$($devDrive):\pip\cache"
    pip.exe config set global.cache-dir "$pip"
    setx.exe PIP_CACHE_DIR "$pip"
  }
  if ((Get-Command -Name lms.exe -ErrorAction SilentlyContinue)) {
    $models = "$($devDrive):\.lmstudio\models"
    if (-not (Test-Path -LiteralPath $models)) {
      New-Item -Path $models -ItemType Directory -Force | Out-Null
    }
  }
  if ((Get-Command -Name ollama.exe -ErrorAction SilentlyContinue)) {
    $models = "$($devDrive):\.ollama\models"
    if (-not (Test-Path -LiteralPath $models)) {
      New-Item -Path $models -ItemType Directory -Force | Out-Null
    }
    # https://docs.ollama.com/faq#how-do-i-set-them-to-a-different-location
    setx.exe OLLAMA_MODELS "$models"
    # https://docs.ollama.com/faq#how-do-i-configure-ollama-server
    setx.exe OLLAMA_FLASH_ATTENTION 1
    setx.exe OLLAMA_IGPU_ENABLE 1
    setx.exe OLLAMA_KV_CACHE_TYPE q4_0
  }
}

# Chocolatey
cmd.exe /c '.\Chocolatey\choco.feature.bat'

# WinGet
[Installer]::new().
Source('WinGet\settings.json').
Destination(($env:LOCALAPPDATA | Join-Path -ChildPath 'Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState')).
Install()

# Windows Terminal
[Installer]::new().
Source('wt\settings.json').
Destination(($env:LOCALAPPDATA | Join-Path -ChildPath 'Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState')).
Install()
[Installer]::new().
Source('wt\settings.preview.json', 'settings.json').
Destination(($env:LOCALAPPDATA | Join-Path -ChildPath 'Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState')).
Install()
[Installer]::new().
Source('wtai\settings.json').
Destination(($env:LOCALAPPDATA | Join-Path -ChildPath 'Packages\Microsoft.IntelligentTerminal_8wekyb3d8bbwe\LocalState')).
Install()

# Command Prompt
[Installer]::new().
Source('Windows\autoexec.bat').
Destination($env:USERPROFILE).
Install()

# PowerShell
[Installer]::new().
Source('Windows\PowerShell.5.ps1', 'profile.ps1').
Destination2((powershell.exe -NoLogo -NoProfile -Command '$PROFILE.CurrentUserAllHosts')).
Install()
[Installer]::new().
Source('Windows\PowerShell.7.ps1', 'profile.ps1').
Destination2((pwsh.exe -NoLogo -NoProfile -Command '$PROFILE.CurrentUserAllHosts')).
Install()

# Event Viewer
[Installer]::new().
Source('Windows\Events\*.xml').
Destination(($env:LOCALAPPDATA | Join-Path -ChildPath 'Microsoft\Event Viewer\Views')).
Install()

# Windows Subsystem for Linux
if ((Get-Command -Name wsl.exe -ErrorAction SilentlyContinue)) {
  try {
    wsl.exe --status >$null 2>&1
  } catch {
    wsl.exe --install
  }
  [Installer]::new().
  Source('Linux\.wslconfig').
  Destination($env:USERPROFILE).
  Install()
  # https://learn.microsoft.com/en-us/windows/wsl/filesystems#share-environment-variables-between-windows-and-wsl-with-wslenv
  "Config:`tWSLENV" | Out-Host
  setx.exe WSLENV USERPROFILE/up >$null

  $config = Import-PowerShellDataFile -LiteralPath 'Linux.psd1'
  @(wsl.exe --list --all --quiet) |
  ForEach-Object { $_ -replace '\0', [string]::Empty } |
  Where-Object -Property Length -GT 0 -PipelineVariable distro |
  ForEach-Object {
    "Distro:`t$distro" | Out-Host
    return $config.GetEnumerator() | Where-Object { $_.Name -eq $distro }
  } |
  ForEach-Object {
    $sh = "Linux/$($_.Value.Folder)/$($_.Value.Group).sh"
    if (-not (Test-Path -LiteralPath $sh)) {
      Write-Warning -Message "$sh not found."
      return
    }
    wsl.exe --distribution $distro sh -c "for u in \`$(cut -d: -f1 /etc/passwd); do id -nG `"\`$u`" | grep -qw `"$($_.Value.Group)`" && echo `"\`$u`"; done" |
    ForEach-Object {
      "Config:`t$($_)@$distro" | Out-Host
      wsl.exe --distribution $distro --user $_ $sh $SymLink $Force
    }
  }
  wsl.exe --shutdown
} else {
  Write-Warning -Message 'WSL not available.'
}
#endregion
