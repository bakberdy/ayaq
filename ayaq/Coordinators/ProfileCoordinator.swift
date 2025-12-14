import UIKit

class ProfileCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var onDidLogout: (() -> Void)?
    
    private let container: DependencyContainer
    
    init(navigationController: UINavigationController, container: DependencyContainer) {
        self.navigationController = navigationController
        self.container = container
    }
    
    func start() {
        let viewModel = container.makeProfileViewModel()
        let profileViewController = ProfileViewController(viewModel: viewModel)
        profileViewController.coordinator = self
        profileViewController.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        navigationController.setViewControllers([profileViewController], animated: false)
    }
    
    func showEditProfile(user: User) {
        guard let userId = TokenManager.shared.getUserId() else { return }
        let viewModel = container.makeEditProfileViewModel(userId: userId, currentUser: user)
        let editViewController = EditProfileViewController(viewModel: viewModel)
        editViewController.coordinator = self
        navigationController.pushViewController(editViewController, animated: true)
    }
    
    func didUpdateProfile() {
        navigationController.popViewController(animated: true)
    }
    
    func didCancelEdit() {
        navigationController.popViewController(animated: true)
    }
    
    func didLogout() {
        onDidLogout?()
    }
}
