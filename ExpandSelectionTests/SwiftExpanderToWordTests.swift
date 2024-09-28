//
//  SwiftExpanderToRegexSetTests.swift
//  ExpandSelectionTests
//
//  Created by Anton Semenov on 28.09.2024.
//

import XCTest

class SwiftExpanderToWordTests: XCTestCase {
    var expander: SwiftExpanderToWord!

    override func setUpWithError() throws {
        try super.setUpWithError()
        expander = SwiftExpanderToWord()
    }

    override func tearDownWithError() throws {
        expander = nil
        try super.tearDownWithError()
    }

    func testExample() throws {
        var result = expander.expandToWord(string: "12312 qweweweEWEGGWEG  eqweq ", start: 7, end: 8)
        XCTAssertNotNil(result, "1 тест, значение не пусто.")
        XCTAssertEqual(result?.start, 6, "1 тест, startIndex")
        XCTAssertEqual(result?.end, 21, "1 тест, endIndex")

        result = expander.expandToWord(string: "12312 qweweweEWEGGWEG  eqweq ", start: 0, end: 0)
        XCTAssertNotNil(result, "2 тест, значение не пусто.")
        XCTAssertEqual(result?.start, 0, "2 тест, startIndex")
        XCTAssertEqual(result?.end, 5, "2 тест, endIndex")
    }
}
