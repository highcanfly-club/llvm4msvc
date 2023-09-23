#!/bin/bash
$CL /I include /c src/test.c
$CL /I include /c src/MainWindow.c
$CL /I include /c src/AboutDialog.c

$LINK /subsystem:WINDOWS \
    user32.lib kernel32.lib comctl32.lib \
    test.obj MainWindow.obj AboutDialog.obj \
    /out:test.exe

$CL /I include /c src/simpletest.c
$LINK /subsystem:WINDOWS \
    user32.lib kernel32.lib comctl32.lib uuid.lib \
    simpletest.obj \
    /out:simpletest.exe