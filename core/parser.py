from urllib import parse
from PySide6.QtCore import QObject, Slot, Signal

class LinkParser(QObject):
    linkParsed = Signal(dict)
    
    def __init__(self):
        super().__init__()

    @Slot(str)
    def parseLink(self, link: str) -> dict:
        """
        Parse the smartedu link to extract the file link and headers.
        Args:
            link (str): PDF viewer link.
        """
        o = parse.urlparse(link)
        print(o)
        if o.scheme != "https":
            self.linkParsed.emit({"error": "Invalid URL. Check your input."})
            return
        if o.netloc != "basic.smartedu.cn":
            self.linkParsed.emit({"error": "Invalid domain. Check your input."})
            return
        if o.path != "/pdfjs/2.15/web/viewer.html":
            self.linkParsed.emit({"error": "Invalid path. Check your input."})
            return
    
        # parse query string
        qs = parse.parse_qs(o.query)
        # get link from query string
        try:
            link = qs.get("file")[0]
        except:
            self.linkParsed.emit({"error": "File link not found. Check your input."})
            return
        
        # get header from query string        
        try:
            header = qs.get("headers")[0][1:-1]
        except:
            self.linkParsed.emit({"error": "Headers not found. Check your input."})
            return

        link = parse.quote(link)

        # convert headers to curl style
        header = header.replace('":"', ': ')

        self.linkParsed.emit({"link":link, "header": header})

if __name__ == "__main__":
    link = r'https://basic.smartedu.cn/pdfjs/2.15/web/viewer.html?hasCatalog=true&file=https://r2-ndr-private.ykt.cbern.com.cn/edu_product/esp/assets/540ac93d-67fc-4353-9e49-1ef20d02b5a4.pkg/义务教育教科书 数学 七年级 上册_1756191705566.pdf&headers={"X-ND-AUTH":"MAC id=\"7F938B205F876FC39BD5FD64A3C8216792EDF370BFFB67E601906701C85E4290A092FF7DCCB911D956DAA8FA15A1EF4A5CEF64FED6F924D7\",nonce=\"1764467759762:ATEC2NLZ\",mac=\"qLu0TlooPq4d4xfVyjxuIA4MgN0/BMM4pLF7nFwZwFU=\""}'
    parser = LinkParser()
    parser.parseLink(link)