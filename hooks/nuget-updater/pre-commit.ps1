$ErrorActionPreference = "Stop"

# Read the JSON payload supplied by GitHub Copilot.
$rawInput = :In.ReadToEnd()

# If there is no input, this is probably a manual invocation.
# Do not block anything.
if (:IsNullOrWhiteSpace($rawInput)) {
    exit 0
}

try {
    $hookInput = $rawInput | ConvertFrom-Json
}
catch {
    # Important:
    # Never block normal Copilot operation just because the
    # preToolUse payload could not be parsed.
    exit 0
}

# Only inspect shell/tool executions.
$toolName = [string]$hookInput.toolName
$toolArgs = $hookInput.toolArgs

if (:IsNullOrWhiteSpace($toolName)) {
    exit 0
}

# Convert tool arguments into something we can inspect.
if ($toolArgs -is [string]) {
    $command = $toolArgs
}
else {
    $command = $toolArgs | ConvertTo-Json -Depth 10 -Compress
}

if (:IsNullOrWhiteSpace($command)) {
    exit 0
}

# ------------------------------------------------------------
# IMPORTANT:
# This hook is interested ONLY in an actual git commit command.
# Everything else must pass through untouched.
# ------------------------------------------------------------

$isGitCommit = $command -match '(?i)(^|[\s;"''])(git\s+commit)(\s|$)'

if (-not $isGitCommit) {
    exit 0
}

# ------------------------------------------------------------
# From here on we know Copilot intends to execute git commit.
# ------------------------------------------------------------

Write-Host "NuGet pre-commit validation started." -ForegroundColor Cyan

# Determine repository root.
$repoRoot = git rev-parse --show-toplevel 2>$null

if ($LASTEXITCODE -ne 0 -or :IsNullOrWhiteSpace($repoRoot)) {
    Write-Error "Unable to determine Git repository root."
    exit 1
}

Push-Location $repoRoot

try {

    Write-Host ""
    Write-Host "[1/5] Restoring NuGet packages..." -ForegroundColor Cyan

    dotnet restore

    if ($LASTEXITCODE -ne 0) {
        throw "dotnet restore failed."
    }


    Write-Host ""
    Write-Host "[2/5] Checking outdated NuGet packages..." -ForegroundColor Cyan

    dotnet list package --outdated

    if ($LASTEXITCODE -ne 0) {
        throw "NuGet outdated package check failed."
    }


    Write-Host ""
    Write-Host "[3/5] Checking vulnerable NuGet packages..." -ForegroundColor Cyan

    dotnet list package --vulnerable

    if ($LASTEXITCODE -ne 0) {
        throw "NuGet vulnerability check failed."
    }


    Write-Host ""
    Write-Host "[4/5] Building repository..." -ForegroundColor Cyan

    dotnet build --no-restore

    if ($LASTEXITCODE -ne 0) {
        throw "dotnet build failed."
    }


    Write-Host ""
    Write-Host "[5/5] Running tests..." -ForegroundColor Cyan

    dotnet test --no-build

    if ($LASTEXITCODE -ne 0) {
        throw "dotnet test failed."
    }


    Write-Host ""
    Write-Host "Pre-commit validation successful." -ForegroundColor Green

    exit 0
}
catch {

    Write-Error $_

    Write-Host ""
    Write-Host "Commit blocked by NuGet pre-commit validation." -ForegroundColor Red

    exit 1
}
finally {

    Pop-Location

}