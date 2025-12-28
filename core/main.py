from PySide6.QtWebEngineQuick import QtWebEngineQuick
from RinUI import RinUIWindow
from pathlib import Path

from core import *


class MainWindow(RinUIWindow):
    def __init__(self):
        # Required for QML `import QtWebEngine` / `WebEngineView`
        QtWebEngineQuick.initialize()
        super().__init__()

        # Create backend objects before loading QML so context properties are available immediately.
        self.linkParser = LinkParser()
        self.primaryBookList = GenericBookList(Path(ROOT / "list/primary.json"))
        self.primary54BookList = GenericBookList(Path(ROOT / "list/primary54.json"))
        self.juniorBookList = GenericBookList(Path(ROOT / "list/junior.json"))
        self.junior54BookList = GenericBookList(Path(ROOT / "list/junior54.json"))
        self.seniorBookList = GenericBookList(Path(ROOT / "list/senior.json"))
        self.specialBookList = SpecialBookList(Path(ROOT / "list/special.json"))
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

        self.load(Path(ROOT / "src/main.qml"))

        self.setIcon(Path(ROOT / "assets/icon.png"))