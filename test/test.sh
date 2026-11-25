#!/bin/bash
$MSVC_CL /I include /c src/test.c
$MSVC_CL /I include /c src/MainWindow.c
$MSVC_CL /I include /c src/AboutDialog.c

$MSVC_LINK /subsystem:WINDOWS \
    user32.lib kernel32.lib comctl32.lib \
    test.obj MainWindow.obj AboutDialog.obj \
    /out:test.exe

$MSVC_CL /I include /c src/simpletest.c
$MSVC_LINK /subsystem:WINDOWS \
    user32.lib kernel32.lib comctl32.lib uuid.lib \
    simpletest.obj \
    /out:simpletest.exe