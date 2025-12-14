import UIKit

final class AuthCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var onDidFinishAuth: (() -> Void)?
    
    private let container: DependencyContainer
    
    init(navigationController: UINavigationController, container: DependencyContainer) {
        self.navigationController = navigationController
        self.container = container
        setupNavigationBarAppearance()
    }
    
    func start() {
        print("🔑 AuthCoordinator starting...")
        showLogin()
    }
    
    func showLogin() {
        print("👤 Creating login view model...")
        let viewModel = container.makeLoginViewModel()
        print("📱 Creating login view controller...")
        let loginVC = LoginViewController(viewModel: viewModel)
        loginVC.coordinator = self
        print("🎯 Setting login VC as root...")
        navigationController.setViewControllers([loginVC], animated: false)
        print("✅ Login VC set as root")
    }
    
    func showRegister() {
        let viewModel = container.makeRegisterViewModel()
        let registerVC = RegisterViewController(viewModel: viewModel)
        registerVC.coordinator = self
        navigationController.pushViewController(registerVC, animated: true)
    }
    
    func showPasswordReset() {
        let viewModel = container.makeForgotPasswordViewModel()
        let forgotPasswordVC = ForgotPasswordViewController(viewModel: viewModel)
        forgotPasswordVC.coordinator = self
        navigationController.pushViewController(forgotPasswordVC, animated: true)
    }
    
    func showResetPassword(email: String) {
        let viewModel = container.makeResetPasswordViewModel()
        let resetPasswordVC = ResetPasswordViewController(viewModel: viewModel, email: email)
        resetPasswordVC.coordinator = self
        navigationController.pushViewController(resetPasswordVC, animated: true)
    }
    
    func didFinishLogin() {
        onDidFinishAuth?()
    }
    
    func didFinishRegister() {
        onDidFinishAuth?()
    }
    
    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppColors.background
        appearance.titleTextAttributes = [.foregroundColor: AppColors.textPrimary]
        appearance.largeTitleTextAttributes = [.foregroundColor: AppColors.textPrimary]
        
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.compactAppearance = appearance
        navigationController.navigationBar.tintColor = AppColors.primary
    }
}
