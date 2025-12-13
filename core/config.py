from PySide6.QtCore import QObject, Slot, Signal, QLocale, QTranslator
from PySide6.QtWidgets import QApplication
from RinUI import ConfigManager, RinUITranslator
from pathlib import Path

DEFAULT_CONFIG = {
    "proxy": {
        "http": None,
        "https": None
    },
    "locale": {
        "language": QLocale.system().name(),
    },
    "file_server": "1",
    "oversea": False,
    "header": "0",
    "default_path": Path(Path(__file__).parent.parent / "downloads")
}

class HelperConfig(ConfigManager, QObject):
    def __init__(self, parent = None):
        self.translator = None
        self.ui_translator = None
        filename = "config.json"
        self.parent = parent

        ConfigManager.__init__(self, ".", filename)
        QObject.__init__(self)

        self.load_config(DEFAULT_CONFIG)
        # 启动时设置语言
        self.setLanguage(self.config["locale"]["language"])

    # i18n
    @Slot(result=str)
    def getLanguage(self) -> str:
        return self.config["locale"]["language"]

    @Slot(result=str)
    def getSystemLanguage(self):
        return QLocale.system().name()

    @Slot(str)
    def setLanguage(self, language: str) -> None:
        lang_path = Path(f"./i18n/{language}.qm")
        if not lang_path.exists():  # fallback
            print(f"Language file {lang_path} not found. Fallback to default (en_US)")
            language = "en_US"

        self.config["locale"]["language"] = language
        self.save_config()
        self.ui_translator = RinUITranslator(QLocale(language))
        self.translator = QTranslator()
        self.translator.load(lang_path.as_posix())
        QApplication.instance().removeTranslator(self.ui_translator)
        QApplication.instance().removeTranslator(self.translator)
        QApplication.instance().installTranslator(self.ui_translator)
        QApplication.instance().installTranslator(self.translator)
        self.parent.engine.retranslate()

    @Slot(result=str)
    def getFileServer(self) -> str:
        return self.config["file_server"]
    
    @Slot(str)
    def setFileServer(self, server: str) -> None:
        self.config["file_server"] = server
        self.save_config()

    @Slot(result=bool)
    def getOverseaServer(self) -> bool:
        return self.config["file_server"] != "false"

    @Slot(bool)
    def setOverseaServer(self, oversea: bool) -> None:
        self.config["oversea"] = oversea
        self.save_config()

    @Slot(result=str)
    def getHeader(self) -> str:
        return self.config["header"]

    @Slot(str)
    def setHeader(self, header: str) -> None:
        self.config["header"] = header
        self.save_config()

    @Slot(result=str)
    def getDefaultPath(self) -> str:
        return self.config["default_path"]
    
    @Slot(str)
    def setDefaultPath(self, path: str) -> None:
        self.config["default_path"] = path
        self.save_config()