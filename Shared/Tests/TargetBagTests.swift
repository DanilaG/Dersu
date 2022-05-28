//
//  TargetBagTests.swift
//  DersuSharedTests
//
//  Created by Danila on 28.05.2022.
//

import XCTest
import Swinject

class TargetBagTests: XCTestCase {

    func testWhenTargetBagAssemblyAskedExpectedNotNil() throws {
        let assembler = Assembler([
            DRTargetBagAssembly(),
            DRTargetAssembly(),
            DRCompassAssembly(),
            TestObjFactory.TestLocationManagerAssembly()
        ])

        let bag = assembler.resolver.resolve(DRTargetBag.self, argument: assembler)

        XCTAssertNotNil(bag, "DRTargetBagAssembly doesn't work")
    }
}
