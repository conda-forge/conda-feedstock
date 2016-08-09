setlocal enabledelayedexpansion

:: Remove links and other scripts.
del %PREFIX%\Scripts\activate
del %PREFIX%\Scripts\activate.bat
del %PREFIX%\Scripts\conda-script.py
del %PREFIX%\Scripts\conda-script.pyc
del %PREFIX%\Scripts\conda.exe
del %PREFIX%\Scripts\deactivate
del %PREFIX%\Scripts\deactivate.bat
del %PREFIX%\exec\activate
del %PREFIX%\exec\activate.bat
del %PREFIX%\exec\conda-script.py
del %PREFIX%\exec\conda-script.pyc
del %PREFIX%\exec\conda.exe
del %PREFIX%\exec\deactivate
del %PREFIX%\exec\deactivate.bat

:: Prep conda install
set CONDA_DEFAULT_ENV=
echo %PKG_VERSION% > conda\.version

:: Install the Python code
%PYTHON% setup.py install --single-version-externally-managed --record=record.txt
if errorlevel 1 exit 1

:: Install the activation scripts.
copy %SRC_DIR%\bin\activate %PREFIX%\Scripts\activate
copy %SRC_DIR%\bin\activate.bat %PREFIX%\Scripts\activate.bat
copy %SRC_DIR%\bin\deactivate %PREFIX%\Scripts\deactivate
copy %SRC_DIR%\bin\deactivate.bat %PREFIX%\Scripts\deactivate.bat

:: Install fish activation script.
mkdir %PREFIX%\etc\fish\conf.d
cp %PREFIX%\shell\conda.fish > %PREFIX%\etc\fish\conf.d\conda.fish

del %SCRIPTS%\conda-init
if errorlevel 1 exit 1

:: Install links to scripts.
mkdir %PREFIX%\exec

for %%X in (bash.exe) do (set FOUND=%%~$PATH:X)
if defined FOUND (
   set "FWD_PREFIX=%PREFIX:\=/%"
   bash -c "ln -s !FWD_PREFIX!/Scripts/activate !FWD_PREFIX!/exec/activate"
   bash -c "ln -s !FWD_PREFIX!/Scripts/deactivate !FWD_PREFIX!/exec/deactivate"
   bash -c "ln -s !FWD_PREFIX!/Scripts/conda.exe !FWD_PREFIX!/exec/conda.exe"
   bash -c "ln -s !FWD_PREFIX!/Scripts/conda-script.py !FWD_PREFIX!/exec/conda-script.py"
)

echo "%PREFIX%\Scripts\activate.bat" %%* > %PREFIX%\exec\activate.bat
echo "%PREFIX%\Scripts\conda.exe" %%* > %PREFIX%\exec\conda.bat
