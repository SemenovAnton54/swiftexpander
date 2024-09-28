//
//  SwiftExpandToQuotesTests.swift
//  ExpandSelectionTests
//
//  Created by Anton Semenov on 28.09.2024.
//

import XCTest

class SwiftExpandToQuotesTests: XCTestCase {
    var expander: SwiftExpandToQuotes!

    override func setUpWithError() throws {
        try super.setUpWithError()
        expander = SwiftExpandToQuotes()
    }

    override func tearDownWithError() throws {
        expander = nil
        try super.tearDownWithError()
    }

    func testExample() throws {
        var value = expander.expandTo(text: "\"test string\"", start: 6, end: 12)
        XCTAssertNotNil(value, "первый тест, значение не пусто.")
        XCTAssertEqual(value?.start, 1, "первый тест, startIndex")
        XCTAssertEqual(value?.end, 12, "первый тест, endIndex")

        value = expander.expandTo(text: "\"test string\"", start: 1, end: 12)
        XCTAssertNotNil(value, "второй тест, значение не пусто.")
        XCTAssertEqual(value?.start, 0, "второй тест, startIndex")
        XCTAssertEqual(value?.end, 13, "второй тест, endIndex")


        value = expander.expandTo(text: "'test string'", start: 6, end: 12)
        XCTAssertNotNil(value, "третий test, значение не пусто.")
        XCTAssertEqual(value?.start, 1, "третий второй, startIndex")
        XCTAssertEqual(value?.end, 12, "третий второй, endIndex")


        value = expander.expandTo(text: "'test string'", start: 1, end: 12)
        XCTAssertNotNil(value, "четвертый test, значение не пусто.")
        XCTAssertEqual(value?.start, 0, "четвертый второй, startIndex")
        XCTAssertEqual(value?.end, 13, "четвертый второй, endIndex")
    }
}
