#!/bin/sh

google_drive_path="${HOME}/Google Drive/My Drive"

mkdir ${HOME}/todo
ln -s "${google_drive_path}/todo/main" "${HOME}/todo/main"
ln -s "${google_drive_path}/todo/book" "${HOME}/todo/book"
ln -s "${google_drive_path}/todo/work" "${HOME}/todo/work"
