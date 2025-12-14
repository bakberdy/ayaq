//
//  ProfileCoordinator.swift
//  ayaq
//
//  Created on 14/12/2025.
//

import UIKit

/// Coordinator for Profile flow
class ProfileCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        navigationController.setViewControllers([profileViewController], animated: false)
    }
}
