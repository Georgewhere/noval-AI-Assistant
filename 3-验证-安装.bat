@echo off
chcp 65001 >nul
echo ========================================
echo       验证安装
echo ========================================
echo.
echo 已安装的模型：
echo.
ollama list
echo.
echo 已安装的运行时：
echo.
ollama ps
echo.
echo ========================================
echo       验证完成
echo ========================================
echo.
echo 按任意键返回主目录...
pause >nul
