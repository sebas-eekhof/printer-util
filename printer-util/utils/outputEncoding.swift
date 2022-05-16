//
//  outputEncoding.swift
//  printer-util
//
//  Created by Sebastiaan Eekhof on 16/05/2022.
//

import Foundation

func outputEncoding(from: Any, hex: Bool, fallback: String) -> String {
    var res: String;
    
    do {
        let data = try JSONSerialization.data(withJSONObject: from);
        res = String(data: data, encoding: String.Encoding.utf8) ?? fallback
    } catch {
        res = fallback
    }
    
    if(hex) {
        res = Data(res.utf8).map({ String(format: "%02x", $0) }).joined();
    }
    
    return res;
}
