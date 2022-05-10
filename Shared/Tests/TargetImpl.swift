//
//  TargetImpl.swift
//  DersuSharedTests
//
//  Created by Danila on 07.05.2022.
//

import XCTest

class TargetImpl: XCTestCase {

    func testWhenDestinationUpdatedExpectedDateUpdated() throws {
        let initDate = Date(timeIntervalSince1970: 0)
        var target = TestObjFactory.getTarget(updated: initDate)

        target.destination = TestObjFactory.locationSanFrancisco

        XCTAssertLessThan(initDate, target.updated, "Date wasn't updated when destination has been changed")
    }
}
