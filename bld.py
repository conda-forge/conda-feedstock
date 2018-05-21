from os.path import exists
from time import sleep

from conda_build.cli.main_build import main
import conda_build.utils

_rm_rf = conda_build.utils.rm_rf


def rm_rf(path, config=None):
    try:
        _rm_rf(path, config=config)
    except OSError:
        pass
    if exists(path):
        sleep(0.1)
        _rm_rf(path, config=config)


conda_build.utils.rm_rf = rm_rf

main()
