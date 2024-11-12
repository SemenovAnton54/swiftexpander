//
//  String+Extensions.swift
//  ExpandSelectionExtension
//
//  Created by Anton Semenov on 28.09.2024.
//

import Foundation

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        guard r.lowerBound < r.upperBound else { return "" }
        let startIndex = index(from: max(r.lowerBound, 0))
        let endIndex = index(from: min(r.upperBound, count))
    
        return String(self[startIndex..<endIndex])
    }

    func substring(with r: ClosedRange<Int>) -> String {
        guard r.lowerBound < r.upperBound else { return "" }
        let startIndex = index(from: max(r.lowerBound, 0))
        let endIndex = index(from: min(r.upperBound, count))
    
        return String(self[startIndex..<endIndex])
    }

    subscript (bounds: CountableClosedRange<Int>) -> String {
        guard bounds.lowerBound < bounds.upperBound else { return "" }
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }

    subscript (bounds: CountableRange<Int>) -> String {
        guard bounds.lowerBound < bounds.upperBound else { return "" }
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}

