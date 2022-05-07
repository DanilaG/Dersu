//
//  TestObjFactory.swift
//  DersuSharedTests
//
//  Created by Danila on 07.05.2022.
//

import Foundation

class TestObjFactory {
    static var locationVladivostok: DRLocation {
        TestObjFactory.getLocation(latitude: 43.028345, longitude: 131.886473, altitude: 10.5)
    }

    static var locationSanFrancisco: DRLocation {
        TestObjFactory.getLocation(latitude: 37.809767, longitude: -122.477461, altitude: 20.1)
    }

    static func getLocation(
        latitude: DRLatitude = 0,
        longitude: DRLongitude = 0,
        distanceError: DRDistance = 0,
        altitude: DRHeight = 0,
        altitudeError: DRHeight = 0
    ) -> DRLocation {
        let coordinate = DRLocationCoordinate(
            latitude: latitude,
            longitude: longitude,
            distanceError: distanceError
        )

        return DRLocation(
            coordinate: coordinate,
            altitude: DRMeasurement(altitude, error: altitudeError)
        )
    }

    static func getLoxodromeCompass(
        latitude: DRLatitude = 0,
        longitude: DRLongitude = 0,
        distanceError: DRDistance = 0,
        altitude: DRHeight = 0,
        altitudeError: DRHeight = 0,
        basedOn locationManager: DRLocationManager = TestLocationManager()
    ) -> DRLoxodromeCompass {
        let location = getLocation(
            latitude: latitude,
            longitude: longitude,
            distanceError: distanceError,
            altitude: altitude,
            altitudeError: altitudeError
        )

        return DRLoxodromeCompass(for: location, basedOn: locationManager)
    }

    static func getCompassToVladivostok(
        basedOn locationManager: DRLocationManager = TestLocationManager()
    ) -> DRLoxodromeCompass {
        getLoxodromeCompass(
            latitude: TestObjFactory.locationVladivostok.coordinate.latitude,
            longitude: TestObjFactory.locationVladivostok.coordinate.longitude,
            basedOn: locationManager
        )
    }

    static func getLocatorFromSanFrancisco() -> TestLocationManager {
        let locationManager = TestLocationManager()
        locationManager.location = locationSanFrancisco
        return locationManager
    }

    class TestLocationManager: DRLocationManager {
        @Published var location: DRLocation?

        var locationPublisher: Published<DRLocation?>.Publisher {
            $location
        }

        @Published var magneticHeading: DRMeasurement<DRDirection>?

        var magneticHeadingPublisher: Published<DRMeasurement<DRDirection>?>.Publisher {
            $magneticHeading
        }
    }
}
