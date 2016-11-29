//
//  HickeryUserTest.swift
//  Hickery
//
//  Created by Florian Marcu on 11/28/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

import XCTest
@testable import Hickery

class HickeryUserTest: XCTestCase {
    func testInit() {
        let dict = ["user_id":"1"]
        let user = HickeryUser(jsonDictionary: dict)
        XCTAssertNotNil(user)
    }
}
