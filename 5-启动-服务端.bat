@echo off
chcp 65001 >nul
echo ========================================
echo       启动 AI 服务端
echo ========================================
echo.
echo 正在启动服务...
echo.

REM 检查是否安装了 Node.js
where node >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 未找到 Node.js
    echo.
    echo 请先安装 Node.js:
    echo 1. 打开 https://nodejs.org
    echo 2. 下载 LTS 版本
    echo 3. 安装并重新运行此脚本
    echo.
    pause
    exit /b 1
)

REM 检查依赖是否安装
if not exist "node_modules" (
    echo [提示] 正在安装依赖...
    call "4-安装-依赖.bat"
)

echo 正在启动服务...
echo.
node src/index.js

echo.
echo 服务已停止
pause
