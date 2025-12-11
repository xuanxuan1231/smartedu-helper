import json

from PySide6.QtCore import QObject, Slot


class GenericBookList(QObject):
    def __init__(self, file="booklist.json"):
        super().__init__()
        self.file = file
        self.data = self.load_books()

    def load_books(self):
        try:
            with open(self.file, "r", encoding="utf-8") as f:
                return json.load(f)
        except FileNotFoundError:
            print(f"Book list file '{self.file}' not found.")
            return {}

    def reload(self):
        self.data = self.load_books()

    # 目前没实际用处 后面可能会加更新
    @Slot(result=str)
    def get_list_version(self):
        return self.data.get("version", "Unknown") if self.data else "Unknown"

    @Slot(result='QVariant')
    def get_subjects(self):
        if self.data:
            return [subject.get("name", "Unknown") for subject in self.data.get("subjects", [])]
        return []

    @Slot(int, result='QVariant')
    def get_versions(self, subject: int):
        if self.data:
            subjects = self.data.get("subjects", [])
            # 不能是负的 也不能超过最大
            if 0 <= subject < len(subjects):
                versions = subjects[subject].get("versions", [])
                return [v.get("name", "Unknown") for v in versions]
        return []

    @Slot(int, int, result='QVariant')
    def get_grades(self, subject: int, version: int):
        if self.data:
            subjects = self.data.get("subjects", [])
            if 0 <= subject < len(subjects):
                versions = subjects[subject].get("versions", [])
                if 0 <= version < len(versions):
                    grades = versions[version].get("grades", [])
                    return [g.get("name", "Unknown") for g in grades]
        return []

    @Slot(int, int, int, result='QVariant')
    def get_books(self, subject: int, version: int, grade: int):
        if self.data:
            # 最傻子的判定 没有之一
            subjects = self.data.get("subjects", [])
            if 0 <= subject < len(subjects):
                versions = subjects[subject].get("versions", [])
                if 0 <= version < len(versions):
                    grades = versions[version].get("grades", [])
                    if 0 <= grade < len(grades):
                        return grades[grade].get("books", [])
        return []


if __name__ == "__main__":
    list = GenericBookList("list/junior.json")
    print(list.data)
    print(list.get_versions(0))