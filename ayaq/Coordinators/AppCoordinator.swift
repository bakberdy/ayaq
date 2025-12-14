//
//  AppCoordinator.swift
//  ayaq
//
//  Created on 14/12/2025.
//

import UIKit

/// Main app coordinator that manages the entire app flow
class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private var window: UIWindow
    private var tabBarController: MainTabBarController?
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    func start() {
        // Create tab bar controller
        let tabBarController = MainTabBarController()
        self.tabBarController = tabBarController
        
        // Create coordinators for each tab
        let homeCoordinator = HomeCoordinator(navigationController: UINavigationController())
        let catalogCoordinator = CatalogCoordinator(navigationController: UINavigationController())
        let cartCoordinator = CartCoordinator(navigationController: UINavigationController())
        let profileCoordinator = ProfileCoordinator(navigationController: UINavigationController())
        
        // Add child coordinators
        addChildCoordinator(homeCoordinator)
        addChildCoordinator(catalogCoordinator)
        addChildCoordinator(cartCoordinator)
        addChildCoordinator(profileCoordinator)
        
        // Start each coordinator
        homeCoordinator.start()
        catalogCoordinator.start()
        cartCoordinator.start()
        profileCoordinator.start()
        
        // Set view controllers for tab bar
        tabBarController.viewControllers = [
            homeCoordinator.navigationController,
            catalogCoordinator.navigationController,
            cartCoordinator.navigationController,
            profileCoordinator.navigationController
        ]
        
        // Set tab bar as root view controller
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}
