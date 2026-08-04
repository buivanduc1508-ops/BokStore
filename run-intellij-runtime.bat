@echo off
setlocal

set "ROOT=%~dp0"
set "TOMCAT=%ROOT%.runtime\apache-tomcat-10.1.54"

if not exist "%TOMCAT%\bin\startup.bat" (
  echo Khong tim thay Tomcat tai "%TOMCAT%".
  exit /b 1
)

if "%JAVA_HOME%"=="" (
  if exist "C:\Program Files\Java\jdk-17" set "JAVA_HOME=C:\Program Files\Java\jdk-17"
)

if "%JAVA_HOME%"=="" (
  echo Hay cau hinh JAVA_HOME tro den JDK 17 tro len.
  exit /b 1
)

set "JRE_HOME=%JAVA_HOME%"
set "CATALINA_HOME=%TOMCAT%"
set "CATALINA_BASE=%TOMCAT%"

echo Dang dung Tomcat neu dang chay...
call "%TOMCAT%\bin\shutdown.bat" > nul 2>&1
timeout /t 3 /nobreak > nul

echo Dang compile source vao WEB-INF\classes...
if not exist "%ROOT%src\main\webapp\WEB-INF\classes" mkdir "%ROOT%src\main\webapp\WEB-INF\classes"

set "CP=%TOMCAT%\lib\servlet-api.jar;%TOMCAT%\lib\jsp-api.jar"
"%JAVA_HOME%\bin\javac.exe" -encoding UTF-8 -cp "%CP%" -d "%ROOT%src\main\webapp\WEB-INF\classes" @sources.txt
if errorlevel 1 exit /b 1

echo Dang deploy vao runtime Tomcat...
if exist "%TOMCAT%\webapps\BokStore" rmdir /s /q "%TOMCAT%\webapps\BokStore"
mkdir "%TOMCAT%\webapps\BokStore"
xcopy "%ROOT%src\main\webapp\*" "%TOMCAT%\webapps\BokStore\" /E /I /Y > nul

echo Dang chay Tomcat...
call "%TOMCAT%\bin\startup.bat"
echo Mo: http://localhost:8080/BokStore/home
