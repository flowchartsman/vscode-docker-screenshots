# vscode-docker-screenshots

Take screenshots of your extension using docker/Xvfb

Currently targeting screenshots, with more automations on the way

## Usage
```
docker run --rm -t \
  -v <screenshout output dir>:/home/codeuser/shots \
  -v <path to your extension>.vsix:/home/codeuser/extensions/<extension>.vsix \
  -v <path to sample code directory>:/home/codeuser/code vscode-docker-shots \
  flowchartsman/vscode-docker-shots \
  ./makeshots --samplefile <file to open> [--fileline <line number>] <theme name> [<theme name> ...]
```
