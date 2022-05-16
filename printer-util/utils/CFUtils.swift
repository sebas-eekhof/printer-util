//
//  CFUtils.swift
//  printer-util
//
//  Created by Sebastiaan Eekhof on 16/05/2022.
//

import Foundation
import UniformTypeIdentifiers

extension CFString {
    func toString() -> String {
        return String(self)
    }
    
    func toStringEmpty() -> String? {
        if self.toString().count == 0 {
            return nil
        } else {
            return self.toString()
        }
    }
    
    static func from(_ str: String) -> CFString {
        return str as CFString
    }
}

extension URL {
    func mimeType() -> String {
        return UTType(filenameExtension: self.pathExtension)?.preferredMIMEType ?? "application/octet-stream"
    }
}
