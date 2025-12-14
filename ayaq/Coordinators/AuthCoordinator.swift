import UIKit

final class AuthCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var onDidFinishAuth: (() -> Void)?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        setupNavigationBarAppearance()
    }
    
    func start() {
        showLogin()
    }
    
    func showLogin() {
        let viewModel = LoginViewModel()
        let loginVC = LoginViewController(viewModel: viewModel)
        loginVC.coordinator = self
        navigationController.setViewControllers([loginVC], animated: true)
    }
    
    func showRegister() {
        let viewModel = RegisterViewModel()
        let registerVC = RegisterViewController(viewModel: viewModel)
        registerVC.coordinator = self
        navigationController.pushViewController(registerVC, animated: true)
    }
    
    func showPasswordReset() {
        let viewModel = ForgotPasswordViewModel()
        let forgotPasswordVC = ForgotPasswordViewController(viewModel: viewModel)
        forgotPasswordVC.coordinator = self
        navigationController.pushViewController(forgotPasswordVC, animated: true)
    }
    
    func showResetPassword(email: String) {
        let viewModel = ResetPasswordViewModel()
        let resetPasswordVC = ResetPasswordViewController(viewModel: viewModel, email: email)
        resetPasswordVC.coordinator = self
        navigationController.pushViewController(resetPasswordVC, animated: true)
    }
    
    func didFinishLogin() {
        onDidFinishAuth?()
    }
    
    func didFinishRegister() {
        if let topVC = navigationController.topViewController {
            topVC.showSuccessToast(message: "Account created successfully!")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
                self?.showLogin()
            }
        }
    }
    
    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.compactAppearance = appearance
        navigationController.navigationBar.tintColor = .systemBlue
    }
}
