
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
        showProductList()
    }
    
    private func showProductList() {
        let viewModel = container.makeProductListViewModel()
        let viewController = ProductListViewController(viewModel: viewModel)
        
        viewController.onProductSelected = { [weak self] productId in
            self?.showProductDetail(productId: productId)
        }
        
        viewController.tabBarItem = UITabBarItem(
            title: "Catalog",
            image: UIImage(systemName: "square.grid.2x2"),
            selectedImage: UIImage(systemName: "square.grid.2x2.fill")
        )
        
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    private func showProductDetail(productId: Int) {
        let viewModel = container.makeProductDetailViewModel(productId: productId)
        let viewController = ProductDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
