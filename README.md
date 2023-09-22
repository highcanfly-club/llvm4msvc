# LLVM for MSVC
## Why
I have a Kubernetes cluster running aarch64 linux workers. 
I wanted to compile some apps on this cluster.  
Mingw(64) is a fantastic tool but… 
The main idea was to use the current Windows SDK and the MSVC runtime like you do with Visual Studio. 
I found a fantastic tool https://github.com/Jake-Shadle/xwin made by Jake Shadle. His tool can download the CRT and the SDK directly from Microsoft servers.
And thanks to clang/llvm and its target x86_64-pc-windows-msvc , building Windows x86_64 apps on linux aarch64 is possible… 

In /usr/share/msvc/test you'll find a minimal Windows application.  
With /usr/share/msvc/test/test.sh you can test a full compilation and executable generation.

# Compile with script
test.sh contains:  
```sh
#!/bin/bash
export MSVC_BASE=/usr/share/msvc
clang -target x86_64-pc-windows-msvc -I$MSVC_BASE/sdk/include/um -I$MSVC_BASE/sdk/include/shared -I$MSVC_BASE/sdk/include/ucrt -I$MSVC_BASE/crt/include -I./include -c src/test.c -o test.o
clang -target x86_64-pc-windows-msvc -I$MSVC_BASE/sdk/include/um -I$MSVC_BASE/sdk/include/shared -I$MSVC_BASE/sdk/include/ucrt -I$MSVC_BASE/crt/include -I./include -c src/MainWindow.c -o MainWindow.o
clang -target x86_64-pc-windows-msvc -I$MSVC_BASE/sdk/include/um -I$MSVC_BASE/sdk/include/shared -I$MSVC_BASE/sdk/include/ucrt -I$MSVC_BASE/crt/include -I./include -c src/AboutDialog.c -o AboutDialog.o

lld-link /libpath:$MSVC_BASE/sdk/lib/um/x86_64 /libpath:$MSVC_BASE/sdk/lib/ucrt/x86_64 /libpath:$MSVC_BASE/crt/lib/x86_64 \
    /subsystem:WINDOWS \
    user32.lib kernel32.lib gdi32.lib comctl32.lib \
    vcruntime.lib uuid.lib ucrt.lib \
    test.o MainWindow.o AboutDialog.o \
    /out:test.exe
```