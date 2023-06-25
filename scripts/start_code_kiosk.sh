#!/bin/bash
export DISPLAY=:99
sudo Xvfb :99 -ac -screen 0 "$XVFB_RES" -nolisten tcp $XVFB_ARGS &
XVFB_PROC=$!
while ! sudo xdpyinfo -display :99; do sleep 0.5; done
cd /home/codeuser
matchbox-window-manager -use_cursor no -use_titlebar no -use_desktop_mode plain &
sleep 3
code --no-sandbox &
sleep 3
"$@"
echo "waiting for last command to settle..."
sleep 5
echo "exiting"
#sudo kill $XVFB_PROC
