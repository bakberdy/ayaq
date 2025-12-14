//
//  ProfileCoordinator.swift
//  ayaq
//
//  Created on 14/12/2025.
//

import UIKit

class ProfileCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var onDidLogout: (() -> Void)?
    
    private let container: DependencyContainer
    
    init(navigationController: UINavigationController, container: DependencyContainer) {
        self.navigationController = navigationController
        self.container = container
    }
    
    func start() {
        let profileViewController = ProfileViewController()
        profileViewController.coordinator = self
        profileViewController.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        navigationController.setViewControllers([profileViewController], animated: false)
    }
    
    func didLogout() {
        onDidLogout?()
    }
}
