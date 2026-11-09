---
document type: cmdlet
external help file: parse.ps1-Help.xml
HelpUri: ''
Locale: ja-JP
Module Name: ''
ms.date: 11/09/2026
PlatyPS schema version: 2024-05-01
title: parse.ps1
---

# parse.ps1

## SYNOPSIS

Parses PowerShell files and reports syntax errors.

## SYNTAX

### __AllParameterSets

```
parse.ps1 [-Path] <string[]> [-Include <string[]>] [-Exclude <string[]>] [-Recurse]
 [-OutputPath <string>]
```

## ALIASES

This cmdlet has the following aliases,
{{Insert list of aliases}}

## DESCRIPTION

Uses `System.Management.Automation.Language.Parser` to parse each specified file and outputs any parse errors as JSON.

## EXAMPLES

## PARAMETERS

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

### -OutputPath

Path to the JSON file to write the parse errors.
Defaults to errors.json in the current directory.

```yaml
Type: System.String
DefaultValue: errors.json
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

One or more file paths to parse.
Supports pipeline and remaining arguments.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

- [](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.language.parser.parsefile?view=powershellsdk-7.4.0)
