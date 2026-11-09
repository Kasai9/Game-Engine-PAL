# Game Engine PAL — portable cross-platform test copy

This is a **test package**, not a replacement for the team's three tested versions. The source files were compared against Andres's, Chase's, and Jacob's supplied archives. Do not replace a working checkout or merge to `main` before each teammate tests this candidate on their actual computer.

## What changed

- `yarlib.gpr`: use `YARLIB_HOST_OS` (`windows`, `macos`, or `linux`) only to select OpenGL linker flags. The existing renderer (`software` vs `opengl`) and platform (`null` vs `sdl3`) logic remains unchanged.
- `alire.toml`: declare the optional GPR external `YARLIB_HOST_OS` with Linux as its default.
- `ports/renderer/opengl/yarlib-renderer.adb`: preserve Jacob's explicit `System.Storage_Elements."+"` rename for address arithmetic.
- `scripts/arena.ps1`: Windows builds and launches; detects Alire's UCRT64 or MinGW64 SDL3 and OpenGL import libraries.
- `scripts/arena-macos.sh`: macOS builds and launches; detects SDL3 through Homebrew or pkg-config.
- `.gitattributes`: force LF source checkout. `.gitignore`: ignore macOS ZIP metadata.

No game logic, tests, engine packages, or seed architecture documentation were edited. Chase's Windows hard-coded `showcase.gpr` linker path was deliberately **not** carried into the shared project because it only works for MinGW64 and breaks UCRT64/macOS. His Windows `-lopengl32` fix is preserved through the OS-aware `yarlib.gpr` instead. Chase's `gnatprove` showcase-specific dependency was not added: it is unrelated to starting the arena and may require separate validation. All those original files remain in the supplied ZIP archives.

## Requirements

- Ada/GNAT and Alire (`alr`) available in PATH.
- Windows: Alire MSYS2 at `%LOCALAPPDATA%\alire\cache\msys64`, with SDL3 plus the matching CRT/import libraries installed in either `ucrt64` or `mingw64`. Run the Windows launcher in PowerShell. It sets only **process-local** environment variables, including a Git `core.autocrlf=false` override for Alire dependency clones. The shared `.gitattributes` handles LF for the main repository.
- macOS: working Ada/Alire toolchain and SDL3 installed (for example with `brew install sdl3`). Run the macOS launcher in Terminal. It sets only **process-local** environment variables, including a Git `core.autocrlf=false` override for Alire dependency clones. The shared `.gitattributes` handles LF for the main repository.
- Linux: retains original `-lGL`; install SDL3 and OpenGL development libraries and run existing Alire commands. No custom Linux launcher included.

## Build and launch

**Windows (PowerShell, from repository root):**

```powershell
.\scripts\arena.ps1
```

If both `ucrt64` and `mingw64` have SDL3 and you know which toolchain you use, set `$env:YARLIB_MSYS_FLAVOR = 'ucrt64'` (or `'mingw64'`) before launching.

**macOS (Terminal, from repository root):**

```bash
bash scripts/arena-macos.sh
```

Both launchers run `alr build` at the root, `alr build` in `showcase`, then start `arena`. They do not run `git push`, edit personal profile files, or write to teammates' machines.

**Existing personal shortcuts:** Andres's current PowerShell `arena` profile function is **not** included: PowerShell profiles are machine-specific. It can continue to be used, or can later call the shared script after local verification.

## Team acceptance checklist (complete on all 3 machines before merging)

1. Make a new independent folder by cloning the team repository, then apply this candidate on a new branch — do not replace any of the working folders.
2. Confirm `alr --version` and the proper SDL3 installation.
3. Run the appropriate launcher; confirm `alr build` succeeds in root and showcase.
4. Confirm the gray seed window opens and closes cleanly. The milestone-1 batcher may still drop quads as before; that is expected in this seed.
5. Run the root tests: `cd tests`, `alr build`, run `bin/tests` (Windows `bin\tests.exe`), and check for expected seed results.
6. Run engine tests in `engine/tests` as appropriate and compare with your previously working version.
7. Capture and report logs from each OS and compare expected demo behavior. Only then merge to `main`.

**Known limitations:** I was able to compare the ZIP contents and run structural checks, but could not run Ada/Alire or exercise Windows/macOS graphics in the analysis environment. This candidate is *not* certified to work on all three PCs until it passes the above tests. Mac hardware/toolchain details remain unconfirmed.

## Safe Git workflow

Each teammate clones the same repo, develops on their own branch, opens a pull request, checks tests and OS compatibility, and merges only after review. Build products under `obj/`, `bin/`, `lib/`, `alire/`, and `config/` stay local and must not be committed.

## Portable ZIP quick start (updated)

Extract the ZIP anywhere. The launchers resolve the project directory from their own location, so no user-specific project path is required.

**Windows:** Open PowerShell in the extracted `Game-Engine-PAL` directory and run `powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\scripts\arena.ps1"`. This sets the SDL3 DLL search path **for that process only**, builds the library and showcase, and launches Arena. A successful root `alr build` alone does not build the showcase.

**macOS:** Open Terminal in the extracted `Game-Engine-PAL` directory and run `bash scripts/arena-macos.sh`. Install Alire/GNAT and SDL3 separately as described above.

**Windows security:** Smart App Control or other application-control policies may block unsigned toolchain executables. This ZIP does not modify or bypass Windows security settings. A successful build on one machine does not guarantee a build on another.

**Important:** These scripts do not make compiler, Alire, SDL3, or system dependencies portable. Each teammate must install those dependencies locally. The Windows launch script has not been executed on a Windows host in this packaging environment; the earlier version was tested on Andres's machine but hit a dependency checkout error. macOS remains unverified.

## Merged version (Chase and Andres, 10/21/2026)

This copy combines Andres's portable copy with Chase's Windows fixes.

- `yarlib.gpr`: `YARLIB_HOST_OS` (`windows`, `macos`, `linux`) selects the OpenGL link flag. When it is not set, Windows is detected from the `OS` environment variable (so a plain `alr build` works on Windows) and everything else defaults to Linux. macOS needs `scripts/arena-macos.sh`, which sets it.
- `showcase/showcase.gpr`: on Windows it adds `-L` for Alire's MSYS2 library folder. `scripts/arena.ps1` passes the folder it found (`ucrt64` or `mingw64`) in `YARLIB_MSYS_LIB`. Without the script it falls back to `mingw64`. Other systems add no path.
- `vendor/bedrock`: bedrock is vendored and pinned by path in `alire.toml`, `showcase/alire.toml`, `engine/alire.toml`, `engine/showcase/alire.toml` and `engine/tests/alire.toml`.
- `engine/alire.toml` has no `portal` dependency. portal's manifest pins bedrock to GitHub, which conflicts with the vendored copy. Nothing in the project uses portal yet. Vendor portal the same way, or wait for a release, before adding it.
- `engine/showcase/alire.toml` keeps Chase's `gnatprove` dependency.
- `scripts/arena.ps1` no longer requires `libopengl32.a` in the MSYS2 folder, because the GNAT toolchain provides it.

Tested on Windows 11 with Alire 2.1.1, GNAT 16.1.0 and `mingw64` SDL3 3.4.16: root, `tests`, `showcase`, `engine`, `engine/showcase`, `engine/tests` build, and both test suites pass. Not tested: `ucrt64`, macOS, Linux.
