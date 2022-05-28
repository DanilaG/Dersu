//
//  Target.swift
//  Dersu
//
//  Created by Danila on 07.05.2022.
//

import Foundation

/// The compass with identification attributes
protocol DRTarget: DRCompass {

    /// The name of the target
    var name: String { get set }

    /// The icon name of the target
    var icon: String { get set }

    /// Id of the target
    var id: UUID { get }

    /// The last date of destination update
    var updated: Date { get set }
}

class DRTargetImpl: DRTarget {
    var name: String

    var icon: String

    var id: UUID

    var updated: Date

    var destination: DRLocation {
        get { compass.destination }
        set { compass.destination = newValue }
    }

    var location: DRLocation? { compass.location }

    var distance: DRMeasurement<DRDistance>? { compass.distance }

    var direction: DRMeasurement<DRDirection>? { compass.direction }

    var height: DRMeasurement<DRHeight>? { compass.height }

    var warnings: [DRCompassWarning] { compass.warnings }

    var error: DRCompassError? { compass.error }

    var onUpdated: (() -> Void)?

    private var compass: DRCompass

    init(name: String, icon: String, id: UUID, updated: Date, compass: DRCompass) {
        self.name = name
        self.icon = icon
        self.id = id
        self.updated = updated
        self.compass = compass
    }
}
