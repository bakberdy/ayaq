//
//  Coordinator.swift
//  ayaq
//
//  Created on 14/12/2025.
//

import UIKit

/// Base protocol for all coordinators in the app
protocol Coordinator: AnyObject {
    /// Child coordinators managed by this coordinator
    var childCoordinators: [Coordinator] { get set }
    
    /// Navigation controller used by the coordinator
    var navigationController: UINavigationController { get set }
    
    /// Starts the coordinator's flow
    func start()
}

extension Coordinator {
    /// Adds a child coordinator to the parent
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    /// Removes a child coordinator from the parent
    func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}
