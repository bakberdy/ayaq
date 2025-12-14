//
//  CartCoordinator.swift
//  ayaq
//
//  Created on 14/12/2025.
//

import UIKit

/// Coordinator for Cart flow
class CartCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
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
