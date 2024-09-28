//
//  SwiftExpanderUtils.swift
//  ExpandSelectionExtension
//
//  Created by Anton Semenov on 28.09.2024.
//

import Foundation

class SwiftExpanderUtils {
    let trimPatternStart = "^[ \t\n]*"
    let trimPatternEnd = "[ \t\n]*$"
    
    func selection_contain_linebreaks(string: String, startIndex: Int, endIndex: Int) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: "\n") else {
            return false
        }

        let substring = string.substring(with: startIndex..<endIndex)

        guard regex.firstMatch(in: substring, range: NSRange(location: 0, length: substring.count)) != nil else {
            return false
        }

        return true
    }

    func trim(string: String) -> (start: Int, end: Int)? {
        guard let regexStart = try? NSRegularExpression(pattern: trimPatternStart),
               let regexEnd = try? NSRegularExpression(pattern: trimPatternEnd),
               let firstStart = regexStart.firstMatch(in: string, range: NSRange(string.startIndex..., in: string)),
               let firstEnd = regexEnd.firstMatch(in: string, range: NSRange(string.startIndex..., in: string)) else {
            return nil
        }

        let start = firstStart.range.length
        let end = firstEnd.range.location

        return (start: start, end: end)
    }

    func get_line(string: String, startIndex: Int, endIndex: Int) -> (start: Int, end: Int)? {
        guard let regex = try? NSRegularExpression(pattern: "\n") else {
            return nil
        }

        var searchIndex = startIndex - 1
        var newStartIndex: Int = 0

        while true {
            if searchIndex < 0 {
                newStartIndex = searchIndex + 1
                break
            }

            let char = Array(string)[searchIndex]

            if (regex.firstMatch(in: String(char), range: NSRange(location: 0, length: char.utf16.count)) != nil) {
                newStartIndex = searchIndex + 1
                break
            } else {
                searchIndex -= 1
            }
        }

        searchIndex = endIndex
        var newEndIndex: Int = 0
        while true {
            if searchIndex > (string.count - 1) {
                newEndIndex = searchIndex
                break
            }

            let char = Array(string)[searchIndex]
            if (regex.firstMatch(in: String(char), range: NSRange(location: 0, length: char.utf16.count)) != nil) {
                newEndIndex = searchIndex
                break
            } else {
                searchIndex += 1
            }
        }

        return (start: newStartIndex, end: newEndIndex)
    }
}
