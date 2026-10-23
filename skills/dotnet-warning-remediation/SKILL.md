---
name: dotnet-warning-remediation
description: 'Systematic workflow for eliminating .NET/C# compiler warnings and code-analysis (CA/NU/CS) diagnostics from dotnet build output. Use when asked to fix build warnings, clean up a solution before a PR, resolve code analysis rules, or achieve a zero-warning build.'
license: Complete terms in LICENSE.txt
---

# .NET Compiler Warning Remediation

Drive a .NET solution from a build with warnings to a clean, warning-free
build by triaging diagnostics by rule ID and applying the matching fix
pattern.

## When to Use This Skill

- User asks to "fix the build warnings" or "clean up compiler warnings"
- A `dotnet build`/`dotnet build --configuration Release` run reports CA,
  NU, or CS diagnostics
- Preparing a PR where the verification loop requires zero warnings
- User mentions specific rule IDs (e.g., CA1515, CA2007, CA1303, NU1510)

## Step-by-Step Workflow

1. Run `dotnet build` (or `dotnet build --configuration Release`) and
   capture the full warning list, including project and line numbers.
2. Group warnings by rule ID. Fix one rule ID at a time across the whole
   solution rather than one file at a time — the fix pattern is usually
   identical for every occurrence of a rule.
3. Apply the fix pattern for that rule ID (see the reference table
   below).
4. Re-run `dotnet build` after each rule group. Confirm the targeted
   warnings are gone and no new warnings appeared.
5. Run the test suite (`dotnet test`) after each rule group that touches
   behavior (ConfigureAwait, type changes, caching) to confirm nothing
   broke.
6. Repeat until `dotnet build` reports zero warnings.
7. Never resolve a warning by suppressing it (`#pragma warning disable`,
   `<NoWarn>`, `[SuppressMessage]`). Only add a suppression when the rule
   is a genuine false positive for that specific case, and add a comment
   explaining why.

## Rule-to-Fix Reference

| Rule | Diagnostic | Fix | Risk |
|------|------------|-----|------|
| NU1510 | `PackageReference` will be pruned/unnecessary | Remove the reference once confirmed the package is an implicit/transitive dependency already provided by the SDK or another referenced package | Low — verify the type is still resolvable after removal |
| CA1515 | Type can be made `internal` | Remove `public` from types that aren't part of a published library's API surface | Low |
| CA1056 | `string` URL property should be `System.Uri` | Change the member type to `Uri`; update all call sites and serialization/config binding that reads the value | Medium — public API shape change |
| CA2007 | Missing `ConfigureAwait` on awaited task | Add `.ConfigureAwait(false)` on awaited calls in library/non-UI code; omit in ASP.NET Core app code and entry points where there's no captured context to avoid | Low |
| CA1869 | `JsonSerializerOptions` created repeatedly | Hoist the options instance into a `static readonly` field and reuse it across calls | Low |
| CA1859 | Parameter/return type hurts performance | Prefer concrete types (`List<T>`, `Dictionary<TKey, TValue>`, arrays) over interface types (`IReadOnlyList<T>`, `IReadOnlyDictionary<TKey, TValue>`) when the abstraction isn't required by callers | Medium — can change public signatures |
| CA1303 | Literal string should come from a resource table | Move the literal into a `.resx` resource file and reference it via the generated resource accessor; keep error/help/console text localizable | Medium — requires adding resource infrastructure if absent; confirm approach with the user first |
| CS7022 | Entry point ambiguity (test SDK auto-generated program) | Framework-generated; not user-fixable. Leave as-is unless the test SDK version is being changed | N/A |
| NETSDK1057 | Using a preview .NET SDK | Informational only; not a defect. Note it, don't attempt to "fix" it unless the user wants to pin a stable SDK via `global.json` | N/A |

## Gotchas

- **CA1303 and CA1056 are not purely mechanical** — CA1303 may require
  adding a `.resx` file and resource-management scaffolding where none
  exists; CA1056 changes a public member's type and can break callers or
  serialization. Apply the fix, but flag the broader impact instead of
  silently restructuring public contracts.
- **Don't fix file-by-file.** Grouping by rule ID catches every instance
  of the same pattern in one pass and avoids applying an inconsistent fix
  the second time around.
- **A warning count of zero includes CS warnings, not just CA/NU.** Don't
  stop after clearing analyzer (CA) rules if compiler (CS) warnings
  remain.
- **Suppressions are a last resort, not a cleanup shortcut.** Reaching
  zero warnings by adding `NoWarn` entries defeats the purpose of this
  workflow.

## References

- [`instructions/csharp.instructions.md`](../../instructions/csharp.instructions.md) — always-on C# coding standards, including a condensed version of this rule table.
- [`agents/csharp-dotnet-janitor.agent.md`](../../agents/csharp-dotnet-janitor.agent.md) — agent that drives bulk cleanup passes using this workflow.
