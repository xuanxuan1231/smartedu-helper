import sys
from PySide6.QtWidgets import QApplication
from PySide6.QtWebEngineQuick import QtWebEngineQuick
from pathlib import Path

import RinUI
from core.main import MainWindow, ROOT
from loguru import logger

logger.add(Path(ROOT / "logs/log_{time:YYYY-MM-DD}.log"), rotation="10 MB", retention="10 days", encoding="utf-8")


if __name__ == '__main__':
    print(RinUI.__file__)
    QtWebEngineQuick.initialize()
    app = QApplication(sys.argv)
    window = MainWindow()
    app.exec()