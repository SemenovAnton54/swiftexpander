//
//  SwiftExpandSemanticUnit.swift
//  ExpandSelectionExtension
//
//  Created by Anton Semenov on 28.09.2024.
//

import Foundation

class SwiftExpandSemanticUnit: SwiftExpanderProtocol {
    private let utils: SwiftExpanderUtils
    private lazy var symbols = "\\(\\[\\{\\)\\]\\}"
    private lazy var breakSymbols = ",:;=&|\n"
    private lazy var lookBackBreakSymbols = breakSymbols + "([{"
    private lazy var lookForwardBreakSymbols = breakSymbols + ")]}"
    private lazy var counterparts = [
      "(":")",
      "{":"}",
      "[":"]",
      ")":"(",
      "}":"{",
      "]":"["
    ]

    init(utils: SwiftExpanderUtils) {
        self.utils = utils
    }

    func expandTo(string: String, start: Int, end: Int) -> ExpanderResult? {
        expandToSemanticUnit(string: string, start: start, end: end)
    }

    private func expandToSemanticUnit(string: String, start: Int, end: Int)  -> ExpanderResult?  {
        var symbolStack = [String]()
        let regex = try! NSRegularExpression(pattern: "([" + symbols + breakSymbols + "])")
        var search = start - 1
        var newStart = 0, newEnd = 0

        while true {
            if search < 0 {
                newStart = search + 1
                break
            }

            let char = Array(string)[search]

            if (regex.firstMatch(in: String(char), range: NSRange(location: 0, length: char.utf16.count)) != nil) {
                if lookBackBreakSymbols.contains(char), symbolStack.count == 0 {
                    newStart = search + 1
                    break
                }

                if symbols.contains(char) {
                    if symbolStack.count > 0, symbolStack[symbolStack.count - 1] == counterparts[String(char)] {
                        _ = symbolStack.popLast()
                    } else {
                        symbolStack.append(String(char))
                    }
                }

                break
            } else {
                search -= 1
            }
        }

        search = end

        while true {
            let char = string.substring(with: search..<search + 1)

            if (regex.firstMatch(in: String(char), range: NSRange(location: 0, length: char.utf16.count)) != nil) {
                if lookForwardBreakSymbols.contains(char), symbolStack.count == 0 {
                    newEnd = search
                    break
                }

                if symbols.contains(char) {
                    if symbolStack.count > 0, symbolStack[symbolStack.count - 1] == counterparts[String(char)] {
                        _ = symbolStack.popLast()
                    } else {
                        symbolStack.append(String(char))
                    }
                }
            }

            if search >= string.count - 1 {
                return nil
            }

            search += 1
        }

        let selectedString = string.substring(with: newStart..<newEnd)

        if let trimValue = utils.trim(string: selectedString) {
            newStart += trimValue.start
            newEnd -= (selectedString.count - trimValue.end)
        }

        if newStart == start, newEnd == end {
            return nil
        }

        if newStart > start || newEnd < end {
            return nil
        }

        return .init(
            start: newStart,
            end: newEnd,
            value: string.substring(with: newStart...newEnd),
            expander: "SwiftExpandSemanticUnit"
        )
    }
}
