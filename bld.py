from __future__ import print_function

from os.path import exists
import sys
from time import sleep

from conda.common.io import captured
from conda_build.cli.main_build import main
import conda_build.utils

_rm_rf = conda_build.utils.rm_rf


def rm_rf(path, config=None):
    with captured() as c:
        try:
            _rm_rf(path, config=config)
        except OSError:
            pass
    for output, stream in ((c.stdout, sys.stdout), (c.stderr, sys.stderr)):
        if output:
            print(
                *(
                    line for line in output.splitlines()
                    if not line.endswith(' - Access is denied.')
                ),
                sep='\n', file=stream)
    if exists(path):
        sleep(0.1)
        _rm_rf(path, config=config)


conda_build.utils.rm_rf = rm_rf

main()
