//
//  DerivedLocation.swift
//  Dersu
//
//  Created by Danila on 25.04.2022.
//

import Foundation

/// The coordinates with altitude
struct DRLocation {

    /// The 2D coordinates
    var coordinate: DRLocationCoordinate

    /// The altitude in meters
    var altitude: DRMeasurement<DRHeight>
}

/// The latitude and longitude associated with a location, specified using the WGS 84 reference frame
struct DRLocationCoordinate {

    /// The latitude in degrees
    var latitude: DRLatitude

    /// The longitude in degrees
    var longitude: DRLongitude

    /// The error of coordinate determinations in meters
    var distanceError: DRDistance = 0
}
