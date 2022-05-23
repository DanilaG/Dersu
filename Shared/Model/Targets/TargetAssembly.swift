//
//  TargetAssembly.swift
//  Dersu
//
//  Created by Danila on 23.05.2022.
//

import Swinject

final class DRTargetAssembly: Assembly {

    func assemble(container: Container) {
        container.register(DRTarget.self) { (resolver, name: String, icon: String, destination: DRLocation) in
            let compass = resolver.resolve(DRCompass.self, argument: destination)
            let target = DRTargetImpl(
                name: name,
                icon: icon,
                id: UUID(),
                updated: Date(),
                compass: compass!
            )

            return target
        }

        container
            .register(DRTarget.self) { (
                resolver, name: String, icon: String, id: UUID, updated: Date, destination: DRLocation
            ) in
            let compass = resolver.resolve(DRCompass.self, argument: destination)
            let target = DRTargetImpl(
                name: name,
                icon: icon,
                id: id,
                updated: updated,
                compass: compass!
            )

            return target
        }
    }

    init() {}
}
