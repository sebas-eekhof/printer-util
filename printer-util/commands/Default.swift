//
//  list.swift
//  printer-util
//
//  Created by Sebastiaan Eekhof on 16/05/2022.
//

import Foundation
import ArgumentParser

struct Default: ParsableCommand {
    @Flag(
        name: [.customLong("hex")],
        help: "Transforms the output to hexadecimal"
    )
    var hex: Bool = false
    
    mutating func run() -> String {
        if let printer = Printer.defaultPrinter()?.overview.getDict() {
            return outputEncoding(from: printer, hex: hex, fallback: "")
        } else {
            return ""
        }
    }
}
