//
//  SwiftExpandToQuotes.swift
//  ExpandSelectionExtension
//
//  Created by Anton Semenov on 28.09.2024.
//

import Foundation

class SwiftExpandToVariables: SwiftExpanderProtocol {
    func expandTo(string: String, start: Int, end: Int) -> ExpanderResult? {
        expandToVariables(string: string, start: start, end: end)
    }

    private func expandToVariables(string: String, start: Int, end: Int) -> ExpanderResult? {
        let endOfLine = Character("\n")

        var newStart = start - 1

        guard string.substring(with: newStart...start).first != "(" || string.substring(with: end...end+1).first != ")" else {
            return nil
        }
        
        while newStart >= 0 {
            defer {
                newStart -= 1
            }

            guard string.substring(with: newStart...newStart + 1).first != endOfLine else {
                break
            }

            let subString = string.substring(with: newStart...newStart+3)

            guard subString == "let" || subString == "var" else {
                continue
            }

            return .init(
                start: newStart,
                end: end,
                value: string.substring(with: newStart...end),
                expander: "SwiftExpandToVariables"
            )
        }

        var newEnd = end

        while newEnd < string.count {
            defer {
                newEnd += 1
            }

            guard string.substring(with: newEnd...newEnd+1).first == endOfLine
                    || string.substring(with: newEnd...newEnd+1).first == ","
                    || string.substring(with: newEnd...newEnd+1).first == ")"
            else {
                continue
            }

            guard newEnd != end else {
                break
            }

            return .init(
                start: start,
                end: newEnd,
                value: string.substring(with: start...newEnd),
                expander: "SwiftExpandToVariables"
            )
        }

        newStart = start - 1

        var lastNoSpaceSymbolAgo = 0

        while newStart > 0 {
            defer {
                newStart -= 1
            }

            guard string.substring(with: newStart...(newStart + 1)).first == endOfLine else {
                guard string.substring(with: newStart...(newStart + 1)) == " " else {
                    lastNoSpaceSymbolAgo = 0
                    continue
                }

                lastNoSpaceSymbolAgo = lastNoSpaceSymbolAgo + 1

                continue
            }

            guard (newStart + lastNoSpaceSymbolAgo + 1) != start else {
                break
            }

            return .init(
                start: newStart + lastNoSpaceSymbolAgo + 1,
                end: end,
                value: string.substring(with: newStart + lastNoSpaceSymbolAgo + 1...end),
                expander: "SwiftExpandToVariables"
            )
        }

        return nil
    }
}
