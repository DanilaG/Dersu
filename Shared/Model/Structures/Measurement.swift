//
//  Measurement.swift
//  Dersu
//
//  Created by Danila on 25.04.2022.
//

import Foundation

/// A result of a measurement
struct DRMeasurement<T> {

    /// A value of the measurement
    var value: T

    /// An error of the measurement
    var error: T

    init(_ value: T, error: T) {
        self.value = value
        self.error = error
    }
}

/// A latitude in decimal degrees
typealias DRLatitude = Double

/// A longitude in decimal degrees
typealias DRLongitude = Double

/// A distance in meters
typealias DRDistance = Double

/// A altitude in meters
typealias DRHeight = Double

/// A direction in radians
typealias DRDirection = Double
