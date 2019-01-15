:: Delegate to the Unixy script. We need to translate the key path variables
:: to be Unix-y rather than Windows-y, though.
echo %PKG_VERSION% > conda\.version
%PYTHON% setup.py install --single-version-externally-managed --record record.txt
if %errorlevel% neq 0 exit /b %errorlevel%

%PYTHON% -m conda init --install
if %errorlevel% neq 0 exit /b %errorlevel%
