//
//  Logger.swift
//  List Photo
//
//  Created by KhuePM on 12/4/25.
//

import Foundation

class Logger {
    static let shared = Logger()

    private init() {}

    func debugPrint(
        _ message: Any,
        extra1: String = #file,
        extra2: String = #function,
        extra3: Int = #line,
        function: Any? =  nil,
        plain: Bool = false) {
            if (plain) {
                print(message)
            } else {
                let fileName = (extra1 as NSString).lastPathComponent
                print("DEBUG: \(String(describing: function))")
                print("[\(fileName)] line \(extra3): \(message)\n")
            }
        }

    func prettyPrint(_ message: Any) {
        dump(message)
    }

    func printDocumentDirectory() {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print("Document Path: \(documentPath)")
    }
}
