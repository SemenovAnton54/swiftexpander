//
//  SwiftExpanderToSymbolsTests.swift
//  ExpandSelectionTests
//
//  Created by Anton Semenov on 28.09.2024.
//

import Foundation
import XCTest

class SwiftExpanderToSymbolsTests: XCTestCase {
    var expander: SwiftExpanderToSymbols!

    override func setUpWithError() throws {
        try super.setUpWithError()
        expander = SwiftExpanderToSymbols(utils: SwiftExpanderUtils())
    }

    override func tearDownWithError() throws {
        expander = nil
        try super.tearDownWithError()
    }

    func testExample() throws {
        var value = expander.expandTo(string: "(foo - bar)", start: 7, end: 10)
        XCTAssertNotNil(value, "1 тест, значение не пусто.")
        XCTAssertEqual(value?.start, 1, "1 тест, startIndex")
        XCTAssertEqual(value?.end, 10, "1 тест, endIndex")

        value = expander.expandTo(string: "(foo - bar)", start: 1, end: 10)
        XCTAssertNotNil(value, "2 тест, значение не пусто.")
        XCTAssertEqual(value?.start, 0, "2 тест, startIndex")
        XCTAssertEqual(value?.end, 11, "2 тест, endIndex")

        value = expander.expandTo(string: "   ", start: 1, end: 2)
        XCTAssertNil(value)

        value = expander.expandTo(string: "(   ", start: 2, end: 2)
        XCTAssertNil(value)

        value = expander.expandTo(string: "console.log(foo.indexOf('bar') > -1);", start: 32, end: 32)
        XCTAssertNotNil(value)
        XCTAssertEqual(value?.start, 12)
        XCTAssertEqual(value?.end, 35)

        value = expander.expandTo(string: "(a['value'])", start: 6, end: 11)
        XCTAssertNotNil(value)
        XCTAssertEqual(value?.start, 1)
        XCTAssertEqual(value?.end, 11)

        value = expander.expandTo(string: """
o = {
  test1: {n: 1, n: 2},
  test2: {n: fn(foo["value"]), n: 4}
}
""", start: 10, end: 61)
        XCTAssertNotNil(value)
        XCTAssertEqual(value?.start, 5)
        XCTAssertEqual(value?.end, 66)

        value = expander.expandTo(string: "{'a(a'+bb+'c)c'}", start: 8, end: 8)
        XCTAssertNotNil(value)
        XCTAssertEqual(value?.start, 1)
        XCTAssertEqual(value?.end, 15)
    }
}
