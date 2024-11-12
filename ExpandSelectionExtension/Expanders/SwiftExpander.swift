//
//  SwiftExpander.swift
//  ExpandSelectionExtension
//
//  Created by Anton Semenov on 28.09.2024.
//

import Foundation

class SwiftExpander {
    private let utils = SwiftExpanderUtils()
    private let swiftExpandToQuotes = SwiftExpandToQuotes()
    private let swiftExpandToWord = SwiftExpanderToWord()
    private let swiftExpandToVariables = SwiftExpandToVariables()

    private lazy var swiftExpandToSemanticUnit = SwiftExpandSemanticUnit(utils: utils)
    private lazy var swiftExpandToSymbols = SwiftExpanderToSymbols(utils: utils)

    func expand(string: String, start: Int, end: Int) -> ExpanderResult? {
        let isSelectionInString = swiftExpandToQuotes.expandTo(string: string, start: start, end: end)

        if let isSelectionInString, isSelectionInString.start == start, isSelectionInString.end == end {
            if let result = expandAgainsString(
                string: string,
                start: start - isSelectionInString.start,
                end: end - isSelectionInString.start
            ) {
                let start = isSelectionInString.start + result.start
                let end = isSelectionInString.end + result.end

                return .init(
                    start: end,
                    end: end,
                    value: string.substring(with: start...end),
                    expander: "SwiftExpander"
                )
            }
        } else if let isSelectionInString {
            return isSelectionInString
        }

        if !utils.selection_contain_linebreaks(string: string, startIndex: start, endIndex: end) {
            if let line = utils.get_line(string: string, startIndex: start, endIndex: end) {
                let line_string = string.substring(with: line.start..<line.end)
                if let line_result = expandAgainsLine(string: line_string, start: start - line.start, end: end - line.start) {
                    let start = line_result.start + line.start
                    let end = line_result.end + line.start

                    return .init(
                        start: start,
                        end: end,
                        value: string.substring(with: start...end),
                        expander: "SwiftExpandToQuotes"
                    )
                }
            }
        }

        if let result = swiftExpandToSemanticUnit.expandTo(string: string, start: start, end: end) {
            return result
        }

        if let result = swiftExpandToVariables.expandTo(string: string, start: start, end: end) {
            return result
        }

        if let result = swiftExpandToSymbols.expandTo(string: string, start: start, end: end) {
            return result
        }

        return .init(
            start: start,
            end: end,
            value: string.substring(with: start...end),
            expander: "SwiftExpandToQuotes"
        )
    }

    func expandAgainsString(string: String, start: Int, end: Int) -> ExpanderResult? {
        if let result = swiftExpandToSemanticUnit.expandTo(string: string, start: start, end: end) {
            return result
        }

        if let result = swiftExpandToSymbols.expandTo(string: string, start: start, end: end) {
            return result
        }

        return nil
    }

    func expandAgainsLine(string: String, start: Int, end: Int) -> ExpanderResult? {
        if let result = swiftExpandToWord.expandToWord(string: string, start: start, end: end) {
            return result
        }

        if let result = swiftExpandToQuotes.expandTo(string: string, start: start, end: end) {
            return result
        }

        if let result = swiftExpandToSemanticUnit.expandTo(string: string, start: start, end: end) {
            return result
        }

        if let result = swiftExpandToSymbols.expandTo(string: string, start: start, end: end) {
            return result
        }

        return nil
    }
}
