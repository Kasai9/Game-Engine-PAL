# Run from any folder: .\scripts\arena.ps1
# Builds root library + showcase, then launches the showcase on Windows.
$ErrorActionPreference = "Stop"
if (-not (Get-Command alr -ErrorAction SilentlyContinue)) { throw "Alire (alr) was not found. Install Alire and open a new terminal." }
$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$alireMsys = Join-Path $env:LOCALAPPDATA 'alire\cache\msys64'

# Both Alire MSYS2 UCRT64 and MinGW64 have been used by team members.
$flavors = if ($env:YARLIB_MSYS_FLAVOR) { @($env:YARLIB_MSYS_FLAVOR) } else { @('ucrt64', 'mingw64') }
$selected = $null
foreach ($flavor in $flavors) {
    $prefix = Join-Path $alireMsys $flavor
    if ((Test-Path (Join-Path $prefix 'lib\libSDL3.dll.a')) -and
        (Test-Path (Join-Path $prefix 'bin\SDL3.dll'))) {
        # libopengl32.a is not checked here: the GNAT toolchain ships it, and the MSYS2 mingw64 folder may not.
        $selected = $prefix
        break
    }
}
if (-not $selected) {
    throw "SDL3/OpenGL MSYS2 libraries were not found under $alireMsys. Install SDL3 and the matching MSYS2 CRT for the toolchain you use."
}

# Ensure Alire's nested Git dependency checkouts keep LF line endings.
# Git config environment overrides apply to child Git processes, without changing global config.
$env:GIT_CONFIG_COUNT = '1'
$env:GIT_CONFIG_KEY_0 = 'core.autocrlf'
$env:GIT_CONFIG_VALUE_0 = 'false'
$env:YARLIB_HOST_OS = 'windows'
$env:Path = (Join-Path $selected 'bin') + ';' + $env:Path
$libPath = Join-Path $selected 'lib'
$env:LIBRARY_PATH = if ($env:LIBRARY_PATH) { "$libPath;$env:LIBRARY_PATH" } else { $libPath }
$env:YARLIB_MSYS_LIB = $libPath   # read by showcase/showcase.gpr so the linker uses the same flavor

$prior = Get-Location
try {
    Set-Location $root
    Write-Host "Building YARLib (Windows)..."
    & alr build
    if ($LASTEXITCODE -ne 0) { throw 'YARLib build failed.' }

    Set-Location (Join-Path $root 'showcase')
    Write-Host 'Building showcase...'
    & alr build
    if ($LASTEXITCODE -ne 0) { throw 'Showcase build failed.' }

    Write-Host 'Launching Arena...'
    $arenaExe = Join-Path (Get-Location) 'bin\arena.exe'
    if (-not (Test-Path $arenaExe)) { throw "Arena executable missing: $arenaExe" }
    & $arenaExe
    if ($LASTEXITCODE -eq -1073741515) { throw 'Arena could not load a required DLL (0xC0000135). Verify SDL3.dll is installed for the matching Alire MSYS2 environment.' }
    if ($LASTEXITCODE -ne 0) { throw "Arena returned exit code $LASTEXITCODE" }
}
finally { Set-Location $prior }
