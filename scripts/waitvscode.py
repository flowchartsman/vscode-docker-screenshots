#!/usr/bin/python3

import Xlib.display
import sys
import time

if __name__ == '__main__':
    print("Waiting for vscode.",end="")
    for _ in range(10):
        try:
            focused = Xlib.display.Display().get_input_focus().focus
            if isinstance(focused, int):
                print(".", end ="")
                time.sleep(1)
                continue
            app = focused.get_wm_class()[0]
            if app == "code":
                time.sleep(3)
                print("done")
                sys.exit(0)
        except AttributeError:
            print(".", end ="")
            time.sleep(1)
            continue
    print("timed out")
    sys.exit(1)
