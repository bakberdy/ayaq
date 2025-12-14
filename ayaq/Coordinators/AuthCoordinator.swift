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
        let alert = UIAlertController(
            title: "Success",
            message: "Your account has been created successfully. Please login to continue.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.showLogin()
        })
        navigationController.present(alert, animated: true)
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
