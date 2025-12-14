//
//  CartCoordinator.swift
//  ayaq
//
//  Created on 14/12/2025.
//

import UIKit

class CartCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let container: DependencyContainer
    
    init(navigationController: UINavigationController, container: DependencyContainer) {
        self.navigationController = navigationController
        self.container = container
    }
    
    func start() {
        let cartViewController = CartViewController()
        cartViewController.tabBarItem = UITabBarItem(
            title: "Cart",
            image: UIImage(systemName: "cart"),
            selectedImage: UIImage(systemName: "cart.fill")
        )
        navigationController.setViewControllers([cartViewController], animated: false)
    }
}
