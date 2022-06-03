//
//  LocationData.swift
//  Dersu
//
//  Created by Danila on 03.06.2022.
//

import Foundation

/// Represent location data
struct DRLocationData {

    let latitude: Double
    let longitude: Double
    let distanceError: Double
    let altitude: Double
    let altitudeError: Double

    init(
        latitude: Double,
        longitude: Double,
        distanceError: Double = 0.0,
        altitude: Double,
        altitudeError: Double = 0.0
    ) {
        self.latitude = latitude
        self.longitude = longitude
        self.distanceError = distanceError
        self.altitude = altitude
        self.altitudeError = altitudeError
    }
}

extension DRLocationData: Codable {}

extension DRLocationData {

    init(from location: DRLocation) {
        self.init(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            distanceError: location.coordinate.distanceError,
            altitude: location.altitude.value,
            altitudeError: location.altitude.error)
    }

    func toLocation() -> DRLocation {
        DRLocation(
            coordinate: DRLocationCoordinate(
                latitude: latitude,
                longitude: longitude,
                distanceError: distanceError
            ),
            altitude: DRMeasurement<DRHeight>(altitude, error: altitudeError)
        )
    }
}
