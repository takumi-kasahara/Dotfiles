'use strict';

/**
 * @see {@link https://learn.microsoft.com/en-us/windows/win32/shell/shell-shellexecute}
 */
WScript.CreateObject('Shell.Application').ShellExecute(
  'cmd',
  '/D /E:ON /V:OFF /S /C echo %PATH%',
  '',
  'runas',
  0
);
