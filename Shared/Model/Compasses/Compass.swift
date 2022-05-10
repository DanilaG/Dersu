//
//  Compass.swift
//  Dersu
//
//  Created by Danila on 25.04.2022.
//

import Foundation

/// Provides distance, direction and height different to the destination
protocol DRCompass: DRSelfUpdated {

    /// A destination location for the compass
    var destination: DRLocation { get set }

    /// A current user location
    var location: DRLocation? { get }

    /// A distance to the destination
    var distance: DRMeasurement<DRDistance>? { get }

    /// A direction to the destination
    var direction: DRMeasurement<DRDirection>? { get }

    /// A different between current and destination altitude
    var height: DRMeasurement<DRHeight>? { get }

    /// Warnings of the compass to user
    var warnings: [DRCompassWarning] { get }

    /// Error of the compass to user
    var error: DRCompassError? { get }
}

/// Protocol for a DRCompass warning
protocol DRCompassWarning {}

/// Protocol for a DRCompass error
protocol DRCompassError {}
