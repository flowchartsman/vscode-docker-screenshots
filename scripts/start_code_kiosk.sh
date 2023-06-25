#!/bin/bash
export DISPLAY=:99
sudo Xvfb :99 -ac -screen 0 "$XVFB_RES" -nolisten tcp $XVFB_ARGS >/dev/null &
#XVFB_PROC=$!
export XAUTHORITY=/tmp/xauth
echo -n "Waiting for Xvfb to start up..."
while ! xdpyinfo -display :99 >/dev/null 2>&1; do
	echo -n "."
	sleep 0.5
done
echo "done"
cd /home/codeuser
echo -n "Starting matchbox-window-manager..."
matchbox-window-manager -use_cursor no -use_titlebar no -use_desktop_mode plain >/dev/null &
sleep 3
echo "done"
echo -n "Starting VSCode..."
code --no-sandbox &
sleep 3
echo "done"
echo "Running script..."
"$@"
echo -n "Waiting for last command to settle..."
sleep 3
echo "done"
echo "Exiting"
#sudo kill $XVFB_PROC
