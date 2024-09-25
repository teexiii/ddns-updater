@echo off
setlocal enabledelayedexpansion

:: Load environment variables from .env file
for /f "tokens=1,2 delims==" %%G in (.env) do (
    set %%G=%%H
)

:getInitialIP
if defined IP_URL (
    for /f "delims=" %%i in ('curl -s !IP_URL!') do set IP=%%i
) else (
    echo Error: IP_URL not defined in .env file
    goto :end
)
set LAST_IP=!IP!
@echo ip=!IP!

:: First API call to update DNS record
set RESPONSE=
for /f "delims=" %%i in ('curl --request PATCH --url !CF_API_URL! --header "Content-Type: application/json" --data "{ \"content\": \"!IP!\", \"name\": \"!DOMAIN!\", \"proxied\": false, \"type\": \"A\", \"comment\": \"Domain verification record\" }" --header "X-Auth-Email: !CF_EMAIL!" --header "X-Auth-Key: !CF_API_KEY!"') do set RESPONSE=%%i
@echo Response: !RESPONSE!

goto :loop

:loop
timeout /t 30 /nobreak >nul
for /f "delims=" %%i in ('curl -s !IP_URL!') do set IP=%%i

@echo ip=!IP!
@echo lastIp=!LAST_IP!

if not "!IP!" == "!LAST_IP!" (
    @echo IP has changed to !IP!
    set LAST_IP=!IP!

    :: API call to update DNS record
    set RESPONSE=
    for /f "delims=" %%i in ('curl --request PATCH --url !CF_API_URL! --header "Content-Type: application/json" --data "{ \"content\": \"!IP!\", \"name\": \"!DOMAIN!\", \"proxied\": false, \"type\": \"A\", \"comment\": \"Domain verification record\" }" --header "X-Auth-Email: !CF_EMAIL!" --header "X-Auth-Key: !CF_API_KEY!"') do set RESPONSE=%%i
    @echo Response: !RESPONSE!
)

goto :loop

:end
endlocal