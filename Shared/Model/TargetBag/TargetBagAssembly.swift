//
//  TargetBagAssembly.swift
//  Dersu
//
//  Created by Danila on 28.05.2022.
//

import Swinject

final class DRTargetBagAssembly: Assembly {

    func assemble(container: Container) {
        container.register(DRTargetBag.self) { (_, assembler: Assembler) in
            DRTargetBagImpl(assembler)
        }
    }

    init() {}
}
