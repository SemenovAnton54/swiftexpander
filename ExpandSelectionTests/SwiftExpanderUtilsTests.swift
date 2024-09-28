//
//  SwiftExpanderUtils.swift
//  ExpandSelectionTests
//
//  Created by Anton Semenov on 28.09.2024.
//

import XCTest

class SwiftExpanderUtilsTests: XCTestCase {
    var utils: SwiftExpanderUtils!

    override func setUpWithError() throws {
        try super.setUpWithError()
        utils = SwiftExpanderUtils()
    }

    override func tearDownWithError() throws {
        utils = nil
        try super.tearDownWithError()
    }

    func testExample() throws {
        var value = utils.selection_contain_linebreaks(string: "aaa", startIndex: 1, endIndex: 2)
        XCTAssertFalse(value, "первый тест, selection_contain_linebreaks")
        
        value = utils.selection_contain_linebreaks(string: """
                      hello
                      is it me
                      you're looking for
                      """, startIndex: 1, endIndex: 2
        )
        XCTAssertFalse(value, "второй тест, selection_contain_linebreaks")

        var trimValue = utils.trim(string: "  aa  ")
        XCTAssertNotNil(trimValue, "trim первый тест,  значение не пусто.")
        XCTAssertEqual(trimValue?.start, 2, "trim первый тест, startIndex")
        XCTAssertEqual(trimValue?.end, 4, " trim первый тест, endIndex")

        trimValue = utils.trim(string: "  'a a'  ")
        XCTAssertNotNil(trimValue, "trim второй тест,  значение не пусто.")
        XCTAssertEqual(trimValue?.start, 2, "trim второй тест, startIndex")
        XCTAssertEqual(trimValue?.end, 7, " trim второй тест, endIndex")

        trimValue = utils.trim(string: " foo.bar['property'].getX()")
        XCTAssertNotNil(trimValue, "trim четвертый тест,  значение не пусто.")
        XCTAssertEqual(trimValue?.start, 1, "trim четвертый тест, startIndex")
        XCTAssertEqual(trimValue?.end, 27, " trim четвертый тест, endIndex")

        trimValue = utils.trim(string: """
  test(_getData(function() {
   return "foo";
}))
""")
        XCTAssertNotNil(trimValue, "trim пятый тест,  значение не пусто.")
        XCTAssertEqual(trimValue?.start, 2, "trim пятый тест, startIndex")
        XCTAssertEqual(trimValue?.end, 49, " trim пятый тест, endIndex")

    }
}

