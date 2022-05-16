//
//  Printers.swift
//  printer-util
//
//  Created by Sebastiaan Eekhof on 16/05/2022.
//

import Foundation
import AppKit
import Quartz

struct PrinterOverview {
    var name: String
    var systemName: String
    var location: String?
    var isDefault: Bool
    var isFavorite: Bool
    var isPostScriptCapable: Bool
    
    func getDict() -> Dictionary<String, Any> {
        return [
            "name": self.name,
            "systemName": self.systemName,
            "location": self.location as Any,
            "isDefault": self.isDefault,
            "isFavorite": self.isDefault,
            "isPostScriptCapable": self.isPostScriptCapable
        ]
    }
}

struct Printer {
    private var pmprinter: PMPrinter
    var overview: PrinterOverview
    
    init(printer: PMPrinter) {
        self.pmprinter = printer
        
        self.overview = PrinterOverview.init(
            name: PMPrinterGetName(self.pmprinter)!.takeUnretainedValue().toString(),
            systemName: PMPrinterGetID(self.pmprinter)!.takeUnretainedValue().toString(),
            location: PMPrinterGetLocation(self.pmprinter)?.takeUnretainedValue().toStringEmpty(),
            isDefault: PMPrinterIsDefault(self.pmprinter),
            isFavorite: PMPrinterIsFavorite(self.pmprinter),
            isPostScriptCapable: PMPrinterIsPostScriptCapable(self.pmprinter)
        )
    }
    
    func printFile(_ path: String) {
        var pmprintsettings: PMPrintSettings? = nil
        PMCreatePrintSettings(&pmprintsettings)
        
        var pmpageformat: PMPageFormat? = nil
        PMCreatePageFormat(&pmpageformat)
        
        let fileURL: URL = URL(fileURLWithPath: path)
        
        
        PMPrinterPrintWithFile(self.pmprinter, pmprintsettings!, pmpageformat!, fileURL.mimeType() as CFString, fileURL as CFURL)
    }
    
    func getDict() -> Dictionary<String, Any> {
        return [
            "name": self.overview.name,
            "systemName": self.overview.systemName,
            "location": self.overview.location as Any,
            "isDefault": self.overview.isDefault,
            "isPostScriptCapable": self.overview.isPostScriptCapable,
            "isFavorite": self.overview.isFavorite,
            "state": self.getState().name,
            "url": self.getDeviceUrl()?.absoluteString as Any,
            "mimeTypes": self.getMimeTypes(),
            "paperTypes": self.getPaperList().map({ $0.getDict() })
        ]
    }
    
    func getPaperList() -> [PrinterPaper] {
        var CFPaperList: Unmanaged<CFArray>? = nil
        PMPrinterGetPaperList(self.pmprinter, &CFPaperList)
        if let paperList = CFPaperList?.takeUnretainedValue() {
            var papers: [PrinterPaper] = []
            for idx in 0 ..< CFArrayGetCount(paperList) {
                if let paper: PMPaper = PMPaper.init(CFArrayGetValueAtIndex(paperList, idx)) {
                    papers.append(PrinterPaper.init(paper, printer: self.pmprinter))
                }
            }
            return papers
        } else {
            return []
        }
    }
    
    func getDeviceUrl() -> URL? {
        var CFDeviceUrl: Unmanaged<CFURL>? = nil
        PMPrinterCopyDeviceURI(self.pmprinter, &CFDeviceUrl)
        if let url = CFDeviceUrl?.takeUnretainedValue() {
            return url as URL
        } else {
            return nil
        }
    }
    
    func isRemote() -> Bool {
        var CFRemote: DarwinBoolean = false
        PMPrinterIsRemote(self.pmprinter, &CFRemote)
        return CFRemote.boolValue
    }
    
    func isPostscriptPrinter() -> Bool {
        var CFPostScript: DarwinBoolean = false
        PMPrinterIsPostScriptPrinter(self.pmprinter, &CFPostScript)
        return CFPostScript.boolValue
    }
    
    func setDefault() -> Void {
        PMPrinterSetDefault(self.pmprinter)
    }
    
    func getMimeTypes() -> [String] {
        var CFMimes: Unmanaged<CFArray>? = nil
        PMPrinterGetMimeTypes(self.pmprinter, nil, &CFMimes)
        if let mimeArray = CFMimes?.takeUnretainedValue() {
            return mimeArray as! [String]
        }
        return []
    }
    
    func getState() -> PrinterState {
        var state: PMPrinterState = 0
        PMPrinterGetState(self.pmprinter, &state)
        switch state {
            case UInt16(kPMPrinterProcessing):
                return PrinterState.processing
            case UInt16(kPMPrinterIdle):
                return PrinterState.idle
            case UInt16(kPMPrinterStopped):
                return PrinterState.stopped
            default:
                return PrinterState.unknown
        }
    }
    
    static func defaultPrinter() -> Printer? {
        let filtered = self.PMPrinters()
            .filter({ PMPrinterIsDefault($0) })
        if filtered.count == 0 {
            return nil
        } else {
            return self.init(printer: filtered[0])
        }
    }
    
    static func all() -> [Printer] {
        self.PMPrinters().map({ self.init(printer: $0) })
    }
    
    static func byName(name: String) -> Printer? {
        let filtered = self.PMPrinters()
            .filter({ name == PMPrinterGetID($0)!.takeUnretainedValue().toString() })
        if filtered.count == 0 {
            return nil
        } else {
            return self.init(printer: filtered[0])
        }
    }
    
    private static func PMPrinters() -> [PMPrinter] {
        var unmanagedPrinterArray: Unmanaged<CFArray>?
        PMServerCreatePrinterList(nil, &unmanagedPrinterArray)
        if let printerArray = unmanagedPrinterArray?.takeUnretainedValue() {
            var printers: [PMPrinter] = []
            for idx in 0 ..< CFArrayGetCount(printerArray) {
                printers.append(PMPrinter(CFArrayGetValueAtIndex(printerArray, idx)))
            }
            return printers
        } else {
            return []
        }
    }
}
