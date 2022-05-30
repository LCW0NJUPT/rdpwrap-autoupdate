@echo off & title 更新RDPWrap.ini
 
set INI_Path="C:\Program Files\RDP Wrapper\rdpwrap.ini"
set INI_Dir="C:\Program Files\RDP Wrapper"
 
::检查权限
setlocal enabledelayedexpansion>nul
net session>nul
if !ERRORLEVEL! EQU 2 (
	set "args=!args: ="^&chr^(32^)^&"%!"
	
	set "args="/C"&chr(32)&chr(34)&chr(94)&chr(34)&"%~f0""
	mshta "vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe", !args!, NULL, "runas", NULL)(window.close)"&&exit
)
 
echo.正在停止远程桌面服务……
echo Y | net stop UmRdpService
echo Y | net stop TermService
 
::删除旧配置文件
:DeleteFile
del %INI_Path%
if exist %INI_Path% (
	echo.文件 %INI_Path% 仍被占用，请手动关闭占用该文件的程序。
	start "" %INI_Dir%
	pause
	goto :DeleteFile
)
 
echo.正在下载配置文件……
curl "https://raw.githubusercontents.com/sebaxakerhtc/rdpwrap.ini/master/rdpwrap.ini">%INI_Path%
 
echo.正在重启远程桌面服务……
C:\WINDOWS\System32\svchost.exe -k NetworkService
net start TermService
 
echo.更新完成！按任意键以结束。
pause>nul