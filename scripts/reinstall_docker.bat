@echo off
setlocal EnableDelayedExpansion
title Reinstalacion Limpia de WSL 2 y Docker Desktop - Elite Multiservicios
color 0b

:: Auto-elevate to Administrator if not already running as Admin
NET FILE 1>NUL 2>NUL
if '%errorlevel%' NEQ '0' (
    echo ======================================================================
    echo  Solicitando permisos de Administrador para instalar componentes...
    echo ======================================================================
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /B
)

echo ======================================================================
echo    REINSTALACION COMPLETA Y LIMPIA DE DOCKER DESKTOP Y WSL 2
echo ======================================================================
echo.

:: [Paso 1] Detener todos los procesos residuales de Docker y WSL
echo [1/6] Cerrando procesos residuales de Docker y apagando WSL...
taskkill /F /IM "Docker Desktop.exe" /T 2>nul
taskkill /F /IM "com.docker.*" /T 2>nul
taskkill /F /IM "docker.exe" /T 2>nul
wsl.exe --shutdown 2>nul
echo Procesos detenidos.
echo.

:: [Paso 2] Desinstalar cualquier version previa de Docker y limpiar temporales
echo [2/6] Limpiando carpetas residuales y versiones corruptas previas...
if exist "C:\Program Files\Docker\Docker\Docker Desktop Installer.exe" (
    echo Desinstalando version previa de Archivos de Programa...
    "C:\Program Files\Docker\Docker\Docker Desktop Installer.exe" uninstall --quiet
)
if exist "%LOCALAPPDATA%\Programs\DockerDesktop\Docker Desktop Installer.exe" (
    echo Desinstalando version previa de usuario...
    "%LOCALAPPDATA%\Programs\DockerDesktop\Docker Desktop Installer.exe" uninstall --quiet
)

rmdir /S /Q "%LOCALAPPDATA%\Programs\DockerDesktop" 2>nul
rmdir /S /Q "%LOCALAPPDATA%\Docker" 2>nul
rmdir /S /Q "%APPDATA%\Docker" 2>nul
rmdir /S /Q "%LOCALAPPDATA%\docker-secrets-engine" 2>nul
rmdir /S /Q "%APPDATA%\docker-secrets-engine" 2>nul
echo Limpieza de residuos completada.
echo.

:: [Paso 3] Habilitar caracteristicas requeridas de Windows
echo [3/6] Habilitando caracteristicas del sistema (WSL y VirtualMachinePlatform)...
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
echo Caracteristicas de virtualizacion verificadas.
echo.

:: [Paso 4] Instalar paquete oficial moderno de WSL 2 (Kernel 6.x)
echo [4/6] Instalando paquete oficial actualizado de WSL 2...
set "WSL_MSI=%TEMP%\wsl.2.7.14.0.x64.msi"
if exist "%WSL_MSI%" (
    echo Ejecutando instalador MSI de WSL (%WSL_MSI%)...
    msiexec.exe /i "%WSL_MSI%" /qn /norestart
    echo WSL 2 actualizado a la version mas reciente de Microsoft.
) else (
    echo Descargando e instalando WSL directamente...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri 'https://github.com/microsoft/WSL/releases/download/2.7.14/wsl.2.7.14.0.x64.msi' -OutFile '$env:TEMP\wsl.2.7.14.0.x64.msi'"
    msiexec.exe /i "%TEMP%\wsl.2.7.14.0.x64.msi" /qn /norestart
)
wsl.exe --set-default-version 2 2>nul
echo WSL 2 configurado con version 2 por defecto.
echo.

:: [Paso 5] Instalar Docker Desktop oficial
echo [5/6] Instalando Docker Desktop con motor WSL 2...
set "DOCKER_INSTALLER=%TEMP%\DockerDesktopInstaller.exe"
if not exist "%DOCKER_INSTALLER%" (
    set "DOCKER_INSTALLER=%LOCALAPPDATA%\Temp\WinGet\Docker.DockerDesktop.4.91.0\Docker Desktop Installer.exe"
)

if exist "%DOCKER_INSTALLER%" (
    echo Ejecutando instalador oficial de Docker Desktop (espera a que termine el proceso)...
    "%DOCKER_INSTALLER%" install --accept-license --backend=wsl-2
) else (
    echo Instalando Docker Desktop mediante winget...
    winget install --id Docker.DockerDesktop --accept-source-agreements --accept-package-agreements
)
echo Instalacion de Docker Desktop completada.
echo.

:: [Paso 6] Agregar el usuario al grupo docker-users
echo [6/6] Configurando permisos locales de usuario...
net localgroup docker-users "%USERNAME%" /add 2>nul
echo Usuario "%USERNAME%" configurado en grupo docker-users.
echo.

echo ======================================================================
echo    INSTALACION FINALIZADA CON EXITO
echo ======================================================================
echo  1. Iniciando Docker Desktop automaticamente...
echo  2. Recuerda que si acabas de activar la virtualizacion por primera vez,
echo     Windows podria requerir un reinicio para finalizar cambios del kernel.
echo ======================================================================
echo.

if exist "C:\Program Files\Docker\Docker\Docker Desktop.exe" (
    start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"
) else if exist "%LOCALAPPDATA%\Programs\DockerDesktop\Docker Desktop.exe" (
    start "" "%LOCALAPPDATA%\Programs\DockerDesktop\Docker Desktop.exe"
)

echo Todo listo. Presiona cualquier tecla para cerrar.
pause >nul
