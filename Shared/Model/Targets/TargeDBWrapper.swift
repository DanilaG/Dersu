//
//  TargeDBWrapper.swift
//  Dersu
//
//  Created by Danila on 07.05.2022.
//

import Foundation

/// Add the DB delegate to the DRTarget
class DRTargetDBWrapper: DRTarget {
    var name: String {
        get { target.name }
        set {
            target.name = newValue
            delegate?.targetUpdated(self, name: newValue)
        }
    }

    var icon: String {
        get { target.icon }
        set {
            target.icon = newValue
            delegate?.targetUpdated(self, icon: newValue)
        }
    }

    var id: UUID { target.id }

    var updated: Date { target.updated }

    var destination: DRLocation {
        get { target.destination }
        set {
            target.destination = newValue
            delegate?.targetUpdated(self, destination: newValue)
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

    private weak var delegate: DRTargetStoredDataUpdateDelegate?

    init(for target: DRTarget, delegate: DRTargetStoredDataUpdateDelegate) {
        self.target = target
        self.delegate = delegate
    }
}

/// The delegate for updating target data in DB
protocol DRTargetStoredDataUpdateDelegate: AnyObject {

    /// The function called on name change
    func targetUpdated(_ target: DRTarget, name: String)

    /// The function called on icon change
    func targetUpdated(_ target: DRTarget, icon: String)

    /// The function called on destination change
    func targetUpdated(_ target: DRTarget, destination: DRLocation)
}
