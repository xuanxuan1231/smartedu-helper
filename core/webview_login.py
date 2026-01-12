"""
Standalone pywebview login script for SmartEdu authentication.
This script runs in a separate process and outputs the TGC cookie as JSON to stdout.
"""
import webview
import json
import sys

TGC_COOKIE_NAME = "UC_SSO_TGC-e5649925-441d-4a53-b525-51a2f1c4e0a8-product"
SMARTEDU_LOGIN_URL = "https://auth.smartedu.cn/uias"

result = {"tgc": None}
window = None


def on_loaded():
    global window, result
    if window is None:
        return
    current_url = window.get_current_url()
    if current_url is None:
        return
    # Check if redirected back to smartedu.cn (login successful)
    if current_url.startswith("https://www.smartedu.cn") or current_url.startswith("https://smartedu.cn"):
        try:
            cookies = window.get_cookies()
            for cookie in cookies:
                name = cookie.get("name", "")
                value = cookie.get("value", "")
                if name == TGC_COOKIE_NAME:
                    result["tgc"] = value
                    break
        except Exception:
            pass
        window.destroy()


def main():
    global window
    window = webview.create_window(
        "SmartEdu Login",
        SMARTEDU_LOGIN_URL,
        width=1024,
        height=720
    )
    window.events.loaded += on_loaded
    webview.start()
    # Output result as JSON to stdout
    print(json.dumps(result))


if __name__ == "__main__":
    main()
