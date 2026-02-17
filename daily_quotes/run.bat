@echo off
setlocal
chcp 65001 >nul
cls

echo.
echo Yo bro! Ready to Run? 🏃‍♂️
echo.
echo Kaise run karna hai? 🤔
echo 1. Dev Mode (Logs ON --dart-define=verma=true) 📃
echo 2. Production Mode (Logs OFF - Clean) 🔇
echo.
set /p mode="Select kar bhai (1/2): "

if "%mode%"=="1" goto dev
if "%mode%"=="2" goto prod

echo.
echo Arey bhai, 1 ya 2 dabana tha! 🤦‍♂️
goto end

:dev
echo.
echo 🟢 Starting DEV MODE (Logs Enabled)... 🚀
echo.
flutter run --dart-define=verma=true
goto end

:prod
echo.
echo 🔴 Starting PRODUCTION MODE (Logs Disabled)... 🤫
echo.
flutter run
goto end

:end
echo.
pause
