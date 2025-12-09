import sys
from PySide6.QtWidgets import QApplication

import RinUI
from RinUI import RinUIWindow

from core import LinkParser, GenericBookList, HelperConfig


class MainWindow(RinUIWindow):
    def __init__(self):
        super().__init__()

        # Create backend objects before loading QML so context properties are available immediately.
        self.linkParser = LinkParser()
        self.primaryBookList = GenericBookList("list/primary.json")
        self.primary54BookList = GenericBookList("list/primary54.json")
        self.juniorBookList = GenericBookList("list/junior.json")
        self.junior54BookList = GenericBookList("list/junior54.json")
        self.helperConfig = HelperConfig(self)

        self.engine.rootContext().setContextProperty("LinkParser", self.linkParser)
        self.engine.rootContext().setContextProperty("PrimaryBookList", self.primaryBookList)
        self.engine.rootContext().setContextProperty("Primary54BookList", self.primary54BookList)
        self.engine.rootContext().setContextProperty("JuniorBookList", self.juniorBookList)
        self.engine.rootContext().setContextProperty("Junior54BookList", self.junior54BookList)
        self.engine.rootContext().setContextProperty("HelperConfig", self.helperConfig)

        self.load("src/main.qml")