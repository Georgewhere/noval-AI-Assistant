@echo off
chcp 65001 >nul
echo ========================================
echo       启动内网穿透 (ngrok)
echo ========================================
echo.
echo 此脚本需要 ngrok.exe 文件
echo.
echo 如果没有 ngrok:
echo 1. 打开 https://ngrok.com/download
echo 2. 下载 Windows 版本
echo 3. 解压得到 ngrok.exe
echo 4. 把 ngrok.exe 复制到此文件夹
echo.
echo ========================================
echo.

REM 检查 ngrok 是否存在
if not exist "ngrok.exe" (
    echo [错误] 未找到 ngrok.exe
    echo.
    echo 请先下载 ngrok: https://ngrok.com/download
    echo.
    pause
    exit /b 1
)

REM 检查是否已配置 auth token
echo 首次使用需要配置 ngrok:
echo 1. 访问 https://dashboard.ngrok.com/signup 注册账号
echo 2. 复制你的 Authtoken
echo 3. 在下方粘贴并回车
echo.
set /p TOKEN=请粘贴 ngrok Authtoken: 

REM 配置 token
ngrok config add-authtoken %TOKEN%

echo.
echo ========================================
echo       正在启动内网穿透
echo ========================================
echo.
echo 服务地址: http://localhost:3001
echo.
echo 启动后，会显示 "Forwarding https://xxx.ngrok.io"
echo 请复制这个地址用于手机连接
echo.
echo 按 Ctrl+C 可停止服务
echo.

ngrok http 3001

pause
