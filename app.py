import sys
from PySide6.QtWidgets import QApplication

import RinUI
from core.main import MainWindow


if __name__ == '__main__':
    print(RinUI.__file__)
    app = QApplication(sys.argv)
    window = MainWindow()
    app.exec()