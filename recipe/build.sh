#!/bin/bash

# Remove symlinks (if they exist, when bootstrapping, they will not).
unlink $PREFIX/bin/conda || true
unlink $PREFIX/bin/activate || true
unlink $PREFIX/bin/deactivate || true

# Prep conda install
[[ -d conda ]] || mkdir conda
export CONDA_DEFAULT_ENV=''
echo "${PKG_VERSION}" > conda/.version

# Install the Python code. We cannot use setup.py here because setuptools becomes
# a transitive dependency once you list the conda dependencies properly and when
# you do that, setup.py doesn't install the {de,}activate scripts.
# $PYTHON utils/setup-testing.py install
$PYTHON conda.recipe/setup.py install

# Install the fish activation script.
mkdir -p $PREFIX/etc/fish/conf.d/
cp $SRC_DIR/shell/conda.fish $PREFIX/etc/fish/conf.d/
