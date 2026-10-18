$ErrorActionPreference = "Stop"

Write-Host "🔎 Checking NuGet packages..."

dotnet restore

if ($LASTEXITCODE -ne 0) {
    throw "NuGet restore failed."
}

dotnet list package --outdated

if ($LASTEXITCODE -ne 0) {
    throw "NuGet package check failed."
}

Write-Host "🔨 Building solution..."

dotnet build --no-restore

if ($LASTEXITCODE -ne 0) {
    throw "Build failed."
}

Write-Host "🧪 Running tests..."

dotnet test --no-build

if ($LASTEXITCODE -ne 0) {
    throw "Tests failed."
}

Write-Host "✅ Repository ready for commit."