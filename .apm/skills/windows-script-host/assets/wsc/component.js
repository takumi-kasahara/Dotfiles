'use strict';

var FileSystemObject = WScript.CreateObject('Scripting.FileSystemObject');
var path = FileSystemObject.BuildPath(
  FileSystemObject.GetParentFolderName(WScript.ScriptFullName),
  'component.wsc'
);
var object = GetObject('Script:' + path);
WScript.Echo(object.methodname());
