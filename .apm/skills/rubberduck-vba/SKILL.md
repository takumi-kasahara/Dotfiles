---
name: rubberduck-vba
description: "Create, update, or review VBA code with Rubberduck VB_Attribute annotations, unit tests, test lifecycle hooks, and VBA Moq doubles. Use when working on VBA modules, Rubberduck tests, or annotation and inspection quality."
argument-hint: "Provide the VBA component path, the behavior or change, and whether annotations, tests, implementation, or a combination are in scope."
user-invocable: true
---

# Rubberduck VBA Development

Use this skill to implement or maintain VBA components with accurate Rubberduck annotations and focused, deterministic unit tests. Apply only the parts relevant to the request: annotations, tests, production code, or a combination.

## Workflow

1. **Confirm scope and behavior.** Identify the target component, the requested behavior, and whether the task concerns production code, annotations, tests, or all three. Clarify expected inputs, outputs, state changes, errors, and external interactions before editing.
2. **Inspect the project conventions.** Locate the component and its related tests. Follow the repository's actual component and test paths rather than assuming a particular folder layout. Identify whether the component is a standard module (`.bas`), class module (`.cls`), or document module (`.vba`).
3. **Choose test coverage.** List the observable behaviors and edge cases to verify. Reuse a suitable test module or create one from [the test module template](./assets/TestModule1.bas). Keep each test module focused on one production component or coherent feature.
4. **Make the smallest appropriate implementation change.** When testability is a problem, prefer a narrow dependency seam or smaller responsibility over complex test setup. Do not add annotations that describe behavior the implementation does not have.
5. **Add or update annotations.** Use the placement guide below. Keep annotations adjacent to their targets and update them whenever a procedure or member is added, renamed, or changed.
6. **Write or update tests.** Use Arrange, Act, Assert (AAA), with one behavioral expectation per test. Select direct tests or doubles using the decision guide below.
7. **Validate.** Run Rubberduck Parse, relevant Code Inspections, and the related Unit Tests. Synchronize attributes after annotation changes if required by the project workflow. Resolve failures and newly introduced critical findings, then review that the annotations still match the final behavior.

## Rubberduck Annotation Guide

### Placement and supported scope

- Place annotations immediately above the module, field, procedure, or member they describe.
- Apply annotations to in-scope standard, class, and document modules. Keep class-only annotations on class modules.
- For property procedures, place member annotations on the relevant member; the generated attribute is typically attached to the `Get` member.
- When multiple annotations apply to the same scope, order them alphabetically by annotation name.
- Prefer Rubberduck annotations to ad-hoc comments for intent, usage, and behavior. Keep any suppression annotation justified and minimal.

### Common annotations

| Annotation                    | Target and purpose                                           | Scope / rule                                                                                                             |
| ----------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------ |
| `@ModuleDescription("...")`   | Module description (`VB_Description`)                        | Standard, class, and document modules                                                                                    |
| `@PredeclaredId`              | Predeclared class instance (`VB_PredeclaredId = True`)       | Class modules only                                                                                                       |
| `@Exposed`                    | Exposed class (`VB_Exposed = True`)                          | Class modules only                                                                                                       |
| `@VariableDescription("...")` | Description for a module field (`VB_VarDescription`)         | Immediately above the field                                                                                              |
| `@Description("...")`         | Procedure/property description (`MemberName.VB_Description`) | Immediately above the member                                                                                             |
| `@ExcelHotkey("D")`           | Excel macro shortcut (`VB_ProcData.VB_Invoke_Func`)          | Standard/document macro procedures; exactly one character. Lowercase maps to Ctrl+key; uppercase maps to Ctrl+Shift+key. |
| `@DefaultMember`              | Default class member (`VB_UserMemId = 0`)                    | Class modules; only one member                                                                                           |
| `@Enumerator`                 | Enumerator member (`VB_UserMemId = -4`)                      | Class modules; typically `NewEnum` returning `IUnknown`                                                                  |

Example:

```vb
'@ModuleDescription("Provides customer lookup operations")
Option Explicit

'@Description("Returns the customer with the requested identifier")
Public Function FindCustomer(ByVal customerId As Long) As Customer
End Function
```

Review module-level metadata and member-level annotations for class modules. Annotation wording must match parameter names, return behavior, and actual runtime behavior.

## Unit Test Design

Use named test procedures that make the expected behavior clear. Add optional lifecycle hooks only when needed:

- `@ModuleInitialize` / `@ModuleCleanup` for module-wide setup and teardown.
- `@TestInitialize` / `@TestCleanup` for per-test setup and teardown, especially to reset mutable state and prevent test leakage.
- Mark test modules and test procedures with the appropriate Rubberduck annotations, such as `@TestModule`, `@Folder`, and `@TestMethod`.

### Choose the test style

| Behavior                                                                            | Approach                                                               | Focus                                                                   |
| ----------------------------------------------------------------------------------- | ---------------------------------------------------------------------- | ----------------------------------------------------------------------- |
| Pure calculations, transforms, or branching                                         | Direct AAA test; no mock                                               | Return value, output argument, or result                                |
| Class state and lifecycle                                                           | Realistic call sequence; reset state as needed                         | State transitions and invariants                                        |
| Invalid inputs or unsupported operations                                            | Explicit failure-path test                                             | Expected error number and stable message contract                       |
| Required collaboration with workbook, worksheet, dialog, file, or COM collaborators | Use a narrow seam and VBA Moq mock/stub/spy                            | Required calls, arguments, count/order, and fallback behavior           |
| External side effects such as file writes or worksheet edits                        | Substitute a test double at the side-effect boundary                   | Requested action and observable result, without touching real resources |
| Regression or flaky behavior                                                        | Minimal reproducer; isolate shared state and timing/order dependencies | Defect does not recur and related behavior remains intact               |

Branching rules:

1. If behavior is pure and has no external dependency, write direct tests without mocks.
2. If behavior depends on external state or side effects, introduce or reuse a seam and use VBA Moq doubles only at the needed collaboration points.
3. If behavior has an error contract, test the expected failure explicitly; isolate one failure reason per test.
4. If tests are unstable, remove shared mutable state and time/order coupling before adding more setup.
5. Verify interactions only when the interaction itself is part of the requirement. Keep double setup small; if it becomes complex, reconsider production responsibility boundaries.

Prefer deterministic tests. Avoid dependence on machine-local paths, filesystem state, clock, locale, UI, or real COM state unless explicitly isolated. Do not mute failing tests; fix them or clearly document why they are intentionally pending.

## Completion Checklist

- [ ] The requested behavior and scope are clear; changes are limited to that scope.
- [ ] Annotations are correctly placed, valid for the module type, and consistent with code behavior.
- [ ] Tests use clear AAA structure and verify behavior rather than incidental implementation details.
- [ ] Doubles isolate only necessary dependencies and external side effects.
- [ ] Rubberduck Parse succeeds without syntax errors.
- [ ] Related Rubberduck Unit Tests pass consistently.
- [ ] No new critical Rubberduck inspection findings were introduced.
- [ ] Attributes are synchronized and the repository's relevant compile/build workflow succeeds, when available.

## References

- [Rubberduck VB_Attribute Annotations](https://github.com/rubberduck-vba/Rubberduck/wiki/VB_Attribute-Annotations)
- [Rubberduck Unit Testing](https://github.com/rubberduck-vba/Rubberduck/wiki/Unit-Testing)
- [VBA Moq Mocking Framework](https://github.com/rubberduck-vba/Rubberduck/wiki/VBA-Moq-Mocking-Framework)
