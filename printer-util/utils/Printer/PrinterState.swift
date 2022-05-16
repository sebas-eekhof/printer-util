//
//  State.swift
//  printer-util
//
//  Created by Sebastiaan Eekhof on 16/05/2022.
//

import Foundation

enum PrinterState {
    case idle, stopped, processing, unknown
    
    var name: String {
        switch self {
            case .idle: return "idle"
            case .stopped: return "stopped"
            case .processing: return "processing"
            case .unknown: return "unknown"
        }
    }
}
