//
//  TargetRestrictorWrapper.swift
//  DersuSharedTests
//
//  Created by Danila on 07.05.2022.
//

import XCTest

class TargetRestrictorWrapper: XCTestCase {

    // MARK: - Call update

    func testWhenNameUpdatedExpectedCallDelegate() throws {
        let delegate = TestObjFactory.TestTargetRestrictorDelegate()
        var target = TestObjFactory.getRestrictedWrappedTarget(delegate: delegate)
        let expectation = XCTestExpectation(description: "The delegate didn't called on name change")
        delegate.restrictedTargetChangedName = { expectation.fulfill() }

        target.name = "New name"

        wait(for: [expectation], timeout: 0.5)
    }

    func testWhenIconUpdatedExpectedCallDelegate() throws {
        let delegate = TestObjFactory.TestTargetRestrictorDelegate()
        var target = TestObjFactory.getRestrictedWrappedTarget(delegate: delegate)
        let expectation = XCTestExpectation(description: "The delegate didn't called on icon change")
        delegate.restrictedTargetChangedIcon = { expectation.fulfill() }

        target.icon = "New icon"

        wait(for: [expectation], timeout: 0.5)
    }

    func testWhenDestinationUpdatedExpectedCallDelegate() throws {
        let delegate = TestObjFactory.TestTargetRestrictorDelegate()
        var target = TestObjFactory.getRestrictedWrappedTarget(delegate: delegate)
        let expectation = XCTestExpectation(description: "The delegate didn't called on destination change")
        delegate.restrictedTargetChangedDestination = { expectation.fulfill() }

        target.destination = TestObjFactory.locationVladivostok

        wait(for: [expectation], timeout: 0.5)
    }

    // MARK: Restriction

    func testWhenDelegateProhibitsChangeNameExpectedNameNotChange() throws {
        let testName = "Test"

        let delegate = TestObjFactory.TestTargetRestrictorDelegate()
        delegate.restrictedTargetCanChangeName = { false }

        let initTarget = TestObjFactory.getTarget(name: testName)
        var target = TestObjFactory.getRestrictedWrappedTarget(initTarget: initTarget, delegate: delegate)

        target.name = "New name"

        XCTAssertEqual(target.name, testName, "Name was updated when the delegate prohibits it")
    }

    func testWhenDelegateAllowsChangeNameExpectedNameChange() throws {
        let newName = "New name"

        let delegate = TestObjFactory.TestTargetRestrictorDelegate()
        delegate.restrictedTargetCanChangeName = { true }

        let initTarget = TestObjFactory.getTarget(name: "Test")
        var target = TestObjFactory.getRestrictedWrappedTarget(initTarget: initTarget, delegate: delegate)

        target.name = newName

        XCTAssertEqual(target.name, newName, "Name wasn't updated when the delegate prohibits it")
    }

    func testWhenDelegateProhibitsChangeNameExpectedIsCanChangeNameFalse() throws {
        let delegate = TestObjFactory.TestTargetRestrictorDelegate()
        delegate.restrictedTargetCanChangeName = { false }

        let target = TestObjFactory.getRestrictedWrappedTarget(delegate: delegate)

        XCTAssertFalse(target.isCanChangeName, "isCanChangeName doesn't follow the delegate")
    }

    func testWhenDelegateAllowsChangeNameExpectedIsCanChangeNameTrue() throws {
        let delegate = TestObjFactory.TestTargetRestrictorDelegate()
        delegate.restrictedTargetCanChangeName = { true }

        let target = TestObjFactory.getRestrictedWrappedTarget(delegate: delegate)

        XCTAssertTrue(target.isCanChangeName, "isCanChangeName doesn't follow the delegate")
    }

    func testWhenDelegateProhibitsChangeIconExpectedIconNotChange() throws {
        let iconName = "Test"

        let delegate = TestObjFactory.TestTargetRestrictorDelegate()
        delegate.restrictedTargetCanChangeIcon = { false }

        let initTarget = TestObjFactory.getTarget(icon: iconName)
        var target = TestObjFactory.getRestrictedWrappedTarget(initTarget: initTarget, delegate: delegate)

        target.icon = "New name"

        XCTAssertEqual(target.icon, iconName, "Icon was updated when the delegate prohibits it")
    }

