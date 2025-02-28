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
        let excludeSymbols: [Character] = ["\n", " "]

        var newStart = start - 1
        var firstLeftSymbol: Character?
        var firstRightSymbol: Character?

        while newStart >= 0 {
            defer {
                newStart -= 1
            }

            guard let symbol = string.substring(with: newStart...start).first else {
                break
            }

            guard !excludeSymbols.contains(symbol) else {
                continue
            }

            firstLeftSymbol = symbol
            break
        }

        var newEnd = end

        while newEnd < string.count {
            defer {
                newEnd += 1
            }

            guard let symbol = string.substring(with: newEnd...newEnd+1).first else {
                break
            }

            guard !excludeSymbols.contains(symbol) else {
                continue
            }

            firstRightSymbol = symbol
            break
        }


        guard firstLeftSymbol != "(" || firstRightSymbol != ")" else {
            return nil
        }


        newStart = start - 1
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

        newEnd = end
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
                value: string.substring(with: start...newEnd+1),
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
