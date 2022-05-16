//
//  PrinterPaper.swift
//  printer-util
//
//  Created by Sebastiaan Eekhof on 16/05/2022.
//

import Foundation
import Quartz

struct PrinterPaperMargins {
    var top: Double
    var left: Double
    var bottom: Double
    var right: Double
    
    func getDict() -> Dictionary<String, Double> {
        return [
            "top": self.top,
            "left": self.left,
            "bottom": self.bottom,
            "right": self.right
        ]
    }
}

struct PrinterPaper {
    private var pmpaper: PMPaper
    private var pmprinter: PMPrinter
    var id: String
    var name: String
    var PPDName: String
    var isCustom: Bool
    
    init(_ paper: PMPaper, printer: PMPrinter) {
        self.pmpaper = paper
        self.pmprinter = printer
        
        var CFId: Unmanaged<CFString>? = nil
        PMPaperGetID(self.pmpaper, &CFId)
        self.id = CFId!.takeUnretainedValue().toString()
        
        var CFName: Unmanaged<CFString>? = nil
        PMPaperCreateLocalizedName(self.pmpaper, self.pmprinter, &CFName)
        self.name = CFName!.takeUnretainedValue().toString()
        
        var CFPPDName: Unmanaged<CFString>? = nil
        PMPaperGetPPDPaperName(self.pmpaper, &CFPPDName)
        self.PPDName = CFPPDName!.takeUnretainedValue().toString()
     
        self.isCustom = PMPaperIsCustom(self.pmpaper)
    }
    
    func getWidth() -> Double {
        var width: Double = 0
        PMPaperGetWidth(self.pmpaper, &width)
        return width
    }
    
    func getHeight() -> Double {
        var height: Double = 0
        PMPaperGetHeight(self.pmpaper, &height)
        return height
    }
    
    func getMargins() -> PrinterPaperMargins {
        var margins: PMPaperMargins = PMPaperMargins.init(top: 0, left: 0, bottom: 0, right: 0)
        PMPaperGetMargins(self.pmpaper, &margins)
        return PrinterPaperMargins.init(top: margins.top, left: margins.left, bottom: margins.bottom, right: margins.right)
    }
    
    func getDict() -> Dictionary<String, Any> {
        return [
            "id": self.id,
            "name": self.name,
            "PPDName": self.PPDName,
            "width": self.getWidth(),
            "height": self.getHeight(),
            "margins": self.getMargins().getDict(),
            "isCustom": self.isCustom
        ]
    }
}
