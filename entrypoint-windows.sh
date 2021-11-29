#!/bin/bash

# Fail on errors.
set -e

# Make sure .bashrc is sourced
. /root/.bashrc

# Allow the workdir to be set using an env var.
# Useful for CI pipiles which use docker for their build steps
# and don't allow that much flexibility to mount volumes
WORKDIR=${SRCDIR:-/src}

# Options
if [[ "${OPTIONS}" == "" ]]; then
    # --onefile Create a one-file bundled executable.
    # --clean Clean PyInstaller cache and remove temporary files before building.
    # --noconfirm Replace output directory without asking for confirmation
    # --distpath Where to put the bundled app
    # --workpath Where to put all the temporary work files
    OPTIONS="--clean --noconfirm --distpath ./dist/${WINEARCH} --workpath /tmp"
fi

# In case the user specified a custom URL for PYPI, then use
# that one, instead of the default one.
if [[ "$PYPI_URL" != "https://pypi.python.org/" ]] || \
   [[ "$PYPI_INDEX_URL" != "https://pypi.python.org/simple" ]]; then
    # the funky looking regexp just extracts the hostname, excluding port
    # to be used as a trusted-host.
    mkdir -p /wine/drive_c/users/root/pip
    echo "[global]" > /wine/drive_c/users/root/pip/pip.ini
    echo "index = $PYPI_URL" >> /wine/drive_c/users/root/pip/pip.ini
    echo "index-url = $PYPI_INDEX_URL" >> /wine/drive_c/users/root/pip/pip.ini
    echo "trusted-host = $(echo $PYPI_URL | perl -pe 's|^.*?://(.*?)(:.*?)?/.*$|$1|')" >> /wine/drive_c/users/root/pip/pip.ini

    echo "Using custom pip.ini: "
    cat /wine/drive_c/users/root/pip/pip.ini
fi

cd $WORKDIR

echo "$@"

if [[ "$@" == "" ]]; then
    if [ -f requirements.txt ]; then
        pip install -r requirements.txt
    fi
    echo "Running pyinstaller with options ${OPTIONS}"
    pyinstaller ${OPTIONS} *.spec
    chown -R --reference=. ./dist/${WINEARCH}
else
    sh -c "$@"
fi
