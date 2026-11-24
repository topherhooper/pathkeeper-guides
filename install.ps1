# Checks the guides, then copies the addon into the WoW Forever AddOns folder.
# Run from anywhere:  powershell -ExecutionPolicy Bypass -File install.ps1
param(
    [string]$AddOns = 'C:\Program Files (x86)\World of Warcraft\_forever_\Interface\AddOns'
)
$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$src = Join-Path $here 'PathKeeper_OurGuides'
if (-not (Test-Path $AddOns)) { throw "AddOns folder not found: $AddOns" }
if (-not (Test-Path (Join-Path $AddOns 'PathKeeper'))) { Write-Warning 'PathKeeper itself is not installed in that AddOns folder.' }

if (Test-Path (Join-Path $here 'node_modules\fengari')) {
    & node (Join-Path $here 'tools\check.mjs')
    if ($LASTEXITCODE -ne 0) { throw 'The guide check failed, so nothing was installed.' }
} else {
    Write-Warning 'Skipping the guide check (run "npm install" in this folder once to enable it).'
}

& robocopy.exe $src (Join-Path $AddOns 'PathKeeper_OurGuides') /MIR /R:2 /W:2 /NFL /NDL /NJH /NJS /NP | Out-Null
if ($LASTEXITCODE -ge 8) { throw "Copy failed (robocopy exit code $LASTEXITCODE)." }
Write-Host "Installed to $AddOns\PathKeeper_OurGuides. In game: /reload if only guide files changed; restart WoW after adding a new file or the first install."
exit 0
