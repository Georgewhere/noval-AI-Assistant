@echo off
chcp 65001 >nul
echo ========================================
echo       下载 AI 模型
echo ========================================
echo.
echo 正在下载 qwen2.5:3b 模型...
echo 此模型约 2GB，需要等待一段时间
echo.
echo 提示：如果下载中断，可以重新运行此脚本继续下载
echo.
ollama pull qwen2.5:3b
echo.
echo ========================================
echo       模型下载完成
echo ========================================
echo.
echo 按任意键验证安装...
pause >nul
call "3-验证-安装.bat"
