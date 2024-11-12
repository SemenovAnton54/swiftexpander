//
//  SwiftExpanderToWord.swift
//  ExpandSelectionExtension
//
//  Created by Anton Semenov on 28.09.2024.
//

import Foundation

class SwiftExpanderToWord {
    let expander = SwiftExpanderToRegexSet()
    
    func expandToWord(string: String, start: Int, end: Int) -> ExpanderResult? {
        guard let regex = try? NSRegularExpression(pattern: "[\\w$]") else {
            return nil
        }

        return expander.expandToRegexRule(string: string, start: start, end: end, regex: regex)
    }
}
