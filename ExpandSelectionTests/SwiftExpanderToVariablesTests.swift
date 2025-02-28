//
//  SwiftExpanderToVariablesTests.swift
//  ExpandSelection
//
//  Created by Anton Semenov on 11.11.2024.
//

import XCTest

class SwiftExpanderToVariablesTests: XCTestCase {
    var expander: SwiftExpandToVariables!

    override func setUpWithError() throws {
        try super.setUpWithError()
        expander = SwiftExpandToVariables()
    }

    override func tearDownWithError() throws {
        expander = nil
        try super.tearDownWithError()
    }

    func testEmptySpaceBeforeVarLet() throws {
        let value = expander.expandTo(string: """
//
//  TestExpandAgainstLine.swift
//  ExpandSelection
//
//  Created by Anton Semenov on 11.11.2024.
//

      var value = expander.expandTo(string: "\"test string\"", start: 6, end: 12)

""", start: 124, end: 183)
        XCTAssertNotNil(value, "первый тест, значение не пусто.")
        XCTAssertEqual(value?.start, 112, "первый тест, startIndex")
        XCTAssertEqual(value?.end, 183, "первый тест, endIndex")
    }

    func testEmptySpaceVariantTwoBeforeVarLet() throws {
        let value = expander.expandTo(string: """
let test = .init(
    start: start,
    end: end,
    value: string.substring(with: start...end),
    expander: "SwiftExpandToQuotes"
)
""", start: 11, end: 135)
        XCTAssertNotNil(value?.value, """
let test = .init(
    start: start,
    end: end,
    value: string.substring(with: start...end),
    expander: "SwiftExpandToQuotes"
)
""")
        XCTAssertEqual(value?.start, 0, "первый тест, startIndex")
        XCTAssertEqual(value?.end, 135, "первый тест, endIndex")
    }

    func testEmptyNoSpaceBeforeVarLet() throws {
        let value = expander.expandTo(string: """
//
//  TestExpandAgainstLine.swift
//  ExpandSelection
//
//  Created by Anton Semenov on 11.11.2024.
//

var value = expander.expandTo(string: "\"test string\"", start: 6, end: 12)

""", start: 124, end: 179)
        XCTAssertEqual(value?.value, "var value = expander.expandTo(string: \"\"test string\"\", start: 6, end: 12)")
        XCTAssertEqual(value?.start, 106, "первый тест, startIndex")
        XCTAssertEqual(value?.end, 179, "первый тест, endIndex")
    }

    func testStartLetVarToEnd() throws {
        let value = expander.expandTo(string: """
import Foundation

class SwiftExpander {
    private let utils = SwiftExpanderUtils()
}
""", start: 45, end: 61)
        XCTAssertEqual(value?.value, "private let utils = SwiftExpanderUtils()")
        XCTAssertEqual(value?.start, 45, "первый тест, startIndex")
        XCTAssertEqual(value?.end, 84, "первый тест, endIndex")
    }

    func testToStringOnLine() throws {
        let value = expander.expandTo(string: """
class SwiftExpanderToSymbols {
    init(utils: SwiftExpanderUtils) {
        self.utils = utils
    }
}
""", start: 90, end: 95)
        XCTAssertEqual(value?.value, "self.utils = utils")
        XCTAssertEqual(value?.start, 77, "первый тест, startIndex")
        XCTAssertEqual(value?.end, 95, "первый тест, endIndex")
    }

    func testFunctionParameter() {
        let value = expander.expandTo(string: """
return .init(
    start: start,
    end: end,
    value: string.substring(with: start...end),
    expander: "SwiftExpandToQuotes"
)
""", start: 57, end: 92)
        XCTAssertEqual(value?.value, "value: string.substring(with: start...end)")
        XCTAssertEqual(value?.start, 50)
        XCTAssertEqual(value?.end, 92)
    }

    func testLast() {
        let value = expander.expandTo(string: """
    var introductionTitle: String = "community_lets_get_to_know".localised()
""", start: 4, end: 76)
        XCTAssertNil(nil)
    }
}
