# nginx-win-servercore

Originally forked from https://github.com/olljanat/nginx-nanoserver this variant based on full featured, production ready nginx for windows http://nginx-win.ecsds.eu/.

Because nginx-win requires vcredist (C++ 2010 ) and nanoserver support only MSIX packages this dockerfile based on servercore image for ability to deploy required redistributable packages (vcredist_x86.exe & vcredist_x64.exe). Maybe later i'll try to investigate what exact dlls needed and try to build on nanoserver. Additionally nanoserver does not contain powershell since 1709 version (should be installed additionally).


## Build
```bash
docker build -t nginx-nanoserver .
```

## Run
```bash
docker run -d --name nginx -p 80:80 nginx-nanoserver
```
