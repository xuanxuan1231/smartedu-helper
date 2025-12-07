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
    }
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