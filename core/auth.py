from PySide6.QtCore import QObject, Signal, Slot
from PySide6.QtWidgets import QApplication
from PySide6.QtWebEngineCore import QWebEngineProfile
import hmac
import hashlib
import base64
import random
import math
import requests
import time
from urllib.parse import urlparse
from datetime import datetime
from loguru import logger

SDP_APP_ID = "e5649925-441d-4a53-b525-51a2f1c4e0a8"
TGC_COOKIE_NAME = "UC_SSO_TGC-e5649925-441d-4a53-b525-51a2f1c4e0a8-product"

class AuthManager(QObject):
    tgcCookie = Signal()
    tokenGot = Signal(dict)

    def __init__(self, parent):
        super().__init__()
        self.parent = parent
        self.tgc = None
        self._watch_cookie()

    @Slot(str)
    def get_token(self, tgc: str):
        try:
            response = requests.get("https://sso.basic.smartedu.cn/v1.1/sso/tokens", 
                                headers={"sdp-app-id": SDP_APP_ID, 
                                        "Referer": "https://basic.smartedu.cn/"},
                                cookies={"UC_SSO_TGC-e5649925-441d-4a53-b525-51a2f1c4e0a8-product": tgc}
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

    def _watch_cookie(self):
        profile = QWebEngineProfile.defaultProfile()
        store = profile.cookieStore()
        store.cookieAdded.connect(self._handle_cookie_added)

    def _handle_cookie_added(self, cookie):
        name = bytes(cookie.name()).decode(errors="ignore")
        value = bytes(cookie.value()).decode(errors="ignore")
        domain = cookie.domain()
        path = cookie.path()
        secure = cookie.isSecure()
        http_only = cookie.isHttpOnly()
        details = f"{name}={value}; domain={domain}; path={path}; secure={secure}; httpOnly={http_only}"
        logger.debug(f"新 Cookie： {details}")
        if name == TGC_COOKIE_NAME:
            self.tgc = value
            self.tgcCookie.emit()

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