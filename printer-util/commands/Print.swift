//
//  list.swift
//  printer-util
//
//  Created by Sebastiaan Eekhof on 16/05/2022.
//

import Foundation
import ArgumentParser

struct Print: ParsableCommand {
    @Argument(help: "The systemName of the printer")
    var printerName: String
    
    @Argument(
        help: "The file to print"
    )
    var filePath: String
    
    mutating func run() -> String {
        if let printer = Printer.byName(name: printerName) {
            printer.printFile(filePath)
            return "OK"
        } else {
            return "ERR"
        }
    }
}
