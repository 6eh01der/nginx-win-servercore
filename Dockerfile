FROM mcr.microsoft.com/windows/servercore:ltsc2019
ENV VERSION 1.21.3.1

SHELL ["powershell", "-command"]
# Download and extract nginx-win
RUN Invoke-WebRequest -Uri http://nginx-win.ecsds.eu/download/nginx%201.21.7.2%20WhiteHorse.zip -OutFile c:\nginx-$ENV:VERSION.zip -verbose; \
	Expand-Archive -Path C:\nginx-$ENV:VERSION.zip -DestinationPath C:\nginx-$ENV:VERSION -Force -verbose; \
	Remove-Item -Path c:\nginx-$ENV:VERSION.zip -Confirm:$False; \
	Rename-Item -Path nginx-$ENV:VERSION -NewName nginx-win

# Download and install vcredist
RUN Invoke-WebRequest -Uri http://nginx-win.ecsds.eu/download/vcredist_x86.exe -OutFile c:\nginx-win\vcredist_x86.exe -verbose; \
    C:\nginx-win\vcredist_x86.exe /q /norestart /serialdownload | Out-Null; \
    Invoke-WebRequest -Uri http://nginx-win.ecsds.eu/download/vcredist_x64.exe -OutFile c:\nginx-win\vcredist_x64.exe -verbose; \
    C:\nginx-win\vcredist_x64.exe /q /norestart /serialdownload | Out-Null; \
    Remove-Item -Path c:\nginx-win\* -Include vcredist_* -Confirm:$False -verbose

# Make sure that Docker always uses default DNS servers which hosted by Dockerd.exe
RUN Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters' -Name ServerPriorityTimeLimit -Value 0 -Type DWord; \
	Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters' -Name ScreenDefaultServers -Value 0 -Type DWord; \
	Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters' -Name ScreenUnreachableServers -Value 0 -Type DWord
	
# Shorten DNS cache times
RUN Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters' -Name MaxCacheTtl -Value 30 -Type DWord; \
	Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters' -Name MaxNegativeCacheTtl -Value 30 -Type DWord

WORKDIR C:\\nginx-win
EXPOSE 80
CMD ["nginx.exe", "-c", "conf\\nginx-win.conf"]

HEALTHCHECK CMD powershell -command \  
    try { \
     $response = iwr http://localhost:80 -UseBasicParsing; \
     if ($response.StatusCode -eq 200) { return 0} \
     else {return 1}; \
    } catch { return 1 }
