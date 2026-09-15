# nginx-win-servercore

Docker Hub repo - https://hub.docker.com/r/6eh01der/nginx-win

Originally forked from https://github.com/olljanat/nginx-nanoserver this variant based on full featured, production ready nginx for windows http://nginx-win.ecsds.eu/.

Because `nginx-win` requires `vcredist` (C++ 2022) and `nanoserver` supports only `MSIX` packages this `dockerfile` based on `servercore` image for ability to deploy required packages (`vcredist_x86.exe` & `vcredist_x64.exe`). Maybe later i'll try to investigate what exact components are needed and will build on `nanoserver`. Additionally the `nanoserver` does not contain `powershell` since 1709 version (should be installed additionally).


## Build

Set required nginx-win version and image tag. For example - `1.31.1.5%20SnowDrop` where `%20` is URL-encoded space and `ltsc2022` for windows server 2022 image (2019 by default).

```powershell
docker build --build-arg VERSION="1.31.1.5%20SnowDrop" --build-arg IMAGE_VERSION=ltsc2022 -t nginx-win-servercore .
```

Download URL, port and protocol could be overrided by relevant arguments - `DLURL`, `PORT`, `PROTO`. Default values are "http://nginx-win.ecsds.eu/download", "80" and "http". For example:

```powershell
docker build --build-arg VERSION="1.31.1.5%20SnowDrop" --build-arg DLURL="http://somesite.com/download" -t nginx-win-servercore .
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
