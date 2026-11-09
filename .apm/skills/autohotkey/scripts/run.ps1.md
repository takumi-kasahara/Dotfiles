---
document type: cmdlet
external help file: run.ps1-Help.xml
HelpUri: ''
Locale: ja-JP
Module Name: ''
ms.date: 11/09/2026
PlatyPS schema version: 2024-05-01
title: run.ps1
---

# run.ps1

## SYNOPSIS

Runs one or more AutoHotkey v2 scripts via AutoHotkey.exe.

## SYNTAX

### __AllParameterSets

```
run.ps1 [-Path] <string[]> [-Include <string[]>] [-Exclude <string[]>] [-Recurse]
 [-Switches <string[]>] [-ArgumentList <string[]>]
```

## ALIASES

This cmdlet has the following aliases,
{{Insert list of aliases}}

## DESCRIPTION

Finds AutoHotkey.exe on the system and uses it to execute the specified `.ahk` files.
The script resolves AutoHotkey.exe from the PATH first, then falls back to a recursive search under $env:ProgramFiles.
Output from each script is streamed to the console.

## EXAMPLES

## PARAMETERS

### -ArgumentList

Additional arguments to pass to Script.
These are forwarded after the script path.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
  - Name: (All)
    Position: Named
    IsRequired: false
    ValueFromPipeline: false
    ValueFromPipelineByPropertyName: false
    ValueFromRemainingArguments: true
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Exclude

Specifies glob patterns to exclude.
Items matching any pattern are excluded.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
  - Name: (All)
    Position: Named
    IsRequired: false
    ValueFromPipeline: false
    ValueFromPipelineByPropertyName: false
    ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Include

Specifies glob patterns to include.
Only items matching at least one pattern are considered.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
  - Name: (All)
    Position: Named
    IsRequired: false
    ValueFromPipeline: false
    ValueFromPipelineByPropertyName: false
    ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Path

One or more file paths to AutoHotkey script files.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
  - Name: (All)
    Position: 0
    IsRequired: true
    ValueFromPipeline: false
    ValueFromPipelineByPropertyName: false
    ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Recurse

Searches the specified path recursively.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
  - Name: (All)
    Position: Named
    IsRequired: false
    ValueFromPipeline: false
    ValueFromPipelineByPropertyName: false
    ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Switches

Additional switches to pass to AutoHotkey.exe.
These are inserted before the script path.

```yaml
Type: System.String[]
DefaultValue: "@('/ErrorStdOut')"
SupportsWildcards: false
Aliases: []
ParameterSets:
  - Name: (All)
    Position: Named
    IsRequired: false
    ValueFromPipeline: false
    ValueFromPipelineByPropertyName: false
    ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

- [](https://www.autohotkey.com/docs/v2/Scripts.htm#cmd)
