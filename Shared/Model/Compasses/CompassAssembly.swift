//
//  CompassAssembly.swift
//  Dersu
//
//  Created by Danila on 23.05.2022.
//

import Swinject

final class DRCompassAssembly: Assembly {

    func assemble(container: Container) {
        container.register(DRCompass.self) { (resolver, destination: DRLocation) in
            let locationManager = resolver.resolve(DRLocationManager.self)
            let compass = DRLoxodromeCompass(for: destination, basedOn: locationManager!)

            return compass
        }
    }

    init() {}
}
