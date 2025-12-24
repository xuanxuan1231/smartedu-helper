import sys
from PySide6.QtWidgets import QApplication

import RinUI
from core.main import MainWindow
from loguru import logger

logger.add("logs/log_{time:YYYY-MM-DD}.log", rotation="10 MB", retention="10 days", encoding="utf-8")


if __name__ == '__main__':
    print(RinUI.__file__)
    app = QApplication(sys.argv)
    window = MainWindow()
    app.exec()