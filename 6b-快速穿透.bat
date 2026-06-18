@echo off
chcp 65001 >nul
echo ========================================
echo       检查 ngrok 配置状态
echo ========================================
echo.

REM 检查 ngrok 是否存在
if not exist "ngrok.exe" (
    echo [错误] 未找到 ngrok.exe
    echo.
    echo 请下载 ngrok: https://ngrok.com/download
    echo.
    pause
    exit /b 1
)

echo 正在检查 ngrok 配置...
echo.

REM 尝试获取 ngrok 配置状态
ngrok config check >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] ngrok 已配置
    echo.
    echo 启动内网穿透...
    timeout /t 2 >nul
    ngrok http 3001
) else (
    echo [需要配置] 请先配置 ngrok
    echo.
    echo 请运行 "6-启动-内网穿透.bat" 进行配置
    echo.
    pause
)

pause
