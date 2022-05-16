//
//  Printers.swift
//  printer-util
//
//  Created by Sebastiaan Eekhof on 16/05/2022.
//

import Foundation
import AppKit
import Quartz

struct Printer {
    private var pmprinter: PMPrinter
    var name: String
    var systemName: String
    var location: String?
    var isDefault: Bool
    
    init(printer: PMPrinter) {
        self.pmprinter = printer
        self.name = PMPrinterGetName(self.pmprinter)!.takeUnretainedValue().toString()
        self.systemName = PMPrinterGetID(self.pmprinter)!.takeUnretainedValue().toString()
        self.location = PMPrinterGetLocation(self.pmprinter)?.takeUnretainedValue().toStringEmpty()
        self.isDefault = PMPrinterIsDefault(self.pmprinter)
    }
    
    func getState() {
        var state: PMPrinterState = 0
        PMPrinterGetState(self.pmprinter, &state)
        switch state {
            case UInt16(kPMPrinterIdle):
        }
        print(unmanagedState)
    }
    
    static func defaultPrinter() -> Printer? {
        let filtered = self.all().filter({ $0.isDefault })
        if filtered.count == 0 {
            return nil
        } else {
            return filtered[0]
        }
    }
    
    static func all() -> [Printer] {
        var unmanagedPrinterArray: Unmanaged<CFArray>?
        PMServerCreatePrinterList(nil, &unmanagedPrinterArray)
        if let printerArray = unmanagedPrinterArray?.takeUnretainedValue() {
            var printers: [PMPrinter] = []
            for idx in 0 ..< CFArrayGetCount(printerArray) {
                printers.append(PMPrinter(CFArrayGetValueAtIndex(printerArray, idx)))
            }
            return printers.map({ self.init(printer: $0) })
        } else {
            return []
        }
    }
}

//struct Printer {
//    var name: String;
//    var systemName: String;
//
//    init(printer: NSPrinter) {
//
//        self.name = printer.name
//        self.systemName = printer.type.rawValue
//    }
//
//    static func defaultPrinter() -> Printer? {
//        if let printer = NSPrintInfo.defaultPrinter {
//            return Printer.init(printer: printer)
//        } else {
//            return nil
//        }
//    }
//
//    static func all() -> [Printer] {
//        return NSPrinter.printerNames
//            .map({ NSPrinter.init(name: $0) })
//            .filter({ $0 != nil })
//            .map({ Printer.init(printer: $0!) })
//    }
//}