    func testWhenDelegateAllowsChangeIconExpectedIconChange() throws {
        let newIcon = "New icon"

        let delegate = TestObjFactory.TestTargetRestrictorDelegate()
        delegate.restrictedTargetCanChangeIcon = { true }

        let initTarget = TestObjFactory.getTarget(icon: "Test")
        var target = TestObjFactory.getRestrictedWrappedTarget(initTarget: initTarget, delegate: delegate)

        target.icon = newIcon

        XCTAssertEqual(target.icon, newIcon, "Icon wasn't updated when the delegate prohibits it")
    }

    func testWhenDelegateProhibitsChangeIconExpectedIsCanChangeIconFalse() throws {
        let delegate = TestObjFactory.TestTargetRestrictorDelegate()
        delegate.restrictedTargetCanChangeIcon = { false }

        let target = TestObjFactory.getRestrictedWrappedTarget(delegate: delegate)

        XCTAssertFalse(target.isCanChangeIcon, "isCanChangeIcon doesn't follow the delegate")
    }

    func testWhenDelegateAllowsChangeIconExpectedIsCanChangeIconTrue() throws {
        let delegate = TestObjFactory.TestTargetRestrictorDelegate()
        delegate.restrictedTargetCanChangeIcon = { true }

        let target = TestObjFactory.getRestrictedWrappedTarget(delegate: delegate)

        XCTAssertTrue(target.isCanChangeIcon, "isCanChangeIcon doesn't follow the delegate")
    }

    func testWhenDelegateProhibitsChangeDestinationExpectedDestinationNotChange() throws {
        let destination = TestObjFactory.locationVladivostok

        let delegate = TestObjFactory.TestTargetRestrictorDelegate()
        delegate.restrictedTargetCanChangeDestination = { false }

        let initTarget = TestObjFactory.getTarget(compass: TestObjFactory.getCompassToVladivostok())
        var target = TestObjFactory.getRestrictedWrappedTarget(initTarget: initTarget, delegate: delegate)

        target.destination = TestObjFactory.locationSanFrancisco

        XCTAssertEqual(
            target.destination.coordinate.latitude,
            destination.coordinate.latitude,
            "Destination was updated when the delegate prohibits it"
        )
    }

    func testWhenDelegateAllowsChangeDestinationExpectedDestinationChange() throws {
        let newDestination = TestObjFactory.locationSanFrancisco

        let delegate = TestObjFactory.TestTargetRestrictorDelegate()
        delegate.restrictedTargetCanChangeDestination = { true }

        let initTarget = TestObjFactory.getTarget(compass: TestObjFactory.getCompassToVladivostok())
        var target = TestObjFactory.getRestrictedWrappedTarget(initTarget: initTarget, delegate: delegate)

        target.destination = newDestination

        XCTAssertEqual(
            target.destination.coordinate.latitude,
            newDestination.coordinate.latitude,
            "Destination wasn't updated when the delegate prohibits it"
        )
    }

    func testWhenDelegateProhibitsChangeDestinationExpectedIsCanChangeDestinationFalse() throws {
        let delegate = TestObjFactory.TestTargetRestrictorDelegate()
        delegate.restrictedTargetCanChangeDestination = { false }

        let target = TestObjFactory.getRestrictedWrappedTarget(delegate: delegate)

        XCTAssertFalse(target.isCanChangeDestination, "isCanChangeDestination doesn't follow the delegate")
    }

    func testWhenDelegateAllowsChangeDestinationExpectedIsCanChangeDestinationTrue() throws {
        let delegate = TestObjFactory.TestTargetRestrictorDelegate()
        delegate.restrictedTargetCanChangeDestination = { true }

        let target = TestObjFactory.getRestrictedWrappedTarget(delegate: delegate)

        XCTAssertTrue(target.isCanChangeDestination, "isCanChangeDestination doesn't follow the delegate")
    }
}
