@echo off
cls

tniasm.exe %1 %2

rem Do Error Beep (BEL)
set ERR=%ERRORLEVEL%
if %ERR% neq 0 (
    @echo 
    @echo 
)
exit /b %ERR%


