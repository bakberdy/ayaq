//
//  CatalogCoordinator.swift
//  ayaq
//
//  Created on 14/12/2025.
//

import UIKit

class CatalogCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let container: DependencyContainer
    
    init(navigationController: UINavigationController, container: DependencyContainer) {
        self.navigationController = navigationController
        self.container = container
    }
    
    func start() {
        let catalogViewController = CatalogViewController()
        catalogViewController.tabBarItem = UITabBarItem(
            title: "Catalog",
            image: UIImage(systemName: "square.grid.2x2"),
            selectedImage: UIImage(systemName: "square.grid.2x2.fill")
        )
        navigationController.setViewControllers([catalogViewController], animated: false)
    }
}
