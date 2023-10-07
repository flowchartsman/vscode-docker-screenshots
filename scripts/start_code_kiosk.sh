#!/bin/bash
code_do()
{
    "$@" 2>&1 | grep -v "^(node" | grep -v "trace-deprecation"
}
export DISPLAY=:99
cd /home/codeuser
echo -n "Starting matchbox-window-manager..."
sudo xvfb-run --server-args="-ac -screen 0 $XVFB_RES" -- matchbox-window-manager -use_cursor no -use_titlebar no -use_desktop_mode plain &
sleep 3
echo "done"
cp .code-init/* .config/Code/User
for file in extensions/*.vsix; do
	echo "Installing extension $(basename $file)"
	code_do code --install-extension "$file"
done
code --no-sandbox --disable-workspace-trust ./code &
./waitvscode.py
echo "Running user commands..."
"$@"
echo -n "Waiting for last command to settle..."
sleep 3
echo "done"