---
document type: cmdlet
external help file: Install.Registry.ps1-Help.xml
HelpUri: ''
Locale: ja-JP
Module Name: ''
ms.date: 11/09/2026
PlatyPS schema version: 2024-05-01
title: Install.Registry.ps1
---

# Install.Registry.ps1

## SYNOPSIS

Imports registry settings and runs configuration scripts.

## SYNTAX

### __AllParameterSets

```
Install.Registry.ps1
```

## ALIASES

This cmdlet has the following aliases,
{{Insert list of aliases}}

## DESCRIPTION

Imports all *.reg files under Windows\Settings recursively and runs all *.cmd scripts under Windows\Scripts.
Also copies user international settings to the welcome screen and new user profile, then restarts Explorer.

## EXAMPLES

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

Requires administrator privileges to import registry settings and modify system configuration.

## RELATED LINKS

{{ Fill in the related links here }}
