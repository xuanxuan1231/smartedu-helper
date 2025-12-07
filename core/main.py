import sys
from PySide6.QtWidgets import QApplication

import RinUI
from RinUI import RinUIWindow

from core import LinkParser, GenericBookList


class MainWindow(RinUIWindow):
    def __init__(self):
        super().__init__("src/main.qml")
        self.linkParser = LinkParser()

        self.primaryBookList = GenericBookList("list/primary.json")
        self.juniorBookList = GenericBookList("list/junior.json")

        self.engine.rootContext().setContextProperty("LinkParser", self.linkParser)
        self.engine.rootContext().setContextProperty("PrimaryBookList", self.primaryBookList)
        self.engine.rootContext().setContextProperty("JuniorBookList", self.juniorBookList)