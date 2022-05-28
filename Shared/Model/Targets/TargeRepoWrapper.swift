//
//  TargeRepoWrapper.swift
//  Dersu
//
//  Created by Danila on 07.05.2022.
//

import Foundation

/// Add the repository delegate to the DRTarget
class DRTargetRepoWrapper: DRTarget {
    var name: String {
        get { target.name }
        set {
            target.name = newValue
            delegate?.targetUpdate(self, name: newValue)
        }
    }

    var icon: String {
        get { target.icon }
        set {
            target.icon = newValue
            delegate?.targetUpdate(self, icon: newValue)
        }
    }

    var id: UUID { target.id }

    var updated: Date {
        get { target.updated }
        set {
            target.updated = newValue
            delegate?.targetUpdate(self, updated: newValue)
        }
    }

    var destination: DRLocation {
        get { target.destination }
        set {
            target.destination = newValue
            delegate?.targetUpdate(self, destination: newValue)
        }
    }

    var location: DRLocation? { target.location }

    var distance: DRMeasurement<DRDistance>? { target.direction }

    var direction: DRMeasurement<DRDirection>? { target.direction }

    var height: DRMeasurement<DRHeight>? { target.height }

    var warnings: [DRCompassWarning] { target.warnings }

    var error: DRCompassError? { target.error }

    var onUpdated: (() -> Void)? {
        get { target.onUpdated }
        set { target.onUpdated = newValue }
    }

    private var target: DRTarget

    private weak var delegate: DRTargetRepoUpdateDelegate?

    init(for target: DRTarget, delegate: DRTargetRepoUpdateDelegate) {
        self.target = target
        self.delegate = delegate
    }
}

/// The delegate for updating target data in repository
protocol DRTargetRepoUpdateDelegate: AnyObject {

    /// Update name of the target in repository
    func targetUpdate(_ target: DRTarget, name: String)

    /// Update icon of the target in repository
    func targetUpdate(_ target: DRTarget, icon: String)

    /// Update destination of the target in repository
    func targetUpdate(_ target: DRTarget, destination: DRLocation)

    /// Update updated of the target in repository
    func targetUpdate(_ target: DRTarget, updated: Date)
}

/// The delegate for updating target data from repository
protocol DRTargetRepoUpdatedDelegate: AnyObject {

    /// The function called on external target name update
    func targetUpdated(name: String)

    /// The function called on external target icon update
    func targetUpdated(icon: String)

    /// The function called on external target destination update
    func targetUpdated(destination: DRLocation)

    /// The function called on external target updated date update
    func targetUpdated(updated: Date)
}

extension DRTargetRepoWrapper: DRTargetRepoUpdatedDelegate {

    func targetUpdated(name: String) {
        target.name = name
    }

    func targetUpdated(icon: String) {
        target.icon = icon
    }

    func targetUpdated(destination: DRLocation) {
        target.destination = destination
    }

    func targetUpdated(updated: Date) {
        target.updated = updated
    }
}
