from __future__ import print_function

from io import BytesIO
import os
import subprocess
import sys

from conda_build.cli.main_build import main
import conda_build.utils

_rm_rf = conda_build.utils.rm_rf


def rm_rf(path, config=None):
        _check_call = subprocess.check_call
        def check_call(popen_args, *args, **kwargs):
            rd_str = 'rd /s /q'
            if not (isinstance(popen_args, str) and rd_str in popen_args):
                return _check_call(popen_args, *args, **kwargs)
            popen_args = popen_args.replace(rd_str, 'del /F /S /Q')
            print('>>>>>> running monkeypatched call:', popen_args, file=sys.stderr)
            out_stream = BytesIO()
            kwargs['stdout'] = out_stream
            ret = _check_call(popen_args, *args, **kwargs)
            for line in out_stream.getvalue().splitlines():
                print(line)
            return ret
        try:
            subprocess.check_call = check_call
            _rm_rf(path, config=config)
        finally:
            subprocess.check_call = _check_call


conda_build.utils.rm_rf = rm_rf

main()
