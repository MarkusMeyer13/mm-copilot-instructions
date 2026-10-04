# Agent Instructions: C# & GitHub Copilot PR Workflow

## Project Context
This is a C# .NET 8 / .NET 9 project. We enforce strict type safety, asynchronous patterns, clean architecture, and automated PR management via the GitHub CLI.

## Automated Verification & Pre-Flight Loop
Before creating a Pull Request, you MUST execute the following verification loop in order. Do not skip any step:

1. **Restore:** `dotnet restore`
2. **Build:** `dotnet build --configuration Release` (Must pass with 0 errors and 0 warnings)
3. **Format:** `dotnet format` (Fix whitespace, style, and analyzer rules automatically)
4. **Test:** `dotnet test --no-build --configuration Release` (All tests must pass)

## C# Coding Style & Constraints
- **Asynchronous Code:** Always use `async`/`await` for I/O operations. Append `Async` suffix to all async methods. Never use `.Result` or `.Wait()`.
- **Null Safety:** Strict Nullable Reference Types (`<Nullable>enable</Nullable>`) are active. Resolve all compiler nullability warnings. Avoid `!` (null-forgiving operator) unless explicitly documented.
- **Dependency Injection:** Register dependencies using the appropriate lifetime (`Transient`, `Scoped`, `Singleton`).

## GitHub PR Workflow (via GitHub CLI)
When tasked with preparing a change or creating a Pull Request, automate the process using the `gh` CLI.

### 1. Branching & Commits
- Base all new branches on `main`.
- Branch format: `feature/short-description` or `bugfix/short-description`.
- Use Conventional Commits for all commits (e.g., `feat: login endpoint`, `fix: null pointer in service`).

### 2. PR Generation via GitHub CLI
Do not ask the user to manually create the PR. Use the GitHub CLI to generate and submit it. Use Copilot's capability to draft the body based on the template below.

**Execute the following command structure:**
```bash
gh pr create --title "<type>(<scope>): <short description>" --body-file - <<EOF
## Summary
- Brief bullet-point overview of WHAT was changed and WHY.

## Verification Checklist
- [x] \`dotnet build\` passes with zero errors and warnings.
- [x] \`dotnet format\` has been executed.
- [x] \`dotnet test\` passes successfully.

## Architectural Notes
- (Mention any EF Core migrations, appsettings.json updates, or new NuGet packages here.)
EOF
```

*Note: If the user prefers a draft PR first, append the `--draft` flag to the command.*

## Boundaries & Safety
- **No Foreign CLI Tools:** Always use `gh` for GitHub actions. Do not attempt to use UI workarounds.
- **Database Migrations:** If modifying Entity Framework entities, ask the user before running `dotnet ef migrations add`. Never commit an EF migration without explicit confirmation.
