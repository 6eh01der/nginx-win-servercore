# nginx-win-servercore

Docker Hub repo - https://hub.docker.com/r/6eh01der/nginx-win

Originally forked from https://github.com/olljanat/nginx-nanoserver this variant based on full featured, production ready nginx for windows http://nginx-win.ecsds.eu/.

Because nginx-win require vcredist (C++ 2010 ) and nanoserver support only MSIX packages this dockerfile based on servercore image for ability to deploy required packages (vcredist_x86.exe & vcredist_x64.exe). Maybe later i'll try to investigate what exact components is needed and try to build on nanoserver. Additionally nanoserver does not contain powershell since 1709 version (should be installed additionally).


## Build

Set required nginx-win version (1.25.4.1%20SnapDragonfly for example, where %20 is URL-encoded space)

```powershell
docker build --build-arg VERSION="1.25.4.1%20SnapDragonfly" -t nginx-win-servercore .
```

Download URL, port and protocol could be overrided by relevant arguments - DLURL, PORT, PROTO. Default values are "http://nginx-win.ecsds.eu/download", "80" and "http". For example:

```powershell
docker build --build-arg VERSION="1.25.4.1%20SnapDragonfly" --build-arg DLURL="http://somesite.com/download" --build-arg PORT="8080" --build-arg PROTO="http" -t nginx-win-servercore .
```

## Run
```powershell
docker run -d --name nginx --expose 80 -p 80:80 nginx-win-servercore
```

## Override conf directory for example by mounting from host:
```powershell
docker run -d --name nginx --expose 80 -p 80:80 -v .\conf:C:\nginx-win\conf nginx-win-servercore
```

## Override healthcheck port to specific port configured in nginx:
```powershell
docker run -d --name nginx --expose 80 -p 80:8080 -e PORT=8080 nginx-win-servercore
```
