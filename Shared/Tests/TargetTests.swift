//
//  TargetTests.swift
//  DersuSharedTests
//
//  Created by Danila on 23.05.2022.
//

import XCTest
import Swinject

class TargetTests: XCTestCase {

    func testWhenTargetAssemblyAskedFrom3ArgsExpectedNotNil() throws {
        let assembler = Assembler([
            DRTargetAssembly(),
            DRCompassAssembly(),
            TestObjFactory.TestLocationManagerAssembly()
        ])
        let name = "Test"
        let icon = "Test"
        let destination = TestObjFactory.locationVladivostok

        let target = assembler.resolver.resolve(DRTarget.self, arguments: name, icon, destination)

        XCTAssertNotNil(target, "DRTargetAssembly doesn't work for 3 arguments")
    }

    func testWhenTargetAssemblyAskedFrom5ArgsExpectedNotNil() throws {
        let assembler = Assembler([
            DRTargetAssembly(),
            DRCompassAssembly(),
            TestObjFactory.TestLocationManagerAssembly()
        ])
        let name = "Test"
        let icon = "Test"
        let id = UUID()
        let date = Date()
        let destination = TestObjFactory.locationVladivostok

        let target = assembler.resolver.resolve(DRTarget.self, arguments: name, icon, id, date, destination)

        XCTAssertNotNil(target, "DRTargetAssembly doesn't work for 5 arguments")
    }
}
