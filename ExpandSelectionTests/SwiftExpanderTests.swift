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

}

