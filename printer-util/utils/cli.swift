//
//  cli.swift
//  printer-util
//
//  Created by Sebastiaan Eekhof on 16/05/2022.
//

import Foundation

class CLI {
    static let commands: [String] = ["list"];
    
    static func getFirst() -> String? {
        if(CommandLine.arguments.count <= 1) {
            return nil;
        } else {
            return CommandLine.arguments[1];
        }
    }
    
    static func getArguments() -> [String] {
        if(CommandLine.arguments.count <= 2) {
            return [];
        } else {
            var arguments: [String] = [];
            for i in 2...(CommandLine.arguments.count - 1) {
                arguments.append(CommandLine.arguments[i])
            }
            return arguments;
        }
    }
    
    static func execName() -> String {
        if(CommandLine.arguments.count < 1) {
            return "printer-utils";
        } else {
            return CommandLine.arguments[0];
        }
    }
}
