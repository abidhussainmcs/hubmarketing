@echo off
cd /d "%~dp0"
docker compose down
echo The hub is stopped. Your data is kept. Run start-hub.bat to start it again.
pause
