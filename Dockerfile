FROM mcr.microsoft.com/windows/servercore:ltsc2019
ARG VERSION
ARG DLURL="http://nginx-win.ecsds.eu/download"
ARG PORT=80
ARG PROTO="http"

SHELL ["powershell", "-command"]
# Download and extract nginx-win
RUN $ErrorActionPreference = 'Stop'; \
    Invoke-WebRequest -Uri ${ENV:DLURL}/nginx%20${ENV:VERSION}.zip -OutFile c:\nginx-${ENV:VERSION}.zip -Verbose; \
    Expand-Archive -Path C:\nginx-${ENV:VERSION}.zip -DestinationPath C:\nginx-${ENV:VERSION} -Force -Verbose; \
    Remove-Item -Path c:\nginx-${ENV:VERSION}.zip -Confirm:$False -Verbose; \
    Rename-Item -Path nginx-${ENV:VERSION} -NewName nginx-win -Verbose; \
# Download and install vcredist
    Invoke-WebRequest -Uri ${ENV:DLURL}/vcredist_x86.exe -OutFile c:\nginx-win\vcredist_x86.exe -Verbose; \
    C:\nginx-win\vcredist_x86.exe /q /norestart /serialdownload | Out-Null; \
    Invoke-WebRequest -Uri ${ENV:DLURL}/vcredist_x64.exe -OutFile c:\nginx-win\vcredist_x64.exe -Verbose; \
    C:\nginx-win\vcredist_x64.exe /q /norestart /serialdownload | Out-Null; \
    Remove-Item -Path c:\nginx-win\* -Include vcredist_* -Confirm:$False -Verbose; \
# Make sure that Docker always uses default DNS servers which hosted by Dockerd.exe
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters' -Name ServerPriorityTimeLimit -Value 0 -Type DWord -Verbose; \
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters' -Name ScreenDefaultServers -Value 0 -Type DWord -Verbose; \
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters' -Name ScreenUnreachableServers -Value 0 -Type DWord -Verbose; \
# Shorten DNS cache times
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters' -Name MaxCacheTtl -Value 30 -Type DWord -Verbose; \
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters' -Name MaxNegativeCacheTtl -Value 30 -Type DWord -Verbose

USER ContainerUser
WORKDIR C:\\nginx-win
ENTRYPOINT ["C:\\nginx-win\\nginx.exe"]  
CMD ["-c", "C:\\nginx-win\\conf\\nginx-win.conf"]  

HEALTHCHECK CMD powershell -command \  
    try { \
     $response = iwr ${ENV:PROTO}://localhost:${ENV:PORT} -UseBasicParsing; \
     if ($response.StatusCode -eq 200) { return 0} \
     else {return 1}; \
    } catch { return 1 }
