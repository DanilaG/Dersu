//
//  LoxodromeCompassTests.swift
//  DersuSharedTests
//
//  Created by Danila on 25.04.2022.
//

import XCTest
import Combine

class LoxodromeCompassTests: XCTestCase {
    var cancellable = Set<AnyCancellable>()
}

// MARK: - Calculations

extension LoxodromeCompassTests {
    // MARK: - Distance

    func testWhenDestinationEqualLocationExpectedDistance0() throws {
        let locationManager = TestObjFactory.TestLocationManager()
        locationManager.location = TestObjFactory.getLocation(latitude: 1, longitude: 1.234)

        let compass = TestObjFactory.getLoxodromeCompass(latitude: 1, longitude: 1.234, basedOn: locationManager)

        XCTAssertEqual(compass.distance?.value, 0, "Not 0 distance for the same locations")
    }

    func testWhenDestinationNotEqualLocationExpectedCorrectDistance() throws {
        let locationManager = TestObjFactory.getLocatorFromSanFrancisco()
        let compass = TestObjFactory.getCompassToVladivostok(basedOn: locationManager)

        guard let result = compass.distance?.value else {
            XCTFail("No distances")
            return
        }
        XCTAssertEqual(result, 8954000.0, accuracy: 1000, "Incorrect calculation of distances")
    }

    func testWhenLocationsError0ExpectedDistanceError0() throws {
        let locationManager = TestObjFactory.TestLocationManager()
        locationManager.location = TestObjFactory.getLocation(distanceError: 0)

        let compass = TestObjFactory.getLoxodromeCompass(distanceError: 0, basedOn: locationManager)

        XCTAssertEqual(compass.distance?.error, 0, "Not 0 distance error for accurate measurements")
    }

    func testWhenLocationsErrorNot0ExpectedDistanceError() throws {
        let locationManager = TestObjFactory.TestLocationManager()
        locationManager.location = TestObjFactory.getLocation(longitude: 1, distanceError: 10)

        let compass = TestObjFactory.getLoxodromeCompass(distanceError: 0.1, basedOn: locationManager)

        XCTAssertEqual(compass.distance?.error, 10.1, "Incorrect calculation of distances error")
    }

    func testWhenNoLocationExpectedNoDistance() throws {
        let locationManager = TestObjFactory.TestLocationManager()
        locationManager.location = nil

        let compass = TestObjFactory.getLoxodromeCompass(distanceError: 0.1, basedOn: locationManager)

        XCTAssertNil(compass.distance, "Has distance when no location")
    }

    // MARK: - Direction

    func testWhenDestinationEqualLocationExpectedNoDirection() throws {
        let locationManager = TestObjFactory.TestLocationManager()
        locationManager.location = TestObjFactory.getLocation(latitude: 1, longitude: 1.234)

        let compass = TestObjFactory.getLoxodromeCompass(latitude: 1, longitude: 1.234, basedOn: locationManager)

        XCTAssertNil(compass.direction, "Direction is exist on a same locations")
    }

    func testWhenDestinationNotEqualLocationExpectedDirection() throws {
        let locationManager = TestObjFactory.getLocatorFromSanFrancisco()
        locationManager.magneticHeading = DRMeasurement(0.5, error: 0)

        let compass = TestObjFactory.getCompassToVladivostok(basedOn: locationManager)

        guard let result = compass.direction?.value else {
            XCTFail("No direction")
            return
        }
        XCTAssertEqual(result, -1.5059433 - 0.5, accuracy: 0.0000001, "Incorrect calculation of direction")
    }

    func testWhenMagneticHeadingError0AndDistanceErrors0ExpectedDirectionError0() throws {
        let locationManager = TestObjFactory.TestLocationManager()
        locationManager.location = TestObjFactory.getLocation(latitude: 1, distanceError: 0)
        locationManager.magneticHeading = DRMeasurement(0.5, error: 0)

        let compass = TestObjFactory.getLoxodromeCompass(distanceError: 0, basedOn: locationManager)

        XCTAssertEqual(compass.direction?.error, 0, "Not 0 direction error for accurate measurements")
    }

