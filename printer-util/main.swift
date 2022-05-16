//
//  main.swift
//  printer-util
//
//  Created by Sebastiaan Eekhof on 13/05/2022.
//

import Foundation
import Quartz
import ArgumentParser

if(CLI.getFirst() == nil) {
    showHelpMenu();
    exit(1);
}

switch(CLI.getFirst()!) {
    case "list":
        var options = List.parseOrExit(CLI.getArguments())
        print(options.run());
        exit(1)
    break;
    case "default":
        var options = Default.parseOrExit(CLI.getArguments())
        print(options.run());
        exit(1)
    break;
    case "show":
        var options = Show.parseOrExit(CLI.getArguments())
        print(options.run());
        exit(1)
    break;
    case "print":
        var options = Print.parseOrExit(CLI.getArguments())
        print(options.run());
        exit(1)
    break;
    default:
        showHelpMenu();
        exit(1);
    break;
}
