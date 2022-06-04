//
//  TargetDB.swift
//  Dersu
//
//  Created by Danila on 04.06.2022.
//

import Foundation

/// Data base for targets
protocol DRTargetDB {

    /// Return and set the current user target
    var currentTarget: DRTargetData? { get set }

    /// Return all targets
    var targets: [DRTargetData] { get }

    /// Add the target
    func add(target: DRTargetData)

    /// Remove the target
    func remove(target: DRTargetData)

    /// Update the target name
    func update(target: DRTargetData, name: String)

    /// Update the target icon
    func update(target: DRTargetData, icon: String)

    /// Update the target destination
    func update(target: DRTargetData, destination: DRLocationData)

    /// Update the target updated date
    func update(target: DRTargetData, updated: Date)
}
