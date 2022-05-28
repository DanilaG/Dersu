//
//  TargetBagRepoWrapperTest.swift
//  DersuSharedTests
//
//  Created by Danila on 28.05.2022.
//

import XCTest

class TargetBagRepoWrapperTest: XCTestCase {

    // MARK: - Influence on initial TargetBag
    func testWhenCurrentTargetUpdatedExpectedInitialBagChangeIt() throws {
        let target = TestObjFactory.getTarget()
        var initialBag = TestObjFactory.getTargetBag()
        let bag = TestObjFactory.getTargetBagRepoWrapper(initialTargetBag: initialBag)
        bag.add(target: target)
        initialBag.currentTarget = nil

        bag.currentTarget = target

        XCTAssertEqual(initialBag.currentTarget?.id, target.id, "Doesn't update current target in initial bag")
    }

    func testWhenTargetAddedExpectedItWasAddedInInitialBag() throws {
        let target = TestObjFactory.getTarget()
        let initialBag = TestObjFactory.getTargetBag()
        let bag = TestObjFactory.getTargetBagRepoWrapper(initialTargetBag: initialBag)

        bag.add(target: target)

        XCTAssertEqual(initialBag.targets.count, 1, "Doesn't add target in initial bag")
    }

    func testWhenTargetCreatedExpectedItWasCreatedInInitialBag() throws {
        let initialBag = TestObjFactory.getTargetBag()
        let bag = TestObjFactory.getTargetBagRepoWrapper(initialTargetBag: initialBag)

        let target = bag.createTargetWith(
            name: "test",
            icon: "test",
            destination: TestObjFactory.locationVladivostok
        )

        XCTAssertEqual(initialBag.currentTarget?.id, target.id, "Doesn't create target in initial bag")
    }

    func testWhenTargetRemovedExpectedItWasRemovedInInitialBag() throws {
        let target = TestObjFactory.getTarget()
        let initialBag = TestObjFactory.getTargetBag()
        let bag = TestObjFactory.getTargetBagRepoWrapper(initialTargetBag: initialBag)
        bag.add(target: target)

        bag.remove(target: target)

        XCTAssertEqual(initialBag.targets.count, 0, "Doesn't remove target in initial bag")
    }

    // MARK: - RepoUpdateDelegate
    func testWhenCurrentTargetUpdatedExpectedSetCurrentTargetInDelegate() throws {
        let target = TestObjFactory.getTarget()
        let delegate = TestObjFactory.TestRepoUpdateDelegate()
        let bag = TestObjFactory.getTargetBagRepoWrapper(delegate: delegate)
        bag.add(target: target)
        var isCalled = false
        delegate.currentTargetSet = { _ in isCalled = true }

        bag.currentTarget = target

        XCTAssertTrue(isCalled, "Doesn't set current target in delegate")
    }

    func testWhenTargetAddedExpectedCallAddInDelegate() throws {
        let target = TestObjFactory.getTarget()
        let delegate = TestObjFactory.TestRepoUpdateDelegate()
        let bag = TestObjFactory.getTargetBagRepoWrapper(delegate: delegate)
        var isCalled = false
        delegate.addTargetHandler = { _, _ in isCalled = true }

        bag.add(target: target)

        XCTAssertTrue(isCalled, "Doesn't add target in delegate")
    }

    func testWhenTargetCreatedExpectedCallAddInDelegate() throws {
        let delegate = TestObjFactory.TestRepoUpdateDelegate()
        let bag = TestObjFactory.getTargetBagRepoWrapper(delegate: delegate)
        var isCalled = false
        delegate.addTargetHandler = { _, _ in isCalled = true }

        _ = bag.createTargetWith(
            name: "test",
            icon: "test",
            destination: TestObjFactory.locationVladivostok
        )

        XCTAssertTrue(isCalled, "Doesn't add target in delegate")
    }

    func testWhenTargetRemovedExpectedCallRemoveInDelegate() throws {
        let target = TestObjFactory.getTarget()
        let delegate = TestObjFactory.TestRepoUpdateDelegate()
        let bag = TestObjFactory.getTargetBagRepoWrapper(delegate: delegate)
        bag.add(target: target)
        var isCalled = false
        delegate.removeTargetHandler = { _ in isCalled = true }

        bag.remove(target: target)

        XCTAssertTrue(isCalled, "Doesn't remove target in delegate")
    }

    // MARK: - RepoUpdatedDelegate
    func testWhenExternalTargetAddedExpectedAddItToTargetBag() throws {
        let target = TestObjFactory.getTarget()
        let bag = TestObjFactory.getTargetBagRepoWrapper()

        bag.added(target: target)

        XCTAssertEqual(bag.targets.count, 1, "Target wasn't added")
    }

    func testWhenExternalTargetRemovedExpectedRemoveItToTargetBag() throws {
        let target = TestObjFactory.getTarget()
        let bag = TestObjFactory.getTargetBagRepoWrapper()
        bag.add(target: target)

        bag.removed(target: target)

        XCTAssertEqual(bag.targets.count, 0, "Target wasn't removed")
    }

    func testWhenExternalCurrentTargetChangedExpectedChangeCurrentTarget() throws {
        let target = TestObjFactory.getTarget()
        let bag = TestObjFactory.getTargetBagRepoWrapper()
        bag.add(target: target)
        bag.currentTarget = nil

        bag.updated(currentTarget: target)

        XCTAssertEqual(bag.currentTarget?.id, target.id, "Current target wasn't changed")
    }
}
