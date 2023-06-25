#!/bin/bash
TMPDIR=$(mktemp -d -t codeshots)
if [[ ! "$TMPDIR" || ! -d "$TMPDIR" ]]; then
	echo "error creating temp dir"
	exit 1
fi

# deletes the temp directory
function cleanup {
	rm -rf "$TMPDIR"
	echo "Deleted temp directory"
}

trap cleanup EXIT
docker run --rm -it -v $TMPDIR:/home/codeuser/shots --name xtest xvfb-test /home/codeuser/getshots.py
mkdir shots
cp $TMPDIR/*.png shots
echo "Copied screenshots to the 'shots' directory"
