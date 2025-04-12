//
//  SearchValidator.swift
//  List Photo
//
//  Created by KhuePM on 12/4/25.
//

import Foundation

struct SearchValidator {
    static let allowedSpecialCharacters = "!@#$%^&*():.,<>/\\[]?"

    static func isValidCharacter(_ char: Character) -> Bool {
        if char.isLetter {
            return char.isASCII && !char.isDiacritic
        }
        if char.isNumber {
            return true
        }
        if allowedSpecialCharacters.contains(char) {
            return true
        }
        return false
    }

    static func sanitizeInput(_ input: String) -> String {
        let cleaned = input.filter { isValidCharacter($0) }
        return String(cleaned.prefix(15))
    }

    static func isValid(_ input: String) -> Bool {
        return input == sanitizeInput(input)
    }
//    static func sanitizeInput(_ input: String) -> String {
//            // Only allow alphanumeric and spaces, limit to 15 characters
//            let allowedCharacters = CharacterSet.alphanumerics.union(.whitespaces)
//            let filtered = input.unicodeScalars.filter { allowedCharacters.contains($0) }
//            return String(String.UnicodeScalarView(filtered)).trimmingCharacters(in: .whitespacesAndNewlines).prefix(15).description
//        }
}

extension Character {
    var isDiacritic: Bool {
        let scalar = self.unicodeScalars.first
        return scalar?.properties.isDiacritic ?? false
    }
}