    func testWhenMagneticHeadingErrorNot0AndDistanceErrorsNot0ExpectedDirectionError() throws {
        let locationManager = TestObjFactory.TestLocationManager()
        locationManager.location = TestObjFactory.getLocation(
            latitude: 55.752786,
            longitude: 48.741743,
            distanceError: 30
        )
        locationManager.magneticHeading = DRMeasurement(0, error: 1.2)

        let compass = TestObjFactory.getLoxodromeCompass(
            latitude: 55.745162,
            longitude: 48.770784,
            distanceError: 100,
            basedOn: locationManager
        )

        guard let error = compass.direction?.error else {
            XCTFail("No direction")
            return
        }
        XCTAssertEqual(error, 0.0610865 + 1.2, accuracy: 0.05, "Incorrect calculation of direction error")
    }

    func testWhenNoMagneticExpectedNoDirection() throws {
        let locationManager = TestObjFactory.TestLocationManager()
        locationManager.magneticHeading = nil

        let compass = TestObjFactory.getLoxodromeCompass(distanceError: 0.1, basedOn: locationManager)

        XCTAssertNil(compass.direction, "Has direction when no magnetic")
    }

    // MARK: - Height

    func testWhenLocationsHaveSameAltitudeExpectedHeight0() throws {
        let locationManager = TestObjFactory.TestLocationManager()
        locationManager.location = TestObjFactory.getLocation(altitude: 100.2)

        let compass = TestObjFactory.getLoxodromeCompass(altitude: 100.2, basedOn: locationManager)

        XCTAssertEqual(compass.height?.value, 0, "Height not 0 in the same altitude locations case")
    }

    func testWhenLocationsUpperExpectedHeightMoreThan0() throws {
        let locationManager = TestObjFactory.TestLocationManager()
        locationManager.location = TestObjFactory.getLocation(altitude: 1)

        let compass = TestObjFactory.getLoxodromeCompass(altitude: 100.2, basedOn: locationManager)

        XCTAssertEqual(compass.height?.value, 99.2, "Incorrect calculation of direction")
    }

    func testWhenLocationsLowerExpectedHeightLessThan0() throws {
        let locationManager = TestObjFactory.TestLocationManager()
        locationManager.location = TestObjFactory.getLocation(altitude: 1)

        let compass = TestObjFactory.getLoxodromeCompass(altitude: -1.2, basedOn: locationManager)

        XCTAssertEqual(compass.height?.value, -2.2, "Incorrect calculation of direction")
    }

    func testWhenLocationsAltitudeError0ExpectedHeightError0() throws {
        let locationManager = TestObjFactory.TestLocationManager()
        locationManager.location = TestObjFactory.getLocation(altitude: 1, altitudeError: 0)

        let compass = TestObjFactory.getLoxodromeCompass(altitude: 5, altitudeError: 0, basedOn: locationManager)

        XCTAssertEqual(compass.height?.error, 0, "Not 0 height error when 0 error altitudes")
    }

    func testWhenLocationsAltitudeErrorNot0ExpectedHeightErrorNot0() throws {
        let locationManager = TestObjFactory.TestLocationManager()
        locationManager.location = TestObjFactory.getLocation(altitude: 1, altitudeError: 0.2)

        let compass = TestObjFactory.getLoxodromeCompass(altitude: 5, altitudeError: 1, basedOn: locationManager)

        XCTAssertEqual(compass.height?.error, 1.2, "Incorrect height error calculation")
    }

    func testWhenNoLocationExpectedNoHeight() throws {
        let locationManager = TestObjFactory.TestLocationManager()
        locationManager.location = nil

        let compass = TestObjFactory.getLoxodromeCompass(distanceError: 0.1, basedOn: locationManager)

        XCTAssertNil(compass.height, "Has height when no location")
    }
}

// MARK: - Warnings and Errors

extension LoxodromeCompassTests {

    // MARK: - Warnings

    func testWhenLocationErrorMore30mExpectedGpsPoorAccuracyWarning() throws {
        let locationManager = TestObjFactory.TestLocationManager()
        locationManager.location = TestObjFactory.getLocation(distanceError: 30.1)

        let compass = TestObjFactory.getLoxodromeCompass(basedOn: locationManager)

        XCTAssertEqual(
            compass.warnings.first! as? DRLoxodromeCompass.Warning,
            .gpsAccuracyMore30m,
            "No gpsPoorAccuracy warning"
        )
    }

