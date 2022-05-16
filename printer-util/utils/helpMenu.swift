//
//  ui.swift
//  printer-util
//
//  Created by Sebastiaan Eekhof on 16/05/2022.
//

import Foundation

func showHelpMenu() -> Void {
    print("USAGE: \(CLI.execName()) <\(CLI.commands.joined(separator: ","))>")
}
