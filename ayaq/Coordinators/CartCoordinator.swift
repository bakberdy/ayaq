import UIKit

final class CartCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let container: DependencyContainer
    
    init(navigationController: UINavigationController, container: DependencyContainer) {
        self.navigationController = navigationController
        self.container = container
    }
    
    func start() {
        guard let userId = TokenManager.shared.getUserId() else {
            showLoginRequired()
            return
        }
        
        let viewModel = container.makeCartViewModel(userId: userId)
        let cartViewController = CartViewController(viewModel: viewModel)
        
        cartViewController.onCheckout = { [weak self] in
            self?.showCheckout()
        }
        
        cartViewController.onContinueShopping = { [weak self] in
            self?.showCatalog()
        }
        
        cartViewController.tabBarItem = UITabBarItem(
            title: "Cart",
            image: UIImage(systemName: "cart"),
            selectedImage: UIImage(systemName: "cart.fill")
        )
        
        navigationController.setViewControllers([cartViewController], animated: false)
    }
    
    private func showLoginRequired() {
        let alert = UIAlertController(
            title: "Login Required",
            message: "Please log in to view your cart",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        navigationController.present(alert, animated: true)
    }
    
    private func showCheckout() {
    }
    
    private func showCatalog() {
        guard let tabBarController = navigationController.tabBarController else { return }
        tabBarController.selectedIndex = 0
    }
}
