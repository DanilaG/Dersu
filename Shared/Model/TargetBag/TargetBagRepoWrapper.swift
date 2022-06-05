//
//  TargetBagRepoWrapper.swift
//  Dersu
//
//  Created by Danila on 25.05.2022.
//

import Foundation

class DRTargetBagRepoWrapper: DRTargetBag {
    var currentTarget: DRTarget? {
        get { targetBag.currentTarget }
        set {
            targetBag.currentTarget = newValue
            delegate?.currentTarget = newValue
        }
    }

    var targets: [DRTarget] { targetBag.targets }

    private var targetBag: DRTargetBag

    private weak var delegate: DRRepoUpdateDelegate?

    init(for targetBag: DRTargetBag, delegate: DRRepoUpdateDelegate) {
        self.targetBag = targetBag
        self.delegate = delegate

        delegate.getTargets().forEach {
            self.targetBag.add(target: $0)
        }

        self.targetBag.currentTarget = delegate.currentTarget
    }

    func createTargetWith(name: String, icon: String, destination: DRLocation) -> DRTarget {
        let target = targetBag.createTargetWith(name: name, icon: icon, destination: destination)
        delegate?.add(target: target)

        return target
    }

    func add(target: DRTarget) {
        targetBag.add(target: target)
        delegate?.add(target: target)
    }

    func remove(target: DRTarget) {
        targetBag.remove(target: target)
        delegate?.remove(target: target)
    }
}

/// The delegate for updating targets in repository
protocol DRRepoUpdateDelegate: DRTargetRepoUpdateDelegate {

    /// Current user target in the repository
    var currentTarget: DRTarget? { get set }

    /// Return all targets
    func getTargets() -> [DRTarget]

    /// Add the target to the repository
    func add(target: DRTarget)

    /// Remove the target from the repository
    func remove(target: DRTarget)
}

/// The delegate for updating targets from repository
protocol DRRepoUpdatedDelegate: AnyObject {

    /// The function called on external target adding
    func added(target: DRTarget)

    /// The function called on external target removing
    func removed(target: DRTarget)

    /// The function called on external current target update
    func updated(currentTarget: DRTarget)

    /// The function called on external the target name update
    func updated(target: DRTarget, name: String)

    /// The function called on external the target icon update
    func updated(target: DRTarget, icon: String)

    /// The function called on external the target destination update
    func updated(target: DRTarget, destination: DRLocation)

    /// The function called on external the target updated update
    func updated(target: DRTarget, updated: Date)
}

extension DRTargetBagRepoWrapper: DRRepoUpdatedDelegate {

    func added(target: DRTarget) {
        targetBag.add(target: target)
    }

    func removed(target: DRTarget) {
        targetBag.remove(target: target)
    }

    func updated(currentTarget: DRTarget) {
        targetBag.currentTarget = currentTarget
    }

    func updated(target: DRTarget, name: String) {
        guard let delegate = getDelegate(for: target) else { return }

        delegate.targetUpdated(name: name)
    }

    func updated(target: DRTarget, icon: String) {
        guard let delegate = getDelegate(for: target) else { return }

        delegate.targetUpdated(icon: icon)
    }

    func updated(target: DRTarget, destination: DRLocation) {
        guard let delegate = getDelegate(for: target) else { return }

        delegate.targetUpdated(destination: destination)
    }

    func updated(target: DRTarget, updated: Date) {
        guard let delegate = getDelegate(for: target) else { return }

        delegate.targetUpdated(updated: updated)
    }

    private func getDelegate(for target: DRTarget) -> DRTargetRepoUpdatedDelegate? {
        targets.first(where: { target.id == $0.id }) as? DRTargetRepoUpdatedDelegate
    }
}
