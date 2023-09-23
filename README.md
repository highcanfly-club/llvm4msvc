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
$CC_x86_64_pc_windows_msvc $CL_FLAGS /I include /c src/test.c /Fotest.o
$CC_x86_64_pc_windows_msvc $CL_FLAGS /I include /c src/MainWindow.c /FoMainWindow.o
$CC_x86_64_pc_windows_msvc $CL_FLAGS /I include /c src/AboutDialog.c /FoAboutDialog.o

$LINK_x86_64_pc_windows_msvc /libpath:$MSVC_BASE/sdk/lib/um/x86_64 /libpath:$MSVC_BASE/sdk/lib/ucrt/x86_64 /libpath:$MSVC_BASE/crt/lib/x86_64 \
    /subsystem:WINDOWS \
    user32.lib kernel32.lib comctl32.lib \
    test.o MainWindow.o AboutDialog.o \
    /out:test.exe
```

# Shortcuts

|   |   |
|---|---|
|CC_x86_64_pc_windows_msvc|clang-cl|
|CXX_x86_64_pc_windows_msvc|clang-cl|
|LINK_x86_64_pc_windows_msvc|lld-link|
|LINK_FLAGS|/libpath:$MSVC_BASE/sdk/lib/um/x86_64 /libpath:$MSVC_BASE/sdk/lib/ucrt/x86_64 /libpath:$MSVC_BASE/crt/lib/x86_64|
|CL|`${CC_x86_64_pc_windows_msvc} --target=x86_64-pc-windows-msvc ${CL_FLAGS}`|
|LINK|`${LINK_x86_64_pc_windows_msvc} --target=x86_64-pc-windows-msvc ${LINK_FLAGS}`|
