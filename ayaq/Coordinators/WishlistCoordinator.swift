import UIKit

final class WishlistCoordinator: Coordinator {
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
        
        let viewModel = container.makeWishlistViewModel(userId: userId)
        let wishlistViewController = WishlistViewController(viewModel: viewModel)
        
        wishlistViewController.onProductSelected = { [weak self] productId in
            self?.showProductDetail(productId: productId)
        }
        
        wishlistViewController.onContinueShopping = { [weak self] in
            self?.showCatalog()
        }
        
        wishlistViewController.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )
        
        navigationController.setViewControllers([wishlistViewController], animated: false)
    }
    
    private func showProductDetail(productId: Int) {
        let viewModel = container.makeProductDetailViewModel(productId: productId)
        let productDetailVC = ProductDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(productDetailVC, animated: true)
    }
    
    private func showCatalog() {
        guard let tabBarController = navigationController.tabBarController else { return }
        tabBarController.selectedIndex = 1
    }
    
    private func showLoginRequired() {
        let alert = UIAlertController(
            title: "Login Required",
            message: "Please log in to view your wishlist",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        navigationController.present(alert, animated: true)
    }
}
