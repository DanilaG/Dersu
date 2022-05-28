//
//  TargetBagImpl.swift
//  DersuSharedTests
//
//  Created by Danila on 23.05.2022.
//

import XCTest

class TargetBagImpl: XCTestCase {

    func testWhenTargetCreatedExpectedItIsCurrentTarget() throws {
        var targetBag = TestObjFactory.getTargetBag()
        targetBag.currentTarget = nil

        let target = targetBag.createTargetWith(
            name: "test",
            icon: "test",
            destination: TestObjFactory.locationVladivostok
        )

        XCTAssertEqual(
            targetBag.currentTarget?.id,
            target.id,
            "Created target doesn't equal to current"
        )
    }

    func testWhenTargetCreatedExpectedItIsAddedToTargets() throws {
        let targetBag = TestObjFactory.getTargetBag()

        let target = targetBag.createTargetWith(
            name: "test",
            icon: "test",
            destination: TestObjFactory.locationVladivostok
        )

        XCTAssertNotNil(
            targetBag.targets.first(where: { $0.id == target.id }),
            "New target didn't added to targets"
        )
    }

    func testWhenRemoveExistingTargetExpectedItIsRemoved() throws {
        let targetBag = TestObjFactory.getTargetBag()
        let target = targetBag.createTargetWith(
            name: "test",
            icon: "test",
            destination: TestObjFactory.locationVladivostok
        )

        targetBag.remove(target: target)

        XCTAssertEqual(targetBag.targets.count, 0, "Target doesn't deleted")
    }

    func testWhenRemoveTargetNotFromTargetsExpectedNothingChange() throws {
        let targetBag = TestObjFactory.getTargetBag()
        _ = targetBag.createTargetWith(
            name: "test",
            icon: "test",
            destination: TestObjFactory.locationVladivostok
        )
        let target = TestObjFactory.getTarget()

        targetBag.remove(target: target)

        XCTAssertEqual(targetBag.targets.count, 1, "Wrong target was deleted")
    }

    func testWhenRemoveCurrentTargetExpectedCurrentTargetNil() throws {
        let targetBag = TestObjFactory.getTargetBag()
        _ = targetBag.createTargetWith(
            name: "test",
            icon: "test",
            destination: TestObjFactory.locationVladivostok
        )

        targetBag.remove(target: targetBag.currentTarget!)

        XCTAssertNil(targetBag.currentTarget, "Current target doesn't deleted")
    }

    func testWhenSetCurrentTargetNotFromTargetsExpectedNothingChange() throws {
        var targetBag = TestObjFactory.getTargetBag()
        let target = TestObjFactory.getTarget()

        targetBag.currentTarget = target

        XCTAssertNil(targetBag.currentTarget, "Current target not from the targets")
    }

    func testWhenAddExistingTargetExpectedNoChanges() throws {
        let targetBag = TestObjFactory.getTargetBag()
        let target = targetBag.createTargetWith(
            name: "test",
            icon: "test",
            destination: TestObjFactory.locationVladivostok
        )

        targetBag.add(target: target)

        XCTAssertEqual(targetBag.targets.count, 1, "Added existed target")
    }

    func testWhenAddTargetExpectedItInTargets() throws {
        let targetBag = TestObjFactory.getTargetBag()
        let target = TestObjFactory.getTarget()

        targetBag.add(target: target)

        XCTAssertNotNil(targetBag.targets.first(where: { $0.id == target.id }), "Target not added")
    }
}
