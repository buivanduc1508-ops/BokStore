@echo off
setlocal

set "ROOT=%~dp0"
set "TOMCAT=%ROOT%.runtime\apache-tomcat-10.1.54"
set "BUILD=%ROOT%target\intellij-runtime"

if not exist "%TOMCAT%\bin\startup.bat" (
  echo Khong tim thay Tomcat tai "%TOMCAT%".
  exit /b 1
)

if "%JAVA_HOME%"=="" (
  for %%I in (java.exe) do for %%J in ("%%~$PATH:I\..\..") do set "JAVA_HOME=%%~fJ"
)

if not exist "%JAVA_HOME%\bin\javac.exe" (
  echo Khong tim thay JDK. Hay cai JDK 17 tro len hoac cau hinh JAVA_HOME.
  exit /b 1
)

set "JRE_HOME=%JAVA_HOME%"
set "CATALINA_HOME=%TOMCAT%"
set "CATALINA_BASE=%TOMCAT%"

echo Dang dung Tomcat neu dang chay...
call "%TOMCAT%\bin\shutdown.bat" > nul 2>&1
timeout /t 3 /nobreak > nul

echo Dang compile source vao target...
if exist "%BUILD%" rmdir /s /q "%BUILD%"
mkdir "%BUILD%\classes"
dir /s /b "%ROOT%src\main\java\*.java" > "%BUILD%\sources.txt"

set "CP=%TOMCAT%\lib\servlet-api.jar;%TOMCAT%\lib\jsp-api.jar"
"%JAVA_HOME%\bin\javac.exe" --release 17 -encoding UTF-8 -cp "%CP%" -d "%BUILD%\classes" @"%BUILD%\sources.txt"
if errorlevel 1 exit /b 1

echo Dang deploy vao runtime Tomcat...
if exist "%TOMCAT%\webapps\BokStore" rmdir /s /q "%TOMCAT%\webapps\BokStore"
mkdir "%TOMCAT%\webapps\BokStore"
xcopy "%ROOT%src\main\webapp\*" "%TOMCAT%\webapps\BokStore\" /E /I /Y > nul
if not exist "%TOMCAT%\webapps\BokStore\WEB-INF\classes" mkdir "%TOMCAT%\webapps\BokStore\WEB-INF\classes"
xcopy "%BUILD%\classes\*" "%TOMCAT%\webapps\BokStore\WEB-INF\classes\" /E /I /Y > nul

echo Dang chay Tomcat...
call "%TOMCAT%\bin\startup.bat"
echo Mo: http://localhost:8080/BokStore/home
