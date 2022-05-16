//
//  list.swift
//  printer-util
//
//  Created by Sebastiaan Eekhof on 16/05/2022.
//

import Foundation
import ArgumentParser

struct Show: ParsableCommand {
    @Flag(
        name: [.customLong("hex")],
        help: "Transforms the output to hexadecimal"
    )
    var hex: Bool = false
    
    @Argument(help: "The systemName of the printer")
    var printerName: String
    
    mutating func run() -> String {
        if let printer = Printer.byName(name: printerName) {
            return outputEncoding(from: printer.getDict(), hex: hex, fallback: "")
        } else {
            return ""
        }
    }
}
