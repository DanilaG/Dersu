//
//  TestObjFactory.swift
//  DersuSharedTests
//
//  Created by Danila on 07.05.2022.
//

import Swinject

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

    static func getTarget(
        name: String = "Test",
        icon: String = "Test",
        id: UUID = UUID(),
        updated: Date = Date(),
        compass: DRCompass = TestObjFactory.getLoxodromeCompass()
    ) -> DRTarget {

        return DRTargetImpl(name: name, icon: icon, id: id, updated: updated, compass: compass)
    }

    static func getRepoWrappedTarget(
        initTarget: DRTarget = TestObjFactory.getTarget(),
        delegate: DRTargetRepoUpdateDelegate = TestTargetRepoUpdateDelegate()
    ) -> DRTargetRepoWrapper {
        DRTargetRepoWrapper(for: initTarget, delegate: delegate)
    }

    static func getRestrictedWrappedTarget(
        initTarget: DRTarget = TestObjFactory.getTarget(),
        delegate: DRTargetRestrictorDelegate = TestTargetRestrictorDelegate()
    ) -> DRRestrictedTarget {
        DRTargetRestrictorWrapper(for: initTarget, delegate: delegate)
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

    class TestTargetRepoUpdateDelegate: DRTargetRepoUpdateDelegate {

        var targetNameUpdate: (() -> Void)?
        func targetUpdate(_ target: DRTarget, name: String) {
            targetNameUpdate?()
        }

        var targetIconUpdate: (() -> Void)?
        func targetUpdate(_ target: DRTarget, icon: String) {
            targetIconUpdate?()
        }

        var targetDestinationUpdate: (() -> Void)?
        func targetUpdate(_ target: DRTarget, destination: DRLocation) {
            targetDestinationUpdate?()
        }
    }

    class TestTargetRestrictorDelegate: DRTargetRestrictorDelegate {

        var restrictedTargetCanChangeName: (() -> Bool)?
        func restrictedTargetCanChangeName(_ target: DRTarget) -> Bool {
            restrictedTargetCanChangeName?() ?? true
        }

        var restrictedTargetCanChangeIcon: (() -> Bool)?
        func restrictedTargetCanChangeIcon(_ target: DRTarget) -> Bool {
            restrictedTargetCanChangeIcon?() ?? true
        }

        var restrictedTargetCanChangeDestination: (() -> Bool)?
        func restrictedTargetCanChangeDestination(_ target: DRTarget) -> Bool {
            restrictedTargetCanChangeDestination?() ?? true
        }

        var restrictedTargetChangedName: (() -> Void)?
        func restrictedTargetChanged(_ target: DRTarget, name: String) {
            restrictedTargetChangedName?()
        }

        var restrictedTargetChangedIcon: (() -> Void)?
        func restrictedTargetChanged(_ target: DRTarget, icon: String) {
            restrictedTargetChangedIcon?()
        }

        var restrictedTargetChangedDestination: (() -> Void)?
        func restrictedTargetChanged(_ target: DRTarget, destination: DRLocation) {
            restrictedTargetChangedDestination?()
        }
    }

    // MARK: - Assembly
    class TestLocationManagerAssembly: Assembly {

        func assemble(container: Container) {
            container.register(DRLocationManager.self) { _ in
                TestLocationManager()
            }
        }

        init() {}
    }
}
