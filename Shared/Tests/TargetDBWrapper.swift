//
//  TargetDBWrapper.swift
//  DersuSharedTests
//
//  Created by Danila on 07.05.2022.
//

import XCTest

class TargetDBWrapper: XCTestCase {

    func testWhenNameUpdatedExpectedCallDelegate() throws {
        let delegate = TestObjFactory.TestTargetStoredDataUpdateDelegate()
        var target = TestObjFactory.getDBWrappedTarget(delegate: delegate)
        let expectation = XCTestExpectation(description: "The delegate didn't called on name change")
        delegate.targetNameUpdated = { expectation.fulfill() }

        target.name = "New name"

        wait(for: [expectation], timeout: 0.5)
    }

    func testWhenIconUpdatedExpectedCallDelegate() throws {
        let delegate = TestObjFactory.TestTargetStoredDataUpdateDelegate()
        var target = TestObjFactory.getDBWrappedTarget(delegate: delegate)
        let expectation = XCTestExpectation(description: "The delegate didn't called on icon change")
        delegate.targetIconUpdated = { expectation.fulfill() }

        target.icon = "New icon"

        wait(for: [expectation], timeout: 0.5)
    }

    func testWhenDestinationUpdatedExpectedCallDelegate() throws {
        let delegate = TestObjFactory.TestTargetStoredDataUpdateDelegate()
        var target = TestObjFactory.getDBWrappedTarget(delegate: delegate)
        let expectation = XCTestExpectation(description: "The delegate didn't called on destination change")
        delegate.targetDestinationUpdated = { expectation.fulfill() }

        target.destination = TestObjFactory.locationVladivostok

        wait(for: [expectation], timeout: 0.5)
    }
}
