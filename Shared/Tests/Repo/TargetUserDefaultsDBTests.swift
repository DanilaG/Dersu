//
//  TargetUserDefaultsDBTests.swift
//  DersuSharedTests
//
//  Created by Danila on 04.06.2022.
//

import XCTest

class TargetUserDefaultsDBTests: XCTestCase {

    override func setUpWithError() throws {
        let database = DRTargetUserDefaultsDB()
        database.currentTarget = nil
        database.targets.forEach { [weak database] in
            database?.remove(target: $0)
        }
    }

    func testWhenSetCurrentTargetExpectedItSaved() throws {
        let database = DRTargetUserDefaultsDB()
        let target = TestObjFactory.getTargetData()

        database.currentTarget = target

        XCTAssertEqual(
            DRTargetUserDefaultsDB().currentTarget?.id,
            target.id,
            "Current target wasn't saved."
        )
    }

    func testWhenAddTargetExpectedItAddedInTargets() throws {
        let database = DRTargetUserDefaultsDB()
        let target = TestObjFactory.getTargetData()

        database.add(target: target)

        XCTAssertEqual(
            database.targets.first?.id,
            target.id,
            "Target wasn't added."
        )
    }

    func testWhenAddTargetExpectedItSaved() throws {
        let database = DRTargetUserDefaultsDB()
        let target = TestObjFactory.getTargetData()

        database.add(target: target)

        XCTAssertEqual(
            DRTargetUserDefaultsDB().targets.first?.id,
            target.id,
            "Target add wasn't saved."
        )
    }

    func testWhenRemoveTargetExpectedItRemovedInTargets() throws {
        let database = DRTargetUserDefaultsDB()
        let target = TestObjFactory.getTargetData()
        database.add(target: target)

        database.remove(target: target)

        XCTAssertTrue(
            database.targets.isEmpty,
            "Target wasn't removed."
        )
    }

    func testWhenRemoveTargetExpectedItSaved() throws {
        let database = DRTargetUserDefaultsDB()
        let target = TestObjFactory.getTargetData()
        database.add(target: target)

        database.remove(target: target)

        XCTAssertTrue(
            DRTargetUserDefaultsDB().targets.isEmpty,
            "Target remove wasn't saved."
        )
    }

    func testWhenUpdatedTargetNameExpectedItUpdatedInTargets() throws {
        let newName = "newName"
        let database = DRTargetUserDefaultsDB()
        let target = TestObjFactory.getTargetData()
        database.add(target: target)

        database.update(target: target, name: newName)

        XCTAssertEqual(
            database.targets.first?.name,
            newName,
            "Target name wasn't updated."
        )
    }

    func testWhenUpdatedTargetNameExpectedItSaved() throws {
        let newName = "newName"
        let database = DRTargetUserDefaultsDB()
        let target = TestObjFactory.getTargetData()
        database.add(target: target)

        database.update(target: target, name: newName)

        XCTAssertEqual(
            DRTargetUserDefaultsDB().targets.first?.name,
            newName,
            "Target name wasn't saved."
        )
    }

    func testWhenUpdatedTargetIconExpectedItUpdatedInTargets() throws {
        let newIcon = "newIcon"
        let database = DRTargetUserDefaultsDB()
        let target = TestObjFactory.getTargetData()
        database.add(target: target)

        database.update(target: target, icon: newIcon)

        XCTAssertEqual(
            database.targets.first?.icon,
            newIcon,
            "Target icon wasn't updated."
        )
    }

    func testWhenUpdatedTargetIconExpectedItSaved() throws {
        let newIcon = "newIcon"
        let database = DRTargetUserDefaultsDB()
        let target = TestObjFactory.getTargetData()
        database.add(target: target)

        database.update(target: target, icon: newIcon)

        XCTAssertEqual(
            DRTargetUserDefaultsDB().targets.first?.icon,
            newIcon,
            "Target icon wasn't saved."
        )
    }

    func testWhenUpdatedTargetDestinationExpectedItUpdatedInTargets() throws {
        let newDestination = TestObjFactory.getLocationData(latitude: 1.1)
        let database = DRTargetUserDefaultsDB()
        let target = TestObjFactory.getTargetData()
        database.add(target: target)

        database.update(target: target, destination: newDestination)

        XCTAssertEqual(
            database.targets.first?.destination.latitude,
            newDestination.latitude,
            "Target destination wasn't updated."
        )
    }

    func testWhenUpdatedTargetDestinationExpectedItSaved() throws {
        let newDestination = TestObjFactory.getLocationData(latitude: 1.1)
        let database = DRTargetUserDefaultsDB()
        let target = TestObjFactory.getTargetData()
        database.add(target: target)

        database.update(target: target, destination: newDestination)

        XCTAssertEqual(
            DRTargetUserDefaultsDB().targets.first?.destination.latitude,
            newDestination.latitude,
            "Target destination wasn't saved."
        )
    }

    func testWhenUpdatedTargetUpdatedExpectedItUpdatedInTargets() throws {
        let newUpdated = Date()
        let database = DRTargetUserDefaultsDB()
        let target = TestObjFactory.getTargetData()
        database.add(target: target)

        database.update(target: target, updated: newUpdated)

        XCTAssertEqual(
            database.targets.first?.updated,
            newUpdated,
            "Target updated wasn't updated."
        )
    }

    func testWhenUpdatedTargetUpdatedExpectedItSaved() throws {
        let newUpdated = Date()
        let database = DRTargetUserDefaultsDB()
        let target = TestObjFactory.getTargetData()
        database.add(target: target)

        database.update(target: target, updated: newUpdated)

        XCTAssertEqual(
            DRTargetUserDefaultsDB().targets.first?.updated,
            newUpdated,
            "Target updated wasn't saved."
        )
    }
}
