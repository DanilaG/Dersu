//
//  LocationDateTests.swift
//  DersuSharedTests
//
//  Created by Danila on 03.06.2022.
//

import XCTest

class LocationDateTests: XCTestCase {

    func testWhenGetLocationFromLocationDataExpectedRightLatitude() throws {
        let latitude: DRLatitude = 1.1
        let locationData = TestObjFactory.getLocationData(latitude: latitude)
        let location = locationData.toLocation()

        XCTAssertEqual(
            location.coordinate.latitude,
            latitude,
            "Wrong transformation location data to location: latitude"
        )
    }

    func testWhenGetLocationFromLocationDataExpectedRightLongitude() throws {
        let longitude: DRLongitude = 1.1
        let locationData = TestObjFactory.getLocationData(longitude: longitude)
        let location = locationData.toLocation()

        XCTAssertEqual(
            location.coordinate.longitude,
            longitude,
            "Wrong transformation location data to location: longitude"
        )
    }

    func testWhenGetLocationFromLocationDataExpectedRightDistanceError() throws {
        let distanceError: DRDistance = 1.1
        let locationData = TestObjFactory.getLocationData(distanceError: distanceError)
        let location = locationData.toLocation()

        XCTAssertEqual(
            location.coordinate.distanceError,
            distanceError,
            "Wrong transformation location data to location: distanceError"
        )
    }

    func testWhenGetLocationFromLocationDataExpectedRightAltitude() throws {
        let altitude: DRHeight = 1.1
        let locationData = TestObjFactory.getLocationData(altitude: altitude)
        let location = locationData.toLocation()

        XCTAssertEqual(
            location.altitude.value,
            altitude,
            "Wrong transformation location data to location: altitude"
        )
    }

    func testWhenGetLocationFromLocationDataExpectedRightAltitudeError() throws {
        let altitudeError: DRHeight = 1.1
        let locationData = TestObjFactory.getLocationData(altitudeError: altitudeError)
        let location = locationData.toLocation()

        XCTAssertEqual(
            location.altitude.error,
            altitudeError,
            "Wrong transformation location data to location: altitudeError"
        )
    }

    func testWhenGetLocationDataFromLocationExpectedRightLatitude() throws {
        let latitude: DRLatitude = 1.1
        let location = TestObjFactory.getLocation(latitude: latitude)
        let locationData = DRLocationData(from: location)

        XCTAssertEqual(
            locationData.latitude,
            latitude,
            "Wrong transformation location to location data: latitude"
        )
    }

    func testWhenGetLocationDataFromLocationExpectedRightLongitude() throws {
        let longitude: DRLongitude = 1.1
        let location = TestObjFactory.getLocation(longitude: longitude)
        let locationData = DRLocationData(from: location)

        XCTAssertEqual(
            locationData.longitude,
            longitude,
            "Wrong transformation location to location data: longitude"
        )
    }

    func testWhenGetLocationDataFromLocationExpectedRightDistanceError() throws {
        let distanceError: DRDistance = 1.1
        let location = TestObjFactory.getLocation(distanceError: distanceError)
        let locationData = DRLocationData(from: location)

        XCTAssertEqual(
            locationData.distanceError,
            distanceError,
            "Wrong transformation location to location data: distanceError"
        )
    }

    func testWhenGetLocationDataFromLocationExpectedRightAltitude() throws {
        let altitude: DRHeight = 1.1
        let location = TestObjFactory.getLocation(altitude: altitude)
        let locationData = DRLocationData(from: location)

        XCTAssertEqual(
            locationData.altitude,
            altitude,
            "Wrong transformation location to location data: altitude"
        )
    }

    func testWhenGetLocationDataFromLocationExpectedRightAltitudeError() throws {
        let altitudeError: DRHeight = 1.1
        let location = TestObjFactory.getLocation(altitudeError: altitudeError)
        let locationData = DRLocationData(from: location)

        XCTAssertEqual(
            locationData.altitudeError,
            altitudeError,
            "Wrong transformation location to location data: altitudeError"
        )
    }
}
