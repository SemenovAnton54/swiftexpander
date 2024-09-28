//
//  SwiftExpanderToRegexSet.swift
//  ExpandSelectionExtension
//
//  Created by Anton Semenov on 28.09.2024.
//

import Foundation

class SwiftExpanderToRegexSet {
    func expandToRegexRule(string: String, start: Int, end: Int, regex: NSRegularExpression) -> (start: Int, end: Int)? {
        if start != end {
            let selection = string.substring(with: start..<end)
            let results = regex.matches(in: selection, range: NSRange(string.startIndex..., in: selection))

            if results.count != selection.count {
                return nil
            }
        }

        var search = start - 1
        var newStart = 0, newEnd = 0

        while true {
            if search < 0 {
                newStart = search + 1
                break
            }

            let char = string.substring(with: search..<search + 1)
            if regex.firstMatch(in: char, range: NSRange(char.startIndex..., in: char)) == nil {
                newStart = search + 1
                break
            } else {
                search -= 1
            }
        }

        search = end
        while true {
            if search > string.count {
                newEnd = search
                break
            }

            let char = string.substring(with: search..<search+1)
            if regex.firstMatch(in: char, range: NSRange(char.startIndex..., in: char)) == nil {
                newEnd = search
                break
            } else {
                search += 1
            }
        }

        if start == newStart && end == newEnd {
            return nil
        } else {
            return (start: newStart, end: newEnd)
        }
    }
}

