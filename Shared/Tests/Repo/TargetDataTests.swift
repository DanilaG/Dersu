//
//  TargetDataTests.swift
//  DersuSharedTests
//
//  Created by Danila on 03.06.2022.
//

import XCTest

class TargetDataTests: XCTestCase {

    func testWhenGetTargetFromTargetDataExpectedRightName() throws {
        let name = "test"
        let targetData = TestObjFactory.getTargetData(name: name)
        let target = targetData.toTarget(with: TestObjFactory.assembler)

        XCTAssertEqual(target.name, name, "Wrong transformation target data to target: name")
    }

    func testWhenGetTargetFromTargetDataExpectedRightIcon() throws {
        let icon = "test"
        let targetData = TestObjFactory.getTargetData(icon: icon)
        let target = targetData.toTarget(with: TestObjFactory.assembler)

        XCTAssertEqual(target.icon, icon, "Wrong transformation target data to target: icon")
    }

    func testWhenGetTargetFromTargetDataExpectedRightId() throws {
        let id = UUID()
        let targetData = TestObjFactory.getTargetData(id: id)
        let target = targetData.toTarget(with: TestObjFactory.assembler)

        XCTAssertEqual(target.id, id, "Wrong transformation target data to target: id")
    }

    func testWhenGetTargetFromTargetDataExpectedRightUpdated() throws {
        let updated = Date()
        let targetData = TestObjFactory.getTargetData(updated: updated)
        let target = targetData.toTarget(with: TestObjFactory.assembler)

        XCTAssertEqual(target.updated, updated, "Wrong transformation target data to target: updated")
    }

    func testWhenGetTargetFromTargetDataExpectedRightDestination() throws {
        let latitude: DRLatitude = 1.1
        let destination = TestObjFactory.getLocationData(latitude: latitude)
        let targetData = TestObjFactory.getTargetData(destination: destination)
        let target = targetData.toTarget(with: TestObjFactory.assembler)

        XCTAssertEqual(
            target.destination.coordinate.latitude,
            latitude,
            "Wrong transformation target data to target: destination"
        )
    }

    func testWhenGetTargetDataFromTargetExpectedRightName() throws {
        let name = "test"
        let target = TestObjFactory.getTarget(name: name)
        let targetData = DRTargetData(from: target)

        XCTAssertEqual(targetData.name, name, "Wrong transformation target to target data: name")
    }

    func testWhenGetTargetDataFromTargetExpectedRightIcon() throws {
        let icon = "test"
        let target = TestObjFactory.getTarget(icon: icon)
        let targetData = DRTargetData(from: target)

        XCTAssertEqual(targetData.icon, icon, "Wrong transformation target to target data: icon")
    }

    func testWhenGetTargetDataFromTargetExpectedRightId() throws {
        let id = UUID()
        let target = TestObjFactory.getTarget(id: id)
        let targetData = DRTargetData(from: target)

        XCTAssertEqual(targetData.id, id, "Wrong transformation target to target data: id")
    }

    func testWhenGetTargetDataFromTargetExpectedRightUpdated() throws {
        let updated = Date()
        let target = TestObjFactory.getTarget(updated: updated)
        let targetData = DRTargetData(from: target)

        XCTAssertEqual(targetData.updated, updated, "Wrong transformation target to target data: updated")
    }

    func testWhenGetTargetDataFromTargetExpectedRightDestination() throws {
        let destination = TestObjFactory.locationVladivostok
        let target = TestObjFactory.getTarget(destination: destination)
        let targetData = DRTargetData(from: target)

        XCTAssertEqual(
            targetData.destination.altitude,
            destination.altitude.value,
            "Wrong transformation target to target data: destination"
        )
    }
}
