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
if test -n "$(find ./extensions -maxdepth 1 -name '*.vsix' -print -quit)"
then
	for file in extensions/*.vsix; do
		echo "Installing extension $(basename $file)"
		code_do code --install-extension "$file"
	done
fi
if test -f settings.json
then
	echo "merging user settings"
	jq '. * input' .config/VSCodium/User/settings.json settings.json > .config/VSCodium/User/settings.json
fi
code --no-sandbox --disable-workspace-trust ./code &
./waitvscode.py
echo "Running user commands..."
"$@"
echo -n "Waiting for last command to settle..."
sleep 3
echo "done"