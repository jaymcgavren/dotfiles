#!/bin/bash

file="${HOME}/Downloads/untitled.jpg"

osascript \
    -e 'set theImage to the clipboard as JPEG picture' \
    -e "set theFile to open for access POSIX file \"$file\" with write permission" \
    -e 'write theImage to theFile' \
    -e 'close access theFile'
