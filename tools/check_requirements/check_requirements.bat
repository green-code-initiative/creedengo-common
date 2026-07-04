@echo off

setlocal

:: Configurable Version Variables
for /f "tokens=1,* delims==" %%a in (config.txt) do (
    set %%a=%%b
)

:: Check Docker
call docker -v >nul 2>&1
if errorlevel 1 (
    echo [FAIL] Docker is not installed.
) else (
    echo [OK] Docker is installed.
)

echo.

:: Check Docker Compose
call docker-compose -v >nul 2>&1
if errorlevel 1 (
    echo [FAIL] Docker Compose is not installed.
) else (
    echo [OK] Docker Compose is installed.
)

echo.

:: Check Java
call javac -version >nul 2>&1
if errorlevel 1 (
    echo [FAIL] Java is not installed.
) else (
    echo [OK] Java is installed.
    setlocal enabledelayedexpansion
    for /f "tokens=2" %%a in ('javac -version 2^>^&1') do (
        set JAVA_VERSION=%%a
    )
    
    if defined JAVA_VERSION (
        if "!JAVA_VERSION!" LSS "%JAVA_VERSION_MIN%" (
            echo [FAIL] Java version !JAVA_VERSION! is below the minimum required ^(%JAVA_VERSION_MIN%^).
        ) else if "!JAVA_VERSION!" GTR "%JAVA_VERSION_MAX%" (
            echo [FAIL] Java version !JAVA_VERSION! is above the maximum allowed ^(%JAVA_VERSION_MAX%^).
        ) else (
            echo [OK] Java version !JAVA_VERSION! is within the acceptable range ^(%JAVA_VERSION_MIN% - %JAVA_VERSION_MAX%^).
        )
    ) else (
        echo [FAIL] Could not determine Java version.
    )
)

echo.

:: Check Maven
call mvn -v >nul 2>&1
if errorlevel 1 (
    echo [FAIL] Maven is not installed.
) else (
    echo [OK] Maven is installed.
    setlocal enabledelayedexpansion
    for /f "tokens=3" %%a in ('mvn -v ^| find "Apache Maven"') do (
        set MAVEN_VERSION=%%a
    )
    if "!MAVEN_VERSION!" LSS "%MAVEN_VERSION_MIN%" (
        echo [FAIL] Maven version !MAVEN_VERSION! is below the minimum required ^(%MAVEN_VERSION_MIN%^).
    ) else if "%MAVEN_VERSION%" GTR "%MAVEN_VERSION_MAX%" (
        echo [FAIL] Maven version !MAVEN_VERSION! is above the maximum allowed ^(%MAVEN_VERSION_MAX%^).
    ) else (
        echo [OK] Maven version !MAVEN_VERSION! is within the acceptable range ^(%MAVEN_VERSION_MIN% - %MAVEN_VERSION_MAX%^).
    )
)

echo.

:: Check Git
call git --version >nul 2>&1
if errorlevel 1 (
    echo [FAIL] Git is not installed.
) else (
    echo [OK] Git is installed.
)

echo.

:: Check jq
call jq --version >nul 2>&1
if errorlevel 1 (
    echo [FAIL] jq is not installed.
) else (
    echo [OK] jq is installed.
)

endlocal
