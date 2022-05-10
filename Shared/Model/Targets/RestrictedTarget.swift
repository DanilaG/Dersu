//
//  RestrictedTarget.swift
//  Dersu
//
//  Created by Danila on 07.05.2022.
//

import Foundation

/// The target with added restriction to update data
protocol DRRestrictedTarget: DRTarget {

    /// The target name can be changed
    var isCanChangeName: Bool { get }

    /// The target icon can be changed
    var isCanChangeIcon: Bool { get }

    /// The target destination can be changed
    var isCanChangeDestination: Bool { get }
}

class DRTargetRestrictorWrapper: DRRestrictedTarget {

    var isCanChangeName: Bool {
        delegate?.restrictedTargetCanChangeName(self) ?? false
    }

    var isCanChangeIcon: Bool {
        delegate?.restrictedTargetCanChangeIcon(self) ?? false
    }

    var isCanChangeDestination: Bool {
        delegate?.restrictedTargetCanChangeDestination(self) ?? false
    }

    var name: String {
        get { target.name }
        set {
            guard isCanChangeName else { return }

            target.name = newValue
            delegate?.restrictedTargetChanged(self, name: newValue)
        }
    }

    var icon: String {
        get { target.icon }
        set {
            guard isCanChangeIcon else { return }

            target.icon = newValue
            delegate?.restrictedTargetChanged(self, icon: newValue)
        }
    }

    var id: UUID { target.id }

    var updated: Date { target.updated }

    var destination: DRLocation {
        get { target.destination }
        set {
            guard isCanChangeDestination else { return }

            target.destination = newValue
            delegate?.restrictedTargetChanged(self, destination: newValue)
        }
    }

    var location: DRLocation? { target.location }

    var distance: DRMeasurement<DRDistance>? { target.distance }

    var direction: DRMeasurement<DRDirection>? { target.direction }

    var height: DRMeasurement<DRHeight>? { target.height }

    var warnings: [DRCompassWarning] { target.warnings }

    var error: DRCompassError? { target.error }

    var onUpdated: (() -> Void)? {
        get { target.onUpdated }
        set { target.onUpdated = newValue }
    }

    private var target: DRTarget

    private weak var delegate: DRTargetRestrictorDelegate?

    init(for target: DRTarget, delegate: DRTargetRestrictorDelegate) {
        self.target = target
        self.delegate = delegate
    }
}

/// Delegate for target update restriction
protocol DRTargetRestrictorDelegate: AnyObject {

    /// True if delegate allows change the target name
    func restrictedTargetCanChangeName(_ target: DRTarget) -> Bool

    /// True if delegate allows change the target icon
    func restrictedTargetCanChangeIcon(_ target: DRTarget) -> Bool

    /// True if delegate allows change the target destination
    func restrictedTargetCanChangeDestination(_ target: DRTarget) -> Bool

    /// Called when the target name was updated
    func restrictedTargetChanged(_ target: DRTarget, name: String)

    /// Called when the target icon was updated
    func restrictedTargetChanged(_ target: DRTarget, icon: String)

    /// Called when the target destination was updated
    func restrictedTargetChanged(_ target: DRTarget, destination: DRLocation)
}
