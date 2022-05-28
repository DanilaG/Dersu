//
//  TargetBag.swift
//  Dersu
//
//  Created by Danila on 23.05.2022.
//

import Swinject

/// The storage for targets
protocol DRTargetBag {

    /// The target selected for navigation
    var currentTarget: DRTarget? { get set }

    /// All targets
    var targets: [DRTarget] { get }

    /// Create and add target to the targets
    /// The created target becomes current
    func createTargetWith(name: String, icon: String, destination: DRLocation) -> DRTarget

    /// Add target to the targets
    func add(target: DRTarget)

    /// Remove target if it stored
    func remove(target: DRTarget)
}

class DRTargetBagImpl: DRTargetBag {

    var currentTarget: DRTarget? {
        get { _currentTarget }
        set { updateCurrentTarget(newValue) }
    }

    var targets: [DRTarget] = []

    private var assembler: Assembler

    private var _currentTarget: DRTarget?

    init(_ assembler: Assembler) {
        self.assembler = assembler
    }

    func createTargetWith(name: String, icon: String, destination: DRLocation) -> DRTarget {
        guard let target = assembler.resolver.resolve(DRTarget.self, arguments: name, icon, destination) else {
            preconditionFailure("Error on target creation!")
        }

        targets.append(target)
        currentTarget = target
        return target
    }

    func add(target: DRTarget) {
        guard targets.first(where: { $0.id == target.id }) == nil else {
            return
        }

        targets.append(target)
    }

    func remove(target: DRTarget) {
        if currentTarget?.id == target.id {
            currentTarget = nil
        }

        targets.removeAll { $0.id == target.id }
    }

    private func updateCurrentTarget(_ newValue: DRTarget?) {
        guard let newTarget = newValue,
              targets.first(where: { $0.id == newTarget.id }) != nil else {
            _currentTarget = nil
            return
        }

        _currentTarget = newTarget
    }
}
