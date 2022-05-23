//
//  TargetBag.swift
//  Dersu
//
//  Created by Danila on 23.05.2022.
//

import Foundation

/// The storage for targets
protocol DRTargetBag {

    /// The target selected for navigation
    var currentTarget: DRTarget? { get set }

    /// All targets
    var targets: [DRTarget] { get }

    /// Create and add target to the targets
    /// The created target becomes current
    func createTargetWith(name: String, icon: String, destination: DRLocation) -> DRTarget

    /// Remove target if it stored
    func remove(target: DRTarget)
}
