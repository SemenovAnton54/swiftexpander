//
//  SwiftExpandToQuotes.swift
//  ExpandSelectionExtension
//
//  Created by Anton Semenov on 28.09.2024.
//

import Foundation

class SwiftExpandToQuotes: SwiftExpanderProtocol {
    private let pattern = "(['\"])(?:\\.|.)*?\\1"

    func expandTo(text: String, start: Int, end: Int) -> (start: Int, end: Int)? {
        expandToQuotes(string: text, start: start, end: end)
    }

    private func expandToQuotes(string: String, start: Int, end: Int) -> (start: Int, end: Int)? {
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return nil
        }

        let results = regex.matches(in: string, range: NSRange(string.startIndex..., in: string))

        var repArrayIndex: Int = 0

        while repArrayIndex < results.count {
            defer {
                repArrayIndex = repArrayIndex + 1
            }

            let quotesStart = results[repArrayIndex].range.location
            let quotesEnd = results[repArrayIndex].range.location + results[repArrayIndex].range.length

            guard quotesEnd >= start else {
                continue
            }

            guard quotesStart <= end else {
                return nil
            }

            if quotesStart == start, quotesEnd == end {
                return nil
            }

            let quotesContentStart = quotesStart + 1
            let quotesContentEnd = quotesEnd - 1

            guard start != quotesContentStart || end != quotesContentEnd else {
                return (quotesStart, quotesEnd)
            }

            guard start <= quotesStart || end >= quotesEnd else {
                return (quotesContentStart, quotesContentEnd)
            }

            continue
        }

        return nil
    }
}
