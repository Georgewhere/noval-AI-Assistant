@echo off
chcp 65001 >nul
echo ========================================
echo       一键安装 Ollama
echo ========================================
echo.
echo 正在打开 Ollama 下载页面...
echo 请下载 Windows 版本并安装
echo.
start https://ollama.com/download
echo.
echo 安装完成后，按任意键继续下载模型...
pause >nul
call "2-下载-模型.bat"
