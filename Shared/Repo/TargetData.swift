//
//  TargetData.swift
//  Dersu
//
//  Created by Danila on 03.06.2022.
//

import Swinject

/// Represent target data
struct DRTargetData {

    let name: String
    let icon: String
    let id: UUID
    let updated: Date
    let destination: DRLocationData

    init(name: String, icon: String, id: UUID, updated: Date, destination: DRLocationData) {
        self.name = name
        self.icon = icon
        self.id = id
        self.updated = updated
        self.destination = destination
    }
}

extension DRTargetData: Codable {}

extension DRTargetData {

    init(from target: DRTarget) {
        self.init(
            name: target.name,
            icon: target.icon,
            id: target.id,
            updated: target.updated,
            destination: DRLocationData(from: target.destination)
        )
    }

    func toTarget(with assembler: Assembler) -> DRTarget {
        assembler.resolver.resolve(
            DRTarget.self,
            arguments: name, icon, id, updated, destination.toLocation()
        )!
    }
}
