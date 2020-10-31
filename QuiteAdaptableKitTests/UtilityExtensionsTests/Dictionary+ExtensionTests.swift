//
//  Dictionary+ExtensionTests.swift
//  QuiteAdaptableKitTests
//
//  Created by Ernest DeFoy on 10/31/20.
//

import XCTest

class Dictionary_ExtensionTests: XCTestCase {
    
    func testConvertedToRawValues() {
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
