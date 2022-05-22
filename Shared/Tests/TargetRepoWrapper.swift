//
//  TargetDBWrapper.swift
//  DersuSharedTests
//
//  Created by Danila on 07.05.2022.
//

import XCTest

class TargetRepoWrapper: XCTestCase {

    func testWhenNameUpdatedExpectedCallDelegate() throws {
        let delegate = TestObjFactory.TestTargetRepoUpdateDelegate()
        let target = TestObjFactory.getRepoWrappedTarget(delegate: delegate)
        let expectation = XCTestExpectation(description: "The delegate didn't called on name change")
        delegate.targetNameUpdate = { expectation.fulfill() }

        target.name = "New name"

        wait(for: [expectation], timeout: 0.5)
    }

    func testWhenIconUpdatedExpectedCallDelegate() throws {
        let delegate = TestObjFactory.TestTargetRepoUpdateDelegate()
        let target = TestObjFactory.getRepoWrappedTarget(delegate: delegate)
        let expectation = XCTestExpectation(description: "The delegate didn't called on icon change")
        delegate.targetIconUpdate = { expectation.fulfill() }

        target.icon = "New icon"

        wait(for: [expectation], timeout: 0.5)
    }

    func testWhenDestinationUpdatedExpectedCallDelegate() throws {
        let delegate = TestObjFactory.TestTargetRepoUpdateDelegate()
        let target = TestObjFactory.getRepoWrappedTarget(delegate: delegate)
        let expectation = XCTestExpectation(description: "The delegate didn't called on destination change")
        delegate.targetDestinationUpdate = { expectation.fulfill() }

        target.destination = TestObjFactory.locationVladivostok

        wait(for: [expectation], timeout: 0.5)
    }

    func testWhenRepoNameUpdatedExpectedInitialDelegateNameUpdated() throws {
        let newName = "newName"
        let initTarget = TestObjFactory.getTarget(name: "oldName")
        let targetDelegate: DRTargetRepoUpdatedDelegate =
            TestObjFactory.getRepoWrappedTarget(initTarget: initTarget)

        targetDelegate.targetUpdated(name: newName)

        XCTAssertEqual(initTarget.name, newName, "RepoUpdatedDelegate doesn't update name")
    }

    func testWhenRepoIconUpdatedExpectedInitialDelegateIconUpdated() throws {
        let newIcon = "newIcon"
        let initTarget = TestObjFactory.getTarget(icon: "oldIcon")
        let targetDelegate: DRTargetRepoUpdatedDelegate =
            TestObjFactory.getRepoWrappedTarget(initTarget: initTarget)

        targetDelegate.targetUpdated(icon: newIcon)

        XCTAssertEqual(initTarget.icon, newIcon, "RepoUpdatedDelegate doesn't update icon")
    }

    func testWhenRepoDestinationUpdatedExpectedInitialDelegateDestinationUpdated() throws {
        let newDestination = TestObjFactory.locationSanFrancisco
        let compass = TestObjFactory.getCompassToVladivostok()
        let initTarget = TestObjFactory.getTarget(compass: compass)
        let targetDelegate: DRTargetRepoUpdatedDelegate =
            TestObjFactory.getRepoWrappedTarget(initTarget: initTarget)

        targetDelegate.targetUpdated(destination: newDestination)

        XCTAssertEqual(
            initTarget.destination.coordinate.latitude,
            newDestination.coordinate.latitude,
            "RepoUpdatedDelegate doesn't update destination"
        )
    }
}
