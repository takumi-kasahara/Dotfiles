# wsl.exe --list --online --quiet
@{
  'Debian'         = @{
    'Folder' = 'Debian'
    'Group'  = 'users'
  }
  'Ubuntu'         = @{
    'Folder' = 'Debian'
    'Group'  = 'users'
  }
  'FedoraLinux-44' = @{
    'Folder' = 'RHEL'
    'Group'  = 'wheel'
  }
}
