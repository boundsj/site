//
//  FrontMatterUtilsTests.swift
//  AppTests
//
//  Created by Jesse Bounds on 12/22/18.
//

import XCTest
@testable import App

class FrontMatterUtilsTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testProcessFrontMatter() {
        let rawPost1 = """
            # Hello world
            The rest of the post.
            """

        var result = FrontMatterUtils.extract(from: rawPost1)
        XCTAssert(result.title == nil)

        let rawPost2 = """
            ---
            title: Goodbye world
            date: 2018-12-16 08:49:00
            summary: This is an excellent summary of the post!
            ---

            # Hello world
            The rest of the post.
            """

        result = FrontMatterUtils.extract(from: rawPost2)
        XCTAssert(result.title == "Goodbye world")

        var dateComponents = DateComponents()
        dateComponents.year = 2018
        dateComponents.month = 12
        dateComponents.day = 16
        dateComponents.hour = 8
        dateComponents.minute = 49
        let userCalendar = Calendar.current
        let expectedDate = userCalendar.date(from: dateComponents)

        XCTAssert(result.date == expectedDate)

        XCTAssert(result.summary == "This is an excellent summary of the post!")
    }

}
