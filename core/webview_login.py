"""
Standalone pywebview login script for SmartEdu authentication.
This script runs in a separate process and outputs the TGC cookie as JSON to stdout.
"""
import webview
import json
import time
from urllib.parse import urlparse

TGC_COOKIE_NAME = "UC_SSO_TGC-e5649925-441d-4a53-b525-51a2f1c4e0a8-product"
SMARTEDU_LOGIN_URL = "https://auth.smartedu.cn/uias"

# Allowed domains for successful login redirect
ALLOWED_REDIRECT_HOSTS = {"www.smartedu.cn", "smartedu.cn"}

result = {"tgc": None}
window = None


def is_valid_redirect_url(url):
    """Check if the URL is a valid redirect to smartedu.cn using proper URL parsing."""
    try:
        parsed = urlparse(url)
        # Only accept HTTPS and exact domain match
        if parsed.scheme != "https":
            return False
        return parsed.netloc in ALLOWED_REDIRECT_HOSTS
    except Exception:
        return False


def extract_cookies():
    """Extract cookies using multiple methods to ensure we get the TGC cookie."""
    global window, result
    if window is None:
        return False
    
    # Method 1: Try get_cookies() API
    try:
        cookies = window.get_cookies()
        if cookies:
            for cookie in cookies:
                name = cookie.get("name", "")
                value = cookie.get("value", "")
                if name == TGC_COOKIE_NAME and value:
                    result["tgc"] = value
                    return True
    except Exception:
        pass
    
    # Method 2: Try JavaScript document.cookie (as fallback)
    try:
        js_cookies = window.evaluate_js("document.cookie")
        if js_cookies:
            for part in js_cookies.split(";"):
                part = part.strip()
                if "=" in part:
                    name, value = part.split("=", 1)
                    if name.strip() == TGC_COOKIE_NAME and value.strip():
                        result["tgc"] = value.strip()
                        return True
    except Exception:
        pass
    
    return False


def on_loaded():
    global window, result
    if window is None:
        return
    current_url = window.get_current_url()
    if current_url is None:
        return
    # Check if redirected back to smartedu.cn (login successful)
    if is_valid_redirect_url(current_url):
        # Wait a bit for cookies to be fully set
        time.sleep(0.5)
        extract_cookies()
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
    # Disable private mode to allow cookie persistence across domains
    webview.start(private_mode=False)
    # Output result as JSON to stdout
    print(json.dumps(result))


if __name__ == "__main__":
    main()
