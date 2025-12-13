from PySide6.QtCore import QObject, Signal, Slot, QThread
import requests
import os
from loguru import logger
from pathlib import Path

class DownloadManager(QObject):
    dataUpdated = Signal() #通知UI
    newTaskAdded = Signal()
    taskCompleted = Signal(str)
    taskError = Signal(str)  # task name, error message

    def __init__(self, parent):
        super().__init__()
        self.tasks = []

        self.downloadThread = None

        self.newTaskAdded.connect(self.onNewTaskAdded)
        self.taskCompleted.connect(self.onTaskCompleted)
        self.parent = parent

    @Slot(str, str, str, str, result=dict)
    def addTask(self, name: str, path: str, header: str, save_path: str) -> dict:
        for task in self.tasks:
            if task["name"] == name:
                if task["status"] == "error":
                    # 允许重新添加失败的任务
                    self.tasks.remove(task)
                    logger.debug(f"重新添加任务 {name}")
                    break
                logger.warning(f"任务 {name} 已存在，无法添加重复任务")
                return {"state": "warning", "message": self.tr("Task with the same name already exists.")}
        url = f"https://r{self.parent.helperConfig.getFileServer()}-ndr-{"oversea" if self.parent.helperConfig.getOverseaServer() else "private"}.ykt.cbern.com.cn{path}"
        task = {
            "name": name,
            "url": url,
            "headers": header,
            "save_path": save_path,
            "status": "pending",
            "progress": 0
        }
        self.tasks.append(task)
        self.newTaskAdded.emit()
        self.dataUpdated.emit()
        logger.success(f"添加了任务 {task['name']}")
        return {"state": "success", "message": self.tr("Task added successfully.")}

    def onNewTaskAdded(self):
        self.tryNextTask()
    
    def tryNextTask(self):
        for task in self.tasks:
            # 看有没有正在进行的下载
            if task["status"] == "in_progress":
                return 
            if task["status"] == "pending":
                task["status"] = "in_progress"
                self.downloadThread = DownloadThread(task["name"], task["url"], {"x-nd-auth": task["headers"]}, task["save_path"])
                self.downloadThread.finished.connect(lambda: self.taskCompleted.emit(task["name"]))
                self.downloadThread.error.connect(lambda msg, name=task["name"]: self.onTaskError(name, msg))
                self.downloadThread.progress.connect(lambda progress, name=task["name"]: self.updateProgress(name, progress))
                self.downloadThread.start()
                logger.debug(f"开始任务 {task['name']}")
                return

    def updateProgress(self, name: str, progress: int):
        for task in self.tasks:
            if task["name"] == name:
                task["progress"] = progress
                logger.debug(f"任务进度 {progress}")
                self.dataUpdated.emit()

    def onTaskCompleted(self, name: str):
        for task in self.tasks:
            if task["name"] == name:
                task["status"] = "completed"
        self.dataUpdated.emit()
        self.tryNextTask()  # 开始下一个任务

    def onTaskError(self, name: str, error_message: str):
        for task in self.tasks:
            if task["name"] == name:
                task["status"] = "error"
        self.dataUpdated.emit()
        self.tryNextTask()  # 开始下一个任务

    @Slot(result=list)
    def getTasks(self) -> list:
        return self.tasks

class DownloadThread(QThread):
    finished = Signal()
    error = Signal(str)
    progress = Signal(int)

    def __init__(self, name: str, url: str, headers: dict, save_path: str):
        super().__init__()
        self.name = name
        self.url = url
        self.headers = headers
        self.save_path = Path(save_path)

    def run(self):
        try:
            logger.debug("开始下载")
            resp = requests.get(self.url, headers=self.headers, stream=True, timeout=30)
            resp.raise_for_status()
            logger.debug("获得响应头")
            total = resp.headers.get("Content-Length")
            logger.debug(f"Content-Length: {total}")
            total = int(total) if total and total.isdigit() else None

            downloaded = 0
            last_percent = -1

            self.save_path.mkdir(parents=True, exist_ok=True)
            target_file = self.save_path / f"{self.name}.pdf"

            with open(target_file, "wb") as f:
                for chunk in resp.iter_content(chunk_size=8192):
                    if not chunk:
                        continue
                    f.write(chunk)
                    downloaded += len(chunk)
                    if total:
                        percent = int(downloaded * 100 / total)
                    else:
                        # If total size unknown, keep showing 0 until finished.
                        percent = 0

                    if percent != last_percent:
                        last_percent = percent
                        try:
                            self.progress.emit(percent)
                        except Exception as e:
                            self.error.emit(str(e))
                            return
                self.progress.emit(100)
        except Exception as e:
            logger.error(f"下载出错: {e}")
            logger.debug(f"Headers: {self.headers}")
            self.error.emit(str(e))
            return

        self.finished.emit()