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
        XCTAssertEqual(value?.end, 85, "первый тест, endIndex")
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
        XCTAssertEqual(value?.end, 94, "первый тест, endIndex")
    }
}
