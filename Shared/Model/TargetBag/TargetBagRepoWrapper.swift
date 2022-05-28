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
        delegate?.add(target: target, with: target as? DRTargetRepoUpdatedDelegate)

        return target
    }

    func add(target: DRTarget) {
        targetBag.add(target: target)
        delegate?.add(target: target, with: target as? DRTargetRepoUpdatedDelegate)
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

    /// Add the target to the repository and set delegate for it
    func add(target: DRTarget, with delegate: DRTargetRepoUpdatedDelegate?)

    /// Remove the target from the repository
    func remove(target: DRTarget)
}

/// The delegate for updating targets from repository
protocol DRRepoUpdatedDelegate: AnyObject {

    /// The function called on external current target update
    func updated(currentTarget: DRTarget)

    /// The function called on external target adding
    func added(target: DRTarget)

    /// The function called on external target removing
    func removed(target: DRTarget)
}

extension DRTargetBagRepoWrapper: DRRepoUpdatedDelegate {

    func updated(currentTarget: DRTarget) {
        targetBag.currentTarget = currentTarget
    }

    func added(target: DRTarget) {
        targetBag.add(target: target)
    }

    func removed(target: DRTarget) {
        targetBag.remove(target: target)
    }
}
