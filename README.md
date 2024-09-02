# nginx-win-servercore

Docker Hub repo - https://hub.docker.com/r/6eh01der/nginx-win

Originally forked from https://github.com/olljanat/nginx-nanoserver this variant based on full featured, production ready nginx for windows http://nginx-win.ecsds.eu/.

Because nginx-win require vcredist (C++ 2010 ) and nanoserver support only MSIX packages this dockerfile based on servercore image for ability to deploy required packages (vcredist_x86.exe & vcredist_x64.exe). Maybe later i'll try to investigate what exact components is needed and try to build on nanoserver. Additionally nanoserver does not contain powershell since 1709 version (should be installed additionally).


## Build

Set required nginx-win version (1.23.3.5 for example)

```powershell
docker build --build-arg VERSION="1.23.3.5" --build-arg ZIP_URL="http://nginx-win.ecsds.eu/download/nginx%201.23.3.5%20SnapDragonfly.zip" -t nginx-win-servercore .
```

## Run
```powershell
docker run -d --name nginx --expose 80 -p 80:80 nginx-win-servercore
```

## Override conf directory for example by mounting from host:
```powershell
docker run -d --name nginx --expose 80 -p 80:80 -v .\conf:C:\nginx-win\conf nginx-win-servercore
```
