//
//  SourceEditorCommand.swift
//  ExpandSelectionExtension
//
//  Created by Anton Semenov on 28.09.2024.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    let expander = SwiftExpander()

    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        defer {
            completionHandler(nil)
        }

        guard let firstSelection = invocation.buffer.selections.firstObject as? XCSourceTextRange else {
            return
        }

        let string = invocation.buffer.lines.componentsJoined(by: "")
        let linesCharactersCount = invocation.buffer.lines.compactMap { ($0 as? NSString)?.length }

        let charactersOnPreviousLinesBeforeStartLine = linesCharactersCount.prefix(firstSelection.start.line).reduce(0, +)
        let charactersOnPreviousLinesBeforeEndLine = linesCharactersCount.prefix(firstSelection.end.line).reduce(0, +)

        let start = charactersOnPreviousLinesBeforeStartLine + firstSelection.start.column
        let end = charactersOnPreviousLinesBeforeEndLine + firstSelection.end.column

        guard let result = expander.expand(string: string, start: start, end: end) else {
            return
        }

        let range = XCSourceTextRange()

        range.start = startSelection(linesCharactersCount: linesCharactersCount, start: result.start)
        range.end = endSelection(linesCharactersCount: linesCharactersCount, end: result.end)

        invocation.buffer.selections.setArray([range])
    }

    private func startSelection(linesCharactersCount: [Int], start: Int) -> XCSourceTextPosition {
        var line = 0, column = 0

        for count in linesCharactersCount {
            let sum = linesCharactersCount.prefix(line).reduce(0, +)

            guard (sum + count) < start else {
                column = start - sum
                break
            }

            line += 1
        }

        return XCSourceTextPosition(
            line: line,
            column: column
        )
    }

    private func endSelection(linesCharactersCount: [Int], end: Int) -> XCSourceTextPosition {
        var line = 0, column = 0

        for count in linesCharactersCount {
            let sum = linesCharactersCount.prefix(line).reduce(0, +)

            guard (sum + count) < end else {
                column = end - sum
                break
            }

            line += 1
        }

        return XCSourceTextPosition(
            line: line,
            column: column
        )
    }
}
