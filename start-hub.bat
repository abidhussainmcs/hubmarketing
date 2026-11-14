@echo off
title CPP Sales Hub
cd /d "%~dp0"
where docker >nul 2>nul || (echo Docker isn't installed or isn't on the PATH. Install Docker Desktop first. & pause & exit /b 1)
docker info >nul 2>nul || (echo Docker Desktop isn't running. Open Docker Desktop, wait for it to say "Engine running", then run this again. & pause & exit /b 1)
if not exist ".env" (
  copy ".env.example" ".env" >nul
  echo.
  echo  First time setup: Notepad will open your settings file.
  echo  Set ADMIN_PASSWORD and DB_PASSWORD, add your Anthropic key if you have one,
  echo  then SAVE and CLOSE Notepad to continue.
  echo.
  notepad ".env"
)
echo Starting the CPP Sales Hub. The first start takes a few minutes...
docker compose up -d --build || (echo. & echo Something went wrong. Copy the messages above and send them to Claude. & pause & exit /b 1)
echo Waiting for the hub to answer...
for /l %%i in (1,1,60) do (
  powershell -NoProfile -Command "try{(Invoke-WebRequest -UseBasicParsing http://localhost:8080/login.html -TimeoutSec 2) | Out-Null; exit 0}catch{exit 1}" && goto ready
  timeout /t 2 /nobreak >nul
)
echo The hub didn't answer yet. Run show-logs.bat to see why.
pause & exit /b 1
:ready
echo.
echo  The hub is running at http://localhost:8080
start "" http://localhost:8080
timeout /t 5 >nul
