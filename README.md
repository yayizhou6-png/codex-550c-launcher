# Codex 550C Launcher

一个 Windows 独立启动器：打开 Codex 的同时，播放 `dsh-550c-boot` 项目提供的原始 550C 片头动画。

This project uses the original `550C-source.html` animation as an external splash window. It does not patch, inject into, or modify the Codex application.

## Features

- Directly hosts the original 550C HTML animation; no visual reimplementation.
- Starts the installed Codex app underneath the splash screen.
- Uses a temporary, isolated Microsoft Edge profile.
- Closes only the temporary Edge process after the splash timing completes.
- Does not modify Codex projects, conversations, configuration, game settings, or Windows startup entries.

## Requirements

- Windows 10 or Windows 11
- Microsoft Edge
- Codex installed and visible in the Windows Start menu

## Usage

1. Download or clone this repository to a local directory.
2. Double-click `启动Codex-550C.cmd`.
3. The original 550C splash plays for a few seconds, then the temporary splash window closes and Codex remains open.

The normal Codex Start menu shortcut is intentionally left unchanged. To stop using the splash, launch Codex normally.

## Files

- `codex-550c-launcher.ps1` — starts Codex and hosts the original splash.
- `启动Codex-550C.cmd` — double-click entry point.
- `codex-550c-original/550C-source.html` — original upstream animation source.
- `codex-550c-original/LICENSE` — upstream license.
- `codex-550c-original/UPSTREAM-CREDITS.md` — upstream attribution.

## Attribution

The 550C animation and terminal interface are credited to Voidpoket and the original `dsh-550c-boot` project:

- https://github.com/yannicksong0106/dsh-550c-boot
- https://github.com/Voidpoket

Please preserve the upstream license and attribution when redistributing this project.

## License

The launcher wrapper is released under the MIT License. The original animation remains subject to the upstream license in `codex-550c-original/LICENSE`.
