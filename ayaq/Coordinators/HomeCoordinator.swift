//
//  HomeCoordinator.swift
//  ayaq
//
//  Created on 14/12/2025.
//

import UIKit

/// Coordinator for Home flow
class HomeCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let homeViewController = HomeViewController()
        homeViewController.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        navigationController.setViewControllers([homeViewController], animated: false)
    }
}
