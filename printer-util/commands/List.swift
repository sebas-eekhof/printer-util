//
//  list.swift
//  printer-util
//
//  Created by Sebastiaan Eekhof on 16/05/2022.
//

import Foundation
import ArgumentParser

struct List: ParsableCommand {
    @Flag(
        name: [.customLong("hex")],
        help: "Transforms the output to hexadecimal"
    )
    var hex: Bool = false
    
    mutating func run() -> String {
        let printers: [Dictionary<String, Any>] = Printer.all().map({ $0.overview.getDict() })
        return outputEncoding(from: printers, hex: hex, fallback: "[]")
    }
}
