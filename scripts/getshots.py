#! /usr/bin/env python3
import subprocess
import os
import sys
import time

def sendkeys(*args):
    for a in args:
        if a[0]=="!":
            sendtext(a[1:])
        else:
            sendkeystrokes(a)
        time.sleep(2)

def sendtext(str):
    sendCR = False
    if str[-4:] == "<CR>":
        str = str[:-4]
        sendCR = True
    subprocess.call(["xdotool", "type", "--delay", "100", str])
    if sendCR:
        subprocess.call(["xdotool", "key", "KP_Enter"])

def contains(lelist, lestring):
    for x in lelist:
        if lestring.count(x):
            return True
    return False

def sendkeystrokes(keystring):
    parts = keystring.split(" ")
    out = []
    for p in parts:
        if contains("+_", p) or p=="Escape" or p=="space":
            out.append(p)
        else:
            out += [x for x in p]
    dosend(out)
    time.sleep(2)

def dosend(keys):
    subprocess.call(["xdotool", "key", "--delay", "100"]+keys)

def startCode():
    print("setting up vscode...")
    sendkeys(
            "Escape Escape KP_Enter space"
            )
    time.sleep(2)

def makeShot(shotName):
    subprocess.call(["scrot", "/".join([shotsdir,shotName])+".png"])
    print("screenshot: " + shotName)

def setTheme(themeName):
    print("Switch Theme: " + themeName)
    sendkeys(
            "Ctrl+k Ctrl+t",
            "!"+themeName+"<CR>")

def sendCmd(command):
    sendkeys(
            "Ctrl+p",
            "!"+command+"<CR>"
            )

def editorCmd(command):
    print("Editor Command: " + command)
    sendCmd(">"+command)

def lineJump(lineNo):
    print("Jump to line: " + lineNo)
    sendCmd(":"+lineNo)

# setting default directories / filenames
themes = [
        "solarized dark",
        "solarized light"
        ]
#home = os.environ["HOME"]
#shotsdir = home+"/"+"shots"
shotsdir = "/home/codeuser/shots"
print("setting up directories...")
for dr in [shotsdir]:
    if not os.path.exists(dr):
        os.mkdir(dr)
startCode()
print("taking screenshots...")
for themeName in themes:
    setTheme(themeName)
    makeShot(themeName)
editorCmd("openworkspace")
makeShot("openworkspace")
