//
//  SwiftExpandSemanticUnit.swift
//  ExpandSelectionTests
//
//  Created by Anton Semenov on 28.09.2024.
//

import XCTest

class SwiftExpandSemanticUnitTests: XCTestCase {
    var expander: SwiftExpandSemanticUnit!

    override func setUpWithError() throws {
        try super.setUpWithError()
        expander = SwiftExpandSemanticUnit(utils: SwiftExpanderUtils())
    }

    override func tearDownWithError() throws {
        expander = nil
        try super.tearDownWithError()
    }

    func testExample() throws {
        var value = expander.expandTo(string: "  test(foo.bar['property'].getX(), true)", start: 13, end: 13)
        XCTAssertNotNil(value, "1 тест, значение не пусто.")
        XCTAssertEqual(value?.start, 7, "первый тест, startIndex")
        XCTAssertEqual(value?.end, 33, "первый тест, endIndex")

        value = expander.expandTo(string: "  test(foo.bar['prop,erty'].getX(), true)", start: 13, end: 13)
        XCTAssertNotNil(value, "2 тест, значение не пусто.")
        XCTAssertEqual(value?.start, 7, "2 тест, startIndex")
        XCTAssertEqual(value?.end, 34, "2 тест, endIndex")

        value = expander.expandTo(string: "  test(true, foo.bar['property'].getX())", start: 13, end: 13)
        XCTAssertNotNil(value, "3 тест, значение не пусто.")
        XCTAssertEqual(value?.start, 13, "3 тест, startIndex")
        XCTAssertEqual(value?.end, 39, "3 тест, endIndex")

        value = expander.expandTo(string: """
  test(_getData(function() {
    return "foo";
  }));
""", start: 11, end: 11)
        XCTAssertNotNil(value, "4 тест, значение не пусто.")
        XCTAssertEqual(value?.start, 7, "4 тест, startIndex")
        XCTAssertEqual(value?.end, 51, "4 тест, endIndex")

        value = expander.expandTo(string: """
  test(_getData(function() {
    return "foo";
  }));
""", start: 6, end: 52)
        XCTAssertNotNil(value, "5 тест, значение не пусто.")
        XCTAssertEqual(value?.start, 2, "5 тест, startIndex")
        XCTAssertEqual(value?.end, 52, "5 тест, endIndex")

        value = expander.expandTo(string: "  foo = o.getData(\"bar\");", start: 15, end: 15)
        XCTAssertNotNil(value, "6 тест, значение не пусто.")
        XCTAssertEqual(value?.start, 8, "6 тест, startIndex")
        XCTAssertEqual(value?.end, 24, "6 тест, endIndex")

        value = expander.expandTo(string: "if (foo.get('a') && bar.get('b')) {", start: 6, end: 6)
        XCTAssertNotNil(value, "7 тест, значение не пусто.")
        XCTAssertEqual(value?.start, 4, "7 тест, startIndex")
        XCTAssertEqual(value?.end, 16, "7 тест, endIndex")

        value = expander.expandTo(string: """
if(foo || bar) {
}

var a = "b";
""", start: 0, end: 14)
        XCTAssertNotNil(value, "9 тест, значение не пусто.")
        XCTAssertEqual(value?.start, 0, "9 тест, startIndex")
        XCTAssertEqual(value?.end, 18, "9 тест, endIndex")

        value = expander.expandTo(string: "aaa", start: 1, end: 1)
        XCTAssertNil(value, "10 тест, пусто.")

        value = expander.expandTo(string: """
if() {
  return "foo";
}
""", start: 6, end: 23)
        XCTAssertNil(value, "11 тест, пусто.")

        value = expander.expandTo(string: """
var a = "test1";
var b = "test2";
var c = "test3";
""", start: 17, end: 33)
        XCTAssertNil(value, "12 тест, пусто.")

        value = expander.expandTo(string: """
if(foo || bar) {

}
""", start: 16, end: 16)
        XCTAssertNil(value, "13 тест, пусто.")
    }

    func testFunctionParameter() {
        let value = expander.expandTo(string: """
return .init(
    start: start,
    end: end,
    value: string.substring(with: start...end),
    expander: "SwiftExpandToQuotes"
)
""", start: 73, end: 92)
        XCTAssertEqual(value?.value, "string.substring(with: start...end)")
        XCTAssertEqual(value?.start, 57)
        XCTAssertEqual(value?.end, 92)
    }
}

