//
//  AppCoordinator.swift
//  ayaq
//
//  Created on 14/12/2025.
//

import UIKit

class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private var window: UIWindow
    private var tabBarController: MainTabBarController?
    private var authCoordinator: AuthCoordinator?
    private let container: DependencyContainer
    private let tokenManager: TokenManager
    
    init(window: UIWindow, container: DependencyContainer) {
        self.window = window
        self.navigationController = UINavigationController()
        self.container = container
        self.tokenManager = TokenManager.shared
    }
    
    func start() {
        print("🚀 AppCoordinator starting...")
        print("📱 Has token: \(tokenManager.hasToken())")
        
        if tokenManager.hasToken() {
            print("✅ Showing main app")
            showMainApp()
        } else {
            print("🔐 Showing auth")
            showAuth()
        }
    }
    
    private func showAuth() {
        print("🔐 Setting up auth flow...")
        let authNavController = UINavigationController()
        print("📱 Created auth nav controller: \(authNavController)")
        
        let authCoordinator = AuthCoordinator(
            navigationController: authNavController,
            container: container
        )
        self.authCoordinator = authCoordinator
        
        authCoordinator.onDidFinishAuth = { [weak self] in
            self?.authCoordinator = nil
            self?.showMainApp()
        }
        
        addChildCoordinator(authCoordinator)
        print("▶️ Starting auth coordinator...")
        authCoordinator.start()
        
        print("🪟 Setting window root view controller...")
        window.rootViewController = authNavController
        window.makeKeyAndVisible()
        print("✅ Window is key and visible")
    }
    
    private func showMainApp() {
        let tabBarController = MainTabBarController()
        self.tabBarController = tabBarController
        
        let homeCoordinator = HomeCoordinator(
            navigationController: UINavigationController(),
            container: container
        )
        let catalogCoordinator = CatalogCoordinator(
            navigationController: UINavigationController(),
            container: container
        )
        let cartCoordinator = CartCoordinator(
            navigationController: UINavigationController(),
            container: container
        )
        let profileCoordinator = ProfileCoordinator(
            navigationController: UINavigationController(),
            container: container
        )
        
        profileCoordinator.onDidLogout = { [weak self] in
            self?.handleLogout()
        }
        
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
    
    private func handleLogout() {
        childCoordinators.removeAll()
        tabBarController = nil
        showAuth()
    }
}
