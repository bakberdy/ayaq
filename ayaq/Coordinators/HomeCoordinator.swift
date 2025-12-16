
import UIKit

class HomeCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let container: DependencyContainer
    
    init(navigationController: UINavigationController, container: DependencyContainer) {
        self.navigationController = navigationController
        self.container = container
    }
    
    func start() {
        let viewModel = container.makeHomeViewModel()
        let homeViewController = HomeViewController(viewModel: viewModel)
        
        homeViewController.onProductTapped = { [weak self] productId in
            self?.showProductDetail(productId: productId)
        }
        
        homeViewController.onCategoryTapped = { [weak self] productType in
            self?.showCategoryProducts(type: productType)
        }
        
        homeViewController.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        navigationController.setViewControllers([homeViewController], animated: false)
    }
    
    private func showProductDetail(productId: Int) {
        let viewModel = container.makeProductDetailViewModel(productId: productId)
        let viewController = ProductDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showCategoryProducts(type: ProductType) {
        let viewModel = container.makeProductListViewModel()
        viewModel.selectedTypes.insert(type.id)
        viewModel.applyFilters()
        
        let viewController = ProductListViewController(viewModel: viewModel)
        viewController.title = type.displayName
        
        viewController.onProductSelected = { [weak self] productId in
            self?.showProductDetail(productId: productId)
        }
        
        navigationController.pushViewController(viewController, animated: true)
    }
}
