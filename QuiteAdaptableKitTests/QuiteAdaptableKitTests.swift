//
//  QuiteAdaptableKitTests.swift
//  QuiteAdaptableKitTests
//
//  Created by Ernest DeFoy on 10/29/20.
//

import XCTest
@testable import QuiteAdaptableKit

class QuiteAdaptableKitTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDictionaryConverted() {
        enum Enumeration: String {
            case a = "a"
            case b = "b"
            case c = "c"
        }
        
        let enumDict: [Enumeration: String] = [
            .a: "a",
            .b: "b",
            .c: "c"
        ]
        
        let expected: [String: String] = [
            "a": "a",
            "b": "b",
            "c": "c"
        ]
        
        XCTAssertEqual(enumDict.convertedToRawValues(), expected)
    }

}
