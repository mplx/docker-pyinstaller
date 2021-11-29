# PyInstaller Docker Images

This repo ist a fork from [white-gecko/docker-pyinstaller](https://github.com/white-gecko/docker-pyinstaller) which is forked from [cdrx/docker-pyinstaller](https://github.com/cdrx/docker-pyinstaller).

## Python

- Phyton 3.8.8 (executable runs on Win 7; requires KB2533623 or KB3063858)
- PyInstaller 4.7

## Usage

Build for Micrsoft Windows platform:

- `docker run --rm -v "$(pwd):/src" ghcr.io/mplx/docker-pyinstaller:master-py3-win32` builds to `dist/win32`
- `docker run --rm -v "$(pwd):/src" ghcr.io/mplx/docker-pyinstaller:master-py3-win64` builds to `dist/win64`
