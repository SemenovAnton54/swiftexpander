//
//  SwiftExpandTests.swift
//  ExpandSelectionTests
//
//  Created by Anton Semenov on 28.09.2024.
//

import XCTest

class SwiftExpanderTests: XCTestCase {
    var expander: SwiftExpander!

    override func setUpWithError() throws {
        try super.setUpWithError()
        expander = SwiftExpander()
    }

    override func tearDownWithError() throws {
        expander = nil
        try super.tearDownWithError()
    }

    func test_expand_parameter_to_left_to_point() {
        let value = expander.expand(string: """
return .init(
    start: start,
    end: newEnd,
    value: string.substring(with: start...newEnd),
    expander: "SwiftExpandToVariables"
)
""", start: 76, end: 98)

        XCTAssertEqual(value?.value, "string.substring(with: start...newEnd)")
//        XCTAssertEqual(value?.start, 67, "первый тест, startIndex")
        XCTAssertEqual(value?.start, 60, "первый тест, startIndex")
        XCTAssertEqual(value?.end, 98, "первый тест, endIndex")
    }

    func test_expand_parameter() {
        let value = expander.expand(string: """
return .init(
    start: start,
    end: newEnd,
    value: string.substring(with: start...newEnd),
    expander: "SwiftExpandToVariables"
)
""", start: 76, end: 98)

        XCTAssertNotNil(value, "первый тест, значение не пусто.")
        XCTAssertEqual(value?.start, 60, "первый тест, startIndex")
        XCTAssertEqual(value?.end, 98, "первый тест, endIndex")
    }
}

