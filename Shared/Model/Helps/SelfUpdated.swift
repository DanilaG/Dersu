//
//  SelfUpdated.swift
//  Dersu
//
//  Created by Danila on 07.05.2022.
//

import Combine

/// The protocol for self updated objects
protocol DRSelfUpdated {

    /// Callback on self updates
    var onUpdated: (() -> Void)? { get set }
}
