//
//  SwiftExpandToSubword.swift
//  ExpandSelectionExtension
//
//  Created by Anton Semenov on 28.09.2024.
//

import Foundation

//TODO
class SwiftExpanderToSubword {
    func expand_to_subword(string: String, start: Int, end: Int) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: _is_inside_upper(string: string, start: start, end: end) ? "[a-z]" : "[A-Z]") else {
            return false
        }

        let substring = string.substring(with: start..<end)

        guard regex.firstMatch(in: substring, range: NSRange(location: 0, length: substring.count)) != nil else {
            return false
        }

        return true
    }

    func _is_inside_upper(string: String, start: Int, end: Int) -> Bool {
        let upperCase = CharacterSet.uppercaseLetters
        let lowerCase = CharacterSet.lowercaseLetters

        if start != end {
            return string.substring(with: start..<end).unicodeScalars.first(where: { !upperCase.contains($0) }) != nil
        }

        let newStart = max(0, start - 2)
        let newEnd = min(end + 2, string.count - 1)
        let sub_str = string.substring(with: newStart..<newEnd)
        let contains_upper = sub_str.unicodeScalars.first(where: { !upperCase.contains($0) }) != nil
        let contains_lower = sub_str.unicodeScalars.first(where: { !lowerCase.contains($0) }) != nil
        return contains_upper && !contains_lower
    }
}

