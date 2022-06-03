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

    static var assembler = Assembler([
        DRTargetAssembly(),
        DRCompassAssembly(),
        TestObjFactory.TestLocationManagerAssembly()
    ])

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
        DRTargetImpl(name: name, icon: icon, id: id, updated: updated, compass: compass)
    }

    static func getTarget(
        name: String = "Test",
        icon: String = "Test",
        id: UUID = UUID(),
        updated: Date = Date(),
        destination: DRLocation
    ) -> DRTarget {
        let compass = TestObjFactory.getLoxodromeCompass(
            latitude: destination.coordinate.latitude,
            longitude: destination.coordinate.longitude,
            distanceError: destination.coordinate.distanceError,
            altitude: destination.altitude.value,
            altitudeError: destination.altitude.error
        )
        return TestObjFactory.getTarget(name: name, icon: icon, id: id, updated: updated, compass: compass)
    }

    static func getRepoWrappedTarget(
        initTarget: DRTarget = TestObjFactory.getTarget(),
        delegate: DRTargetRepoUpdateDelegate = TestRepoUpdateDelegate()
    ) -> DRTargetRepoWrapper {
        DRTargetRepoWrapper(for: initTarget, delegate: delegate)
    }

    static func getRestrictedWrappedTarget(
        initTarget: DRTarget = TestObjFactory.getTarget(),
        delegate: DRTargetRestrictorDelegate = TestTargetRestrictorDelegate()
    ) -> DRRestrictedTarget {
        DRTargetRestrictorWrapper(for: initTarget, delegate: delegate)
    }

    static func getTargetBag(
        assembler: Assembler = assembler
    ) -> DRTargetBag {
        DRTargetBagImpl(assembler)
    }

    static func getTargetBagRepoWrapper(
        initialTargetBag: DRTargetBag = TestObjFactory.getTargetBag(),
        delegate: DRRepoUpdateDelegate = TestRepoUpdateDelegate()
    ) -> DRTargetBagRepoWrapper {
        DRTargetBagRepoWrapper(for: initialTargetBag, delegate: delegate)
    }

    static func getLocationData(
        latitude: Double = 0.0,
        longitude: Double = 0.0,
        distanceError: Double = 0.0,
        altitude: Double = 0.0,
        altitudeError: Double = 0.0
    ) -> DRLocationData {
        DRLocationData(
            latitude: latitude,
            longitude: longitude,
            distanceError: distanceError,
            altitude: altitude,
            altitudeError: altitudeError
        )
    }

    static func getTargetData(
        name: String = "Test",
        icon: String = "Test",
        id: UUID = UUID(),
        updated: Date = Date(),
        destination: DRLocationData = TestObjFactory.getLocationData()
    ) -> DRTargetData {
        DRTargetData(
            name: name,
            icon: icon,
            id: id,
            updated: updated,
            destination: destination
        )
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

    class TestRepoUpdateDelegate: DRRepoUpdateDelegate {
        var currentTargetSet: ((DRTarget?) -> Void)?
        var currentTarget: DRTarget? {
            didSet {
                currentTargetSet?(currentTarget)
            }
        }

        var getTargetsHandler: (() -> [DRTarget])?
        func getTargets() -> [DRTarget] {
            getTargetsHandler?() ?? []
        }

        var addTargetHandler: ((DRTarget, DRTargetRepoUpdatedDelegate?) -> Void)?
        func add(target: DRTarget, with delegate: DRTargetRepoUpdatedDelegate? = nil) {
            addTargetHandler?(target, delegate)
        }

        var removeTargetHandler: ((DRTarget) -> Void)?
        func remove(target: DRTarget) {
            removeTargetHandler?(target)
        }

        var targetNameUpdateHandler: ((DRTarget, String) -> Void)?
        func targetUpdate(_ target: DRTarget, name: String) {
            targetNameUpdateHandler?(target, name)
        }

        var targetIconUpdateHandler: ((DRTarget, String) -> Void)?
        func targetUpdate(_ target: DRTarget, icon: String) {
            targetIconUpdateHandler?(target, icon)
        }

        var targetDestinationUpdate: ((DRTarget, DRLocation) -> Void)?
        func targetUpdate(_ target: DRTarget, destination: DRLocation) {
            targetDestinationUpdate?(target, destination)
        }

        var targetUpdatedUpdate: ((DRTarget, Date) -> Void)?
        func targetUpdate(_ target: DRTarget, updated: Date) {
            targetUpdatedUpdate?(target, updated)
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
