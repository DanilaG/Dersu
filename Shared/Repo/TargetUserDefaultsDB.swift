//
//  TargetUserDefaultsDB.swift
//  Dersu
//
//  Created by Danila on 04.06.2022.
//

import Foundation

class DRTargetUserDefaultsDB: DRTargetDB {

    var currentTarget: DRTargetData? {
        didSet { saveCurrentTarget() }
    }

    private(set) var targets: [DRTargetData] {
        didSet { saveTargets() }
    }

    init() {
        currentTarget = DRTargetUserDefaultsDB.getCurrentTarget()
        targets = DRTargetUserDefaultsDB.getTargets()

        if let currentTarget = currentTarget,
           targets.first(where: { currentTarget.id == $0.id}) == nil {
            targets.append(currentTarget)
            saveTargets()
        }
    }

    func add(target: DRTargetData) {
        if let index = targets.firstIndex(where: { $0.id == target.id }) {
            targets[index] = target
        } else {
            targets.append(target)
        }
    }

    func remove(target: DRTargetData) {
        targets.removeAll(where: { $0.id == target.id })
    }

    func update(target: DRTargetData, name: String) {
        guard let index = targets.firstIndex(where: { $0.id == target.id }) else {
            return
        }

        targets[index] = DRTargetData(
            name: name,
            icon: target.icon,
            id: target.id,
            updated: target.updated,
            destination: target.destination
        )
    }

    func update(target: DRTargetData, icon: String) {
        guard let index = targets.firstIndex(where: { $0.id == target.id }) else {
            return
        }

        targets[index] = DRTargetData(
            name: target.name,
            icon: icon,
            id: target.id,
            updated: target.updated,
            destination: target.destination
        )
    }

    func update(target: DRTargetData, destination: DRLocationData) {
        guard let index = targets.firstIndex(where: { $0.id == target.id }) else {
            return
        }

        targets[index] = DRTargetData(
            name: target.name,
            icon: target.icon,
            id: target.id,
            updated: target.updated,
            destination: destination
        )
    }

    func update(target: DRTargetData, updated: Date) {
        guard let index = targets.firstIndex(where: { $0.id == target.id }) else {
            return
        }

        targets[index] = DRTargetData(
            name: target.name,
            icon: target.icon,
            id: target.id,
            updated: updated,
            destination: target.destination
        )
    }
}

extension DRTargetUserDefaultsDB {

    static private func getCurrentTarget() -> DRTargetData? {
        guard let data = UserDefaults.standard.data(forKey: Keys.currentTarget) else {
            return nil
        }

        return try? JSONDecoder().decode((DRTargetData?).self, from: data)
    }

    static private func getTargets() -> [DRTargetData] {
        guard let data = UserDefaults.standard.data(forKey: Keys.targets) else {
            return []
        }

        return (try? JSONDecoder().decode([DRTargetData].self, from: data)) ?? []
    }

    private func saveCurrentTarget() {
        guard let data = try? JSONEncoder().encode(currentTarget) else {
            return
        }

        UserDefaults.standard.set(data, forKey: Keys.currentTarget)
    }

    private func saveTargets() {
        guard let data = try? JSONEncoder().encode(targets) else {
            return
        }

        UserDefaults.standard.set(data, forKey: Keys.targets)
    }

    struct Keys {
        static var currentTarget = "CurrentTarget"
        static var targets = "Targets"
    }
}
