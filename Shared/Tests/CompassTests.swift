//
//  CompassTests.swift
//  DersuSharedTests
//
//  Created by Danila on 23.05.2022.
//

import XCTest
import Swinject

class CompassTests: XCTestCase {

    func testWhenCompassAssemblyAskedExpectedNotNil() throws {
        let assembler = Assembler([
            DRCompassAssembly(),
            TestObjFactory.TestLocationManagerAssembly()
        ])
        let destination = TestObjFactory.locationVladivostok

        let compass = assembler.resolver.resolve(DRCompass.self, argument: destination)

        XCTAssertNotNil(compass, "DRCompassAssembly doesn't work")
    }
}
