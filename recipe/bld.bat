echo %PKG_VERSION% > conda\.version
%PYTHON% setup.py install --single-version-externally-managed --record record.txt
if %errorlevel% neq 0 exit /b %errorlevel%

set
%PYTHON% -m pip list
%PYTHON% -m conda info -a

%PYTHON% -m conda init --install
if %errorlevel% neq 0 exit /b %errorlevel%
