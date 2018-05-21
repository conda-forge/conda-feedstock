from __future__ import print_function

import subprocess
import sys

from conda_build.cli.main_build import main
import conda_build.utils

_rm_rf = conda_build.utils.rm_rf


def rm_rf(path, config=None):
        _check_call = subprocess.check_call
        def check_call(ps_open_args, *args, **kwargs):
            if isinstance(ps_open_args, str):
                ps_open_args = ps_open_args.replace('rd /s /q', 'del /F/S/Q')
                print('>>>>>> running monkeypatched call:', ps_open_args, file=sys.stderr)
            return _check_call(ps_open_args, *args, **kwargs)
        try:
            subprocess.check_call = check_call
            _rm_rf(path, config=config)
        finally:
            subprocess.check_call = _check_call


conda_build.utils.rm_rf = rm_rf

main()
