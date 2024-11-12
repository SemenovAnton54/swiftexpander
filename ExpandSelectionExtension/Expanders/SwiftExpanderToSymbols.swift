//
//  SwiftExpandeToSymbols.swift
//  ExpandSelection
//
//  Created by Anton Semenov on 28.09.2024.
//

import Foundation

class SwiftExpanderToSymbols {
    private let utils: SwiftExpanderUtils
    private lazy var openingSymbols = "\\(\\[\\{"
    private lazy var closingSymbols = "\\)\\]\\}"
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
        expandToSymbols(string: string, start: start, end: end)
    }

    private func expandToSymbols(string: String, start: Int, end: Int)  -> ExpanderResult?  {
        guard let symbolsRegex = try? NSRegularExpression(pattern: "[" + openingSymbols + closingSymbols + "]"),
              let quotesRegex = try? NSRegularExpression(pattern: "(['\"])(?:\\1|.*?\\1)") else {
            return nil
        }

        var quotesBlacklist = [Int: Bool]()

        let results = quotesRegex.matches(in: string, range: NSRange(string.startIndex..., in: string))

        results.forEach {
            let quotesStart = $0.range.location
            let quotesEnd = $0.range.location + $0.range.length

            var i = 0;
            while true {
                quotesBlacklist[quotesStart + i] = true
                i += 1
                if (quotesStart + i >= quotesEnd) {
                    break;
                }
            }
        }

        let selectionString = string.substring(with: start..<end)
        var selectionQuotes: [String] = symbolsRegex
            .matches(in: selectionString, range: NSRange(selectionString.startIndex..., in: selectionString))
            .compactMap {
                selectionString.substring(with: $0.range.location..<$0.range.location + $0.range.length)
            }

        var backwardSymbolsStack = [String]()
        var forwardSymbolsStack = [String]()

        if !selectionQuotes.isEmpty {
            var insect = 0

            while true {
                let item = selectionQuotes[insect]

                if let counterpart = counterparts[item], selectionQuotes.contains(counterpart) {
                    selectionQuotes.remove(at: insect)
                    selectionQuotes.removeAll(where: { $0 == counterpart })
                } else {
                    insect += 1
                }

                if insect >= selectionQuotes.count {
                    break
                }
            }

            selectionQuotes.forEach {
                if openingSymbols.contains($0) {
                    forwardSymbolsStack.append($0)
                } else if closingSymbols.contains($0) {
                    backwardSymbolsStack.append($0)
                }
            }
        }

        var search = start - 1
        var symbolsStart = 0
        var symbol: String = ""

        while true {
            if search < 0 {
                return nil
            }

            if quotesBlacklist[search] == true {
                search -= 1
                continue
            }

            let character = string.substring(with: search..<(search + 1))
            let result = (openingSymbols + closingSymbols).contains(character)

            if result {
                symbol = character
                if openingSymbols.contains(character), backwardSymbolsStack.isEmpty {
                    symbolsStart = search + 1
                    break
                }

                if !backwardSymbolsStack.isEmpty, backwardSymbolsStack.last == counterparts[character] {
                    _ = backwardSymbolsStack.popLast()
                } else {
                    backwardSymbolsStack.append(character)
                }
            }

            search -= 1
        }

        let symbols: [String] = [symbol, counterparts[symbol]].compactMap { $0 }
        forwardSymbolsStack.append(symbol)

        search = end

        var symbolsEnd = 0
        while true {
            if quotesBlacklist[search] != nil {
                search += 1
                continue
            }

            let character = string.substring(with: search..<search+1)
            if symbols.contains(character) {
                symbol = character
                if forwardSymbolsStack.last == counterparts[symbol] {
                    _ = forwardSymbolsStack.popLast()
                } else {
                    forwardSymbolsStack.append(symbol)
                }

                if forwardSymbolsStack.isEmpty {
                    symbolsEnd = search
                    break
                }
            }

            if search == string.count {
                return nil
            }

            search += 1
        }

        if start == symbolsStart, end == symbolsEnd {
            return .init(
                start: symbolsStart - 1,
                end: symbolsEnd + 1,
                value: string.substring(with: symbolsStart...symbolsEnd),
                expander: "SwiftExpanderToSymbols"
            )

        } else {
            return .init(
                start: symbolsStart,
                end: symbolsEnd,
                value: string.substring(with: symbolsStart...symbolsEnd),
                expander: "SwiftExpanderToSymbols"
            )
        }
    }
}

