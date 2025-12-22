import sys
from PySide6.QtWidgets import QApplication
from PySide6.QtWebView import QtWebView

import RinUI
from RinUI import RinUIWindow

from core import *


class MainWindow(RinUIWindow):
    def __init__(self):
        QtWebView.initialize()
        super().__init__()

        # Create backend objects before loading QML so context properties are available immediately.
        self.linkParser = LinkParser()
        self.primaryBookList = GenericBookList("list/primary.json")
        self.primary54BookList = GenericBookList("list/primary54.json")
        self.juniorBookList = GenericBookList("list/junior.json")
        self.junior54BookList = GenericBookList("list/junior54.json")
        self.seniorBookList = GenericBookList("list/senior.json")
        self.specialBookList = SpecialBookList("list/special.json")
        self.helperConfig = HelperConfig(self)
        self.downloadManager = DownloadManager(self)
        self.authManager = AuthManager(self)

        self.engine.rootContext().setContextProperty("LinkParser", self.linkParser)
        self.engine.rootContext().setContextProperty("PrimaryBookList", self.primaryBookList)
        self.engine.rootContext().setContextProperty("Primary54BookList", self.primary54BookList)
        self.engine.rootContext().setContextProperty("JuniorBookList", self.juniorBookList)
        self.engine.rootContext().setContextProperty("Junior54BookList", self.junior54BookList)
        self.engine.rootContext().setContextProperty("SeniorBookList", self.seniorBookList)
        self.engine.rootContext().setContextProperty("SpecialBookList", self.specialBookList)
        self.engine.rootContext().setContextProperty("HelperConfig", self.helperConfig)
        self.engine.rootContext().setContextProperty("DownloadManager", self.downloadManager)
        self.engine.rootContext().setContextProperty("AuthManager", self.authManager)

        self.load("src/main.qml")