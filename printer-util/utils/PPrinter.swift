//
//  PPrinter.swift
//  printer-util
//
//  Created by Sebastiaan Eekhof on 16/05/2022.
//

import Foundation
import Quartz

class PPrinter {
    
    static func getNames() -> [PMPrinter]? {
        return PPrinter.PMPrinters()
    }
    
    private static func PMPrinters() -> [PMPrinter]? {
        var unmanagedPrinterArray: Unmanaged<CFArray>?
        PMServerCreatePrinterList(nil, &unmanagedPrinterArray)
        if let printerArray = unmanagedPrinterArray?.takeUnretainedValue() {
            var printers: [PMPrinter] = []
            for idx in 0 ..< CFArrayGetCount(printerArray) {
                printers.append(PMPrinter(CFArrayGetValueAtIndex(printerArray, idx)))
            }
            return printers
        } else {
            return nil
        }
    }
    
}
