//
//  LoxodromeCompass.swift
//  Dersu
//
//  Created by Danila on 07.05.2022.
//

import Foundation
import Combine

/// The compass based on loxodrome lines
class DRLoxodromeCompass: DRCompass {

    var destination: DRLocation {
        didSet { onUpdated?() }
    }

    var location: DRLocation? {
        locationManager.location
    }

    var distance: DRMeasurement<DRDistance>? {
        guard let location = locationManager.location else { return nil }

        return distance(from: location, to: destination)
    }

    var direction: DRMeasurement<DRDirection>? {
        guard let location = locationManager.location else { return nil }
        guard let magnetic = locationManager.magneticHeading else { return nil }
        guard location.coordinate.latitude != destination.coordinate.latitude ||
              location.coordinate.longitude != destination.coordinate.longitude else { return nil }

        let bearing = bearing(from: location, to: destination)

        return DRMeasurement(bearing.value - magnetic.value, error: bearing.error + magnetic.error)
    }

    var height: DRMeasurement<DRHeight>? {
        guard let location = locationManager.location else { return nil }

        return heading(from: location, to: destination)
    }

    private(set) var warnings: [DRCompassWarning] = []

    private(set) var error: DRCompassError?

    var onUpdated: (() -> Void)?

    fileprivate var locationManager: DRLocationManager

    private var publisherStorage = Set<AnyCancellable>()

    init(for destination: DRLocation, basedOn locationManager: DRLocationManager) {
        self.destination = destination
        self.locationManager = locationManager

        connectPublishers()

        updateError()
        updateWarnings()
    }

    // MARK: Data types

    /// The warnings of DRLoxodromeCompass
    enum Warning: DRCompassWarning {
        case gpsAccuracyMore30m
        case magneticAccuracyMorePiDiv3
        case altitudeAccuracyMore5m
    }

    /// The errors of DRLoxodromeCompass
    enum Error: DRCompassError {
        case gpsNotWorking
        case magneticNotWorking
    }

    // MARK: Warnings and error update

    fileprivate func updateError() {
        error = DRLoxodromeCompass.Error.allCases.first(where: { [weak self] in
            guard let strongSelf = self else { return false }

            return $0.isActive(for: strongSelf.locationManager)
        })
    }

    fileprivate func updateWarnings() {
        self.warnings = DRLoxodromeCompass.Warning.allCases.filter { [weak self] in
            guard let strongSelf = self else { return false }

            return $0.isActive(for: strongSelf.locationManager)
        }
    }
}

/// Provide information about current user location
protocol DRLocationManager {

    /// The user location
    var location: DRLocation? { get }

    /// The publisher of user location update
    var locationPublisher: Published<DRLocation?>.Publisher { get }

    /// The user direction in radians in clockwise
    var magneticHeading: DRMeasurement<DRDirection>? { get }

    /// The publisher of user location update
    var magneticHeadingPublisher: Published<DRMeasurement<DRDirection>?>.Publisher { get }
}

// MARK: - Math
// According to: https://www.movable-type.co.uk/scripts/latlong.html

extension DRLoxodromeCompass {
    private var earthRadius: DRDistance { 6371e3 }

    private func distance(from firstLocation: DRLocation, to secondLocation: DRLocation) -> DRMeasurement<DRDistance> {
        let lat1 = toRadians(firstLocation.coordinate.latitude)
        let lat2 = toRadians(secondLocation.coordinate.latitude)
        let lon1 = toRadians(firstLocation.coordinate.longitude)
        let lon2 = toRadians(secondLocation.coordinate.longitude)
        let deltaLat = lat2 - lat1
        var deltaLon = lon2 - lon1

        let deltaF = log(tan(.pi / 4 + lat2 / 2) / tan(.pi / 4 + lat1 / 2))
        let constQ = abs(deltaF) > 10e-12 ? deltaLat / deltaF : cos(lat1)

        if abs(deltaLon) > Double.pi {
            deltaLon = deltaLon > 0 ? -(2 * .pi - deltaLon) : (2 * .pi + deltaLon)
        }

        let dist = sqrt(deltaLat * deltaLat + constQ * constQ * deltaLon * deltaLon) * earthRadius
        let error = firstLocation.coordinate.distanceError + secondLocation.coordinate.distanceError

        return DRMeasurement(dist, error: error)
    }

    private func bearing(
        from currentLocation: DRLocation,
        to destinationLocation: DRLocation
    ) -> DRMeasurement<DRDirection> {
        let lat1 = toRadians(currentLocation.coordinate.latitude)
        let lat2 = toRadians(destinationLocation.coordinate.latitude)
        let lon1 = toRadians(currentLocation.coordinate.longitude)
        let lon2 = toRadians(destinationLocation.coordinate.longitude)
        var deltaLon = lon2 - lon1

        let deltaF = log(tan(.pi / 4 + lat2 / 2) / tan(.pi / 4 + lat1 / 2))

        if abs(deltaLon) > Double.pi {
            deltaLon = deltaLon > 0 ? -(2 * .pi - deltaLon) : (2 * .pi + deltaLon)
        }

        let bearing = atan2(deltaLon, deltaF)

        let distance = distance(from: currentLocation, to: destinationLocation)
        let error = atan2(distance.error, distance.value)

        return DRMeasurement(bearing, error: error)
    }

    private func heading(from firstLocation: DRLocation, to secondLocation: DRLocation) -> DRMeasurement<DRHeight> {
        let height = secondLocation.altitude.value - firstLocation.altitude.value
        let error = firstLocation.altitude.error + secondLocation.altitude.error

        return DRMeasurement(height, error: error)
    }

    private func toRadians(_ degrees: Double) -> Double {
        degrees * .pi / 180
    }
}

// MARK: - Warnings and errors checkers

extension DRLoxodromeCompass.Error: CaseIterable {
    fileprivate func isActive(for locationManager: DRLocationManager) -> Bool {
        switch self {
        case .gpsNotWorking:
            return locationManager.location == nil
        case .magneticNotWorking:
            return locationManager.magneticHeading == nil
        }
    }
}

extension DRLoxodromeCompass.Warning: CaseIterable {
    fileprivate func isActive(for locationManager: DRLocationManager) -> Bool {
        switch self {
        case .gpsAccuracyMore30m:
            guard let location = locationManager.location else { return false }
            return location.coordinate.distanceError > 30
        case .magneticAccuracyMorePiDiv3:
            guard let magnetic = locationManager.magneticHeading else { return false }
            return magnetic.error > 2 * .pi / 3
        case .altitudeAccuracyMore5m:
            guard let location = locationManager.location else { return false }
            return location.altitude.error > 5
        }
    }
}

// MARK: - Publishers

extension DRLoxodromeCompass {
    private func connectPublishers() {
        setLocationPublisher()
        setMagneticHeadingPublisher()
    }

    private func setLocationPublisher() {
        self.locationManager.locationPublisher
            .sink { [weak self] _ in
                self?.updateError()
                self?.updateWarnings()
                self?.onUpdated?()
            }
            .store(in: &publisherStorage)
    }

    private func setMagneticHeadingPublisher() {
        self.locationManager.magneticHeadingPublisher
            .sink { [weak self] _ in
                self?.updateError()
                self?.updateWarnings()
                self?.onUpdated?()
            }
            .store(in: &publisherStorage)
    }
}
