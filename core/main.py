import sys
from PySide6.QtWidgets import QApplication

import RinUI
from RinUI import RinUIWindow

from core import LinkParser


class MainWindow(RinUIWindow):
    def __init__(self):
        super().__init__("src/main.qml")
        self.linkParser = LinkParser()
        self.engine.rootContext().setContextProperty("LinkParser", self.linkParser)