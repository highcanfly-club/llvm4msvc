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