    func testWhenMagneticErrorMore2_0944ExpectedMagneticPoorAccuracyWarning() throws {
        let locationManager = TestObjFactory.TestLocationManager()
        locationManager.magneticHeading = DRMeasurement(0, error: 2.0945)

        let compass = TestObjFactory.getLoxodromeCompass(basedOn: locationManager)

        XCTAssertEqual(
            compass.warnings.first! as? DRLoxodromeCompass.Warning,
            .magneticAccuracyMorePiDiv3,
            "No magneticPoorAccuracy warning"
        )
    }

    func testWhenAltitudeErrorMore5mExpectedAltitudePoorAccuracyWarning() throws {
        let locationManager = TestObjFactory.TestLocationManager()
        locationManager.location = TestObjFactory.getLocation(altitudeError: 5.01)

        let compass = TestObjFactory.getLoxodromeCompass(basedOn: locationManager)

        XCTAssertEqual(
            compass.warnings.first! as? DRLoxodromeCompass.Warning,
            .altitudeAccuracyMore5m,
            "No altitudePoorAccuracy warning"
        )
    }

    // MARK: - Errors

    func testWhenNoLocationExpectedGpsNotWorking() throws {
        let locationManager = TestObjFactory.TestLocationManager()
        locationManager.location = nil

        let compass = TestObjFactory.getLoxodromeCompass(basedOn: locationManager)

        XCTAssertEqual(compass.error! as? DRLoxodromeCompass.Error, .gpsNotWorking, "No gpsNotWorking error")
    }

    func testWhenNoMagneticExpectedMagneticNotWorking() throws {
        let locationManager = TestObjFactory.TestLocationManager()
        locationManager.magneticHeading = nil
        locationManager.location = TestObjFactory.getLocation()

        let compass = TestObjFactory.getLoxodromeCompass(basedOn: locationManager)

        XCTAssertEqual(compass.error! as? DRLoxodromeCompass.Error, .magneticNotWorking, "No magneticNotWorking error")
    }

    func testWhenMagneticAndGpsErrorsAppearExpectedGpsError() throws {
        let locationManager = TestObjFactory.TestLocationManager()

        let compass = TestObjFactory.getLoxodromeCompass(basedOn: locationManager)
        locationManager.magneticHeading = nil
        locationManager.location = nil

        XCTAssertEqual(compass.error! as? DRLoxodromeCompass.Error, .gpsNotWorking, "Wrong priority of errors")
    }
}

// MARK: - Publishers

extension LoxodromeCompassTests {

    // MARK: - Publishers

    func testWhenDestinationChangedExpectedPublishing() throws {
        let compass = TestObjFactory.getLoxodromeCompass()

        let expectation = XCTestExpectation(description: "Didn't publish destination changes")
        compass.objectWillChange.sink {
            expectation.fulfill()
        }.store(in: &cancellable)

        compass.destination = TestObjFactory.getLocation(latitude: 1)

        wait(for: [expectation], timeout: 0.5)
    }

    func testWhenLocationManagerUpdatedLocationExpectedPublishing() throws {
        let locationManager = TestObjFactory.TestLocationManager()
        let compass = TestObjFactory.getLoxodromeCompass(basedOn: locationManager)

        let expectation = XCTestExpectation(description: "Didn't publish on location update")
        compass.objectWillChange.sink {
            expectation.fulfill()
        }.store(in: &cancellable)

        locationManager.location = TestObjFactory.getLocation(latitude: 1)

        wait(for: [expectation], timeout: 1)
    }

    func testWhenLocationManagerUpdatedMagneticHeadingExpectedPublishing() throws {
        let locationManager = TestObjFactory.TestLocationManager()
        let compass = TestObjFactory.getLoxodromeCompass(basedOn: locationManager)

        let expectation = XCTestExpectation(description: "Didn't publish on magneticHeading update")
        compass.objectWillChange.sink {
            expectation.fulfill()
        }.store(in: &cancellable)

        locationManager.magneticHeading = DRMeasurement(0.5, error: 1.1)

        wait(for: [expectation], timeout: 1)
    }
}
