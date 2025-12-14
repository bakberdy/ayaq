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
    private var authCoordinator: AuthCoordinator?
    private let tokenManager: TokenManager
    
    init(window: UIWindow, tokenManager: TokenManager = .shared) {
        self.window = window
        self.navigationController = UINavigationController()
        self.tokenManager = tokenManager
    }
    
    func start() {
        if tokenManager.hasToken() {
            showMainApp()
        } else {
            showAuth()
        }
    }
    
    private func showAuth() {
        let authNavController = UINavigationController()
        let authCoordinator = AuthCoordinator(navigationController: authNavController)
        self.authCoordinator = authCoordinator
        
        authCoordinator.onDidFinishAuth = { [weak self] in
            self?.authCoordinator = nil
            self?.showMainApp()
        }
        
        addChildCoordinator(authCoordinator)
        authCoordinator.start()
        
        window.rootViewController = authNavController
        window.makeKeyAndVisible()
    }
    
    private func showMainApp() {
        let tabBarController = MainTabBarController()
        self.tabBarController = tabBarController
        
        let homeCoordinator = HomeCoordinator(navigationController: UINavigationController())
        let catalogCoordinator = CatalogCoordinator(navigationController: UINavigationController())
        let cartCoordinator = CartCoordinator(navigationController: UINavigationController())
        let profileCoordinator = ProfileCoordinator(navigationController: UINavigationController())
        
        addChildCoordinator(homeCoordinator)
        addChildCoordinator(catalogCoordinator)
        addChildCoordinator(cartCoordinator)
        addChildCoordinator(profileCoordinator)
        
        homeCoordinator.start()
        catalogCoordinator.start()
        cartCoordinator.start()
        profileCoordinator.start()
        
        tabBarController.viewControllers = [
            homeCoordinator.navigationController,
            catalogCoordinator.navigationController,
            cartCoordinator.navigationController,
            profileCoordinator.navigationController
        ]
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}
