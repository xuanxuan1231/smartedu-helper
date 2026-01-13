from PySide6.QtCore import QObject, Signal, Slot, QThread
from PySide6.QtWidgets import QApplication
import hmac
import hashlib
import base64
import random
import math
import requests
import time
import subprocess
import sys
import json
from urllib.parse import urlparse
from datetime import datetime
from pathlib import Path
from loguru import logger

SDP_APP_ID = "e5649925-441d-4a53-b525-51a2f1c4e0a8"
TGC_COOKIE_NAME = "UC_SSO_TGC-e5649925-441d-4a53-b525-51a2f1c4e0a8-product"
SMARTEDU_LOGIN_URL = "https://auth.smartedu.cn/uias"

# Path to the webview login script module
_WEBVIEW_SCRIPT_PATH = Path(__file__).parent / "webview_login.py"


class LoginThread(QThread):
    """QThread that runs the webview login in a subprocess."""
    tgc_obtained = Signal(str)
    login_error = Signal(str)
    
    def run(self):
        """Run the webview login script in a subprocess."""
        try:
            # Run the webview login script in a subprocess
            result = subprocess.run(
                [sys.executable, str(_WEBVIEW_SCRIPT_PATH)],
                capture_output=True,
                text=True,
                timeout=300  # 5 minute timeout
            )
            
            if result.returncode == 0 and result.stdout.strip():
                try:
                    data = json.loads(result.stdout.strip())
                    if data.get("tgc"):
                        self.tgc_obtained.emit(data["tgc"])
                    else:
                        self.login_error.emit("No TGC cookie found")
                except json.JSONDecodeError as e:
                    self.login_error.emit(f"Failed to parse webview result: {e}")
            else:
                if result.stderr:
                    self.login_error.emit(f"Webview error: {result.stderr}")
                else:
                    self.login_error.emit("Login cancelled or failed")
        except subprocess.TimeoutExpired:
            self.login_error.emit("Login timed out")
        except Exception as e:
            self.login_error.emit(f"Error running login: {e}")


class AuthManager(QObject):
    tgcCookie = Signal()
    tokenGot = Signal(dict)

    def __init__(self, parent):
        super().__init__()
        self.parent = parent
        self.tgc = None
        self._login_thread = None

    def _on_tgc_obtained(self, tgc: str):
        """Handle TGC cookie obtained from login thread."""
        self.tgc = tgc
        logger.debug(f"TGC obtained: {self.tgc[:20]}...")
        self.tgcCookie.emit()

    def _on_login_error(self, error: str):
        """Handle login error from login thread."""
        logger.error(f"Login error: {error}")

    @Slot(str)
    def get_token(self, tgc: str):
        try:
            response = requests.get("https://sso.basic.smartedu.cn/v1.1/sso/tokens", 
                                headers={"sdp-app-id": SDP_APP_ID, 
                                        "Referer": "https://basic.smartedu.cn/"},
                                cookies={TGC_COOKIE_NAME: tgc}
                                )
            data = response.json()
            if response.status_code != 200:
                logger.error(f"获取 Token 失败，状态码: {response.status_code}")
                result = {
                    "state": "error",
                    "message": f"{response.status_code} / {data['code']}\n{data['message']}"
                }
                self.tokenGot.emit(result)
                return result
            result = {
                "state": "success",
                "access_token": data["access_token"],
                "refresh_token": data["refresh_token"],
                "mac_key": data["mac_key"],
                "expires_at": datetime.fromisoformat(data["expires_at"]).strftime("%Y-%m-%d %A %H:%M:%S")
            }
            logger.debug(f"返回: {result}")
            self.tokenGot.emit(result)
            return result
        except Exception as e:
            logger.error(f"获取 Token 失败: {e}")
            result = {"state": "error", "message": str(e)}
            self.tokenGot.emit(result)
            return result

    def encode_mac(self, message, secret_key):
        secret_key_bytes = secret_key.encode('utf-8')
        message_bytes = message.encode('utf-8')
        hmac_hash = hmac.new(secret_key_bytes, message_bytes, hashlib.sha256).digest()

        base64_encoded_hash = base64.b64encode(hmac_hash).decode('utf-8')
        return base64_encoded_hash
    
    def get_nonce(self):
        CHARACTERS = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        result = ''.join(random.choice(CHARACTERS) for _ in range(8))
        timestamp = math.floor(time.time() * 1000)
        return f"{timestamp}:{result}"

    @Slot()
    def open_login(self):
        """Open a pywebview window for SmartEdu login in a separate process using QThread."""
        # Ensure only one login window can be open at a time
        if self._login_thread is not None and self._login_thread.isRunning():
            logger.warning("Login already in progress")
            return
        
        # Create and start the login thread
        self._login_thread = LoginThread()
        self._login_thread.tgc_obtained.connect(self._on_tgc_obtained)
        self._login_thread.login_error.connect(self._on_login_error)
        self._login_thread.start()

    @Slot(result=str)
    def get_tgc(self) -> str:
        return self.tgc if self.tgc else "N/A"

    def get_mac(self, url: str) -> str:
        if self.parent.helperConfig.getHeader() != "0":
            logger.debug("发现自定义 mac，不重新计算")
            return self.parent.helperConfig.getHeader()
        credential = self.parent.helperConfig.getCredential()
        if credential["access_token"] == "" or credential["mac_key"] == "":
            logger.debug("凭证不完整，无法计算 mac")
            return "0"
        if not url:
            logger.debug("URL 为空，无法计算 mac")
            return "0"
        try:
            url = urlparse(url)
        except Exception as e:
            logger.debug(f"URL 解析失败，无法计算 mac: {e}")
            return "0"
        nonce = self.get_nonce()
        token = credential["access_token"]
        message = f"{nonce}\nGET\n{url.path}\n{url.hostname}\n"
        secret_key = credential["mac_key"]
        mac = self.encode_mac(message, secret_key)
        return f'MAC id="{token}",nonce="{nonce}",mac="{mac}"'

if __name__ == "__main__":
    # 测试代码
    app = QApplication()
    auth_manager = AuthManager(None)
    nonce = "1766304929843:FRXEEDKA"
    secret_key = "EVm9GPfvuM"
    link = "https://r1-ndr-private.ykt.cbern.com.cn/edu_product/esp/assets/bdc00134-465d-454b-a541-dcd0cec4d86e.pkg/ebook_mapping_1750733054539.txt"
    url = urlparse(link)
    message = f"{nonce}\nGET\n{url.path}\n{url.hostname}\n"
    print(auth_manager.encode_mac(message, secret_key))