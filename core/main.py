import sys
from PySide6.QtWidgets import QApplication

import RinUI
from RinUI import RinUIWindow


class MainWindow(RinUIWindow):
    def __init__(self):
        super().__init__("src/main.qml")