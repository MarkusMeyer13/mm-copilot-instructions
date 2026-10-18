# Copilot Commit Hooks

This directory contains repository-level hooks for GitHub Copilot CLI.

The hooks add automated quality checks to Copilot's workflow before changes are committed to Git.

## Purpose

When GitHub Copilot CLI attempts to create a Git commit, the commit hook validates the repository before allowing the commit to continue.

For .NET repositories the validation can include:

- NuGet restore
- outdated NuGet package detection
- vulnerable NuGet package detection
- build validation
- unit/integration tests

The goal is to prevent Copilot from committing changes that leave the repository in an unhealthy state.

## Structure

```text
mm-copilot-instructions/
└── hooks/
    └── nuget-updater/
        ├── hooks.json
        ├── README.md
        └── pre-commit.ps1
```

## Hook Configuration

The hook is configured in:

```text
mm-copilot-instructions/hooks/nuget-updater/hooks.json
```

Example:

```json
{
  "version": 1,
  "hooks": {
    "preToolUse": [
      {
        "type": "command",
        "powershell": "mm-copilot-instructions/hooks/nuget-updater/pre-commit.ps1",
        "cwd": ".",
        "timeoutSec": 300
      }
    ]
  }
}
```

## How It Works

The `preToolUse` hook is executed before GitHub Copilot CLI invokes a tool.

Because `preToolUse` is not specific to Git commits, the PowerShell script inspects the hook input and determines whether Copilot is attempting to execute:

```text
git commit
```

If the tool invocation is unrelated to a commit, the script exits without performing the validation pipeline.

For a commit operation, the intended workflow is:

```text
Copilot
   │
   │ wants to execute "git commit"
   ▼
preToolUse
   │
   ▼
pre-commit.ps1
   │
   ├── dotnet restore
   │
   ├── check outdated NuGet packages
   │
   ├── check vulnerable NuGet packages
   │
   ├── dotnet build
   │
   └── dotnet test
          │
          ├── FAILED ──► block commit
          │
          └── SUCCESS ─► allow commit
```

## NuGet Policy

Dependency updates should be handled conservatively.

Recommended policy:

### Patch updates

Example:

```text
8.0.1 → 8.0.2
```

May be updated automatically.

### Minor updates

Example:

```text
8.1.0 → 8.2.0
```

May be updated automatically if the project continues to build and all tests pass.

### Major updates

Example:

```text
8.x → 9.x
```

Must not be applied automatically.

Major upgrades can contain breaking API or runtime changes and should be reviewed separately.

## Validation Pipeline

A commit should only continue after the following checks have completed successfully:

```powershell
dotnet restore
dotnet list package --outdated
dotnet list package --vulnerable
dotnet build --no-restore
dotnet test --no-build
```

> The exact commands executed are controlled by `pre-commit.ps1`. This README describes the intended repository policy.

## Failure Behaviour

If one of the required validation steps fails, the commit should be rejected.

Typical reasons include:

- NuGet restore failure
- vulnerable dependency policy violation
- compilation error
- failing test
- invalid project configuration

The corresponding error should be written to the hook output so that Copilot can react to the problem instead of continuing with the commit.

## Copilot Instructions

The hook provides the technical enforcement.

Repository instructions can additionally tell Copilot how dependency updates should be handled.

For example, `.github/copilot-instructions.md` can contain:

```markdown
## Commit policy

Before committing changes:

- respect the repository commit hooks
- investigate failed dependency checks
- never bypass a failed commit hook
- do not automatically perform major NuGet upgrades
- after dependency changes, restore, build and test the solution
- include dependency updates in the commit summary
```

This provides two layers:

```text
copilot-instructions.md
        │
        │ Agent behaviour
        ▼
     Copilot
        │
        │ Technical enforcement
        ▼
    hooks.json
        │
        ▼
pre-commit.ps1
```

## Local Testing

The PowerShell script should also be executable independently of Copilot.

This makes it possible to validate changes while developing the hook:

```powershell
pwsh mm-copilot-instructions/hooks/nuget-updater/pre-commit.ps1
```

When debugging the Copilot-specific behaviour, remember that the `preToolUse` hook receives information about the tool invocation through its hook input.

## Requirements

The repository requires:

- Git
- .NET SDK
- PowerShell 7+ on Windows
- GitHub Copilot CLI

Verify PowerShell with:

```powershell
pwsh --version
```

Verify .NET with:

```powershell
dotnet --info
```

## Updating Hooks

GitHub Copilot CLI loads hook configuration when the CLI starts.

After changing `hooks.json`, restart the Copilot CLI before testing the changed configuration.

## Design Principle

The hook should remain deterministic.

Copilot decides **what it wants to do**.

The hook decides **whether the repository is healthy enough to allow it**.

In other words:

> Copilot proposes. The build disposes. 🤠