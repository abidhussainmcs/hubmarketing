@echo off
cd /d "%~dp0"
if not exist backups mkdir backups
for /f %%d in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd_HHmm"') do set STAMP=%%d
docker compose exec -T db pg_dump -U hub -d hub > "backups\hub-database-%STAMP%.sql" || (echo Backup failed. Is the hub running? & pause & exit /b 1)
echo Saved backups\hub-database-%STAMP%.sql
echo Copy the backups folder somewhere safe (OneDrive, a USB drive) now and then.
pause
