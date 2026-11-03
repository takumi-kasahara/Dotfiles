'use strict';

var FileSystemObject = WScript.CreateObject('Scripting.FileSystemObject');
var WshShell = WScript.CreateObject('WScript.Shell');
var args = [];
for (var i = 0; i < WScript.Arguments.Length; i++) {
  args.push(WScript.Arguments.Item(i));
}
WshShell.CurrentDirectory = FileSystemObject.GetParentFolderName(
  WScript.ScriptFullName
);
var file = FileSystemObject.BuildPath(
  FileSystemObject.GetParentFolderName(WScript.ScriptFullName),
  FileSystemObject.GetBaseName(WScript.ScriptFullName) + '.ps1'
);
WshShell.Environment('Process').Remove('PSModulePath');
WScript.Quit(
  WshShell.Run(
    'powershell -NoLogo -NoProfile -ExecutionPolicy RemoteSigned -File "' +
      file +
      '"' +
      (args.length ? ' "' + args.join('" "') + '"' : ''),
    0,
    true
  )
);
