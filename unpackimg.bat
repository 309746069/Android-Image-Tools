@echo off
color 0a
title Android Image ������
echo.+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
echo.I                                                                             I
echo.I                        Android Image ������-���                            I
echo.I                                                                by wuxianlin I
echo.+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
echo.
if "%~1" == "" goto noargs
set "file=%~f1"
set bin=%~dp0bin

echo ���������: %~nx1
echo.

set "folder=%~n1"
if exist %folder% rd /s/q %folder%
md %folder%

echo ������񵽣�%folder% Ŀ¼...
echo.

cd %folder%
set tools=..\bin

%tools%\unpackbootimg -i "%file%"
echo.
%tools%\file -m %tools%\magic *-ramdisk.gz | %tools%\cut -d: -f2 | %tools%\cut -d" " -f2 > "%~nx1-ramdiskcomp"
for /f "delims=" %%a in ('type "%~nx1-ramdiskcomp"') do @set ramdiskcomp=%%a
if "%ramdiskcomp%" == "gzip" set "unpackcmd=gzip -dc" & set "compext=gz"
if "%ramdiskcomp%" == "lzop" set "unpackcmd=lzop -dc" & set "compext=lzo"
if "%ramdiskcomp%" == "lzma" set "unpackcmd=xz -dc" & set "compext=lzma"
if "%ramdiskcomp%" == "xz" set "unpackcmd=xz -dc" & set "compext=xz"
if "%ramdiskcomp%" == "bzip2" set "unpackcmd=bzip2 -dc" & set "compext=bz2"
if "%ramdiskcomp%" == "lz4" ( set "unpackcmd=lz4" & set "extra=stdout 2>nul" & set "compext=lz4"  ) else ( set "extra= " )
ren *ramdisk.gz *ramdisk.cpio.%compext%

md ramdisk
cd ramdisk

set tools=..\..\bin
echo ��ѹramdisk����%folder%\ramdisk Ŀ¼...
echo.
echo ѹ����ʽ: %ramdiskcomp%
if "%compext%" == "" goto error
%tools%\%unpackcmd% "../%~nx1-ramdisk.cpio.%compext%" %extra% | %tools%\cpio -i
if errorlevel == 1 goto error
echo.
cd ../../

echo ���!
goto end

:noargs
echo δ�ṩ�����ļ�.
goto end

:error
echo ����!

:end
echo.
pause
