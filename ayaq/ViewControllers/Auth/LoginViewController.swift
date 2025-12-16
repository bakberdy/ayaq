import UIKit
import Combine

final class LoginViewController: UIViewController {
    private let viewModel: LoginViewModel
    weak var coordinator: AuthCoordinator?
    private var cancellables = Set<AnyCancellable>()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .interactive
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let logoContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AppColors.primary.withAlphaComponent(0.1)
        view.layer.cornerRadius = 40
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = AppColors.primary
        imageView.image = UIImage(systemName: "bag.fill")
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Welcome Back"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = AppColors.textPrimary
        label.textAlignment = .left
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sign in to continue shopping"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = AppColors.textSecondary
        label.textAlignment = .left
        return label
    }()
    
    private lazy var emailTextField = ModernTextField(type: .email, placeholder: "Email address")
    private lazy var passwordTextField = ModernTextField(type: .password, placeholder: "Password")
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Forgot Password?", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(AppColors.primary, for: .normal)
        return button
    }()
    
    private let loginButton = ModernButton(title: "Sign In", style: .primary)
    
    private let dividerView: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let leftLine = UIView()
        leftLine.translatesAutoresizingMaskIntoConstraints = false
        leftLine.backgroundColor = AppColors.divider
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "OR"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = AppColors.textSecondary
        
        let rightLine = UIView()
        rightLine.translatesAutoresizingMaskIntoConstraints = false
        rightLine.backgroundColor = AppColors.divider
        
        container.addSubview(leftLine)
        container.addSubview(label)
        container.addSubview(rightLine)
        
        NSLayoutConstraint.activate([
            leftLine.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            leftLine.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            leftLine.heightAnchor.constraint(equalToConstant: 1),
            leftLine.trailingAnchor.constraint(equalTo: label.leadingAnchor, constant: -12),
            
            label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            rightLine.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 12),
            rightLine.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            rightLine.heightAnchor.constraint(equalToConstant: 1),
            rightLine.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
        
        return container
    }()
    
    private let registerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
    }()
    
    private let dontHaveAccountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Don't have an account?"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = AppColors.textSecondary
        return label
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.setTitleColor(AppColors.primary, for: .normal)
        return button
    }()
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupActions()
    }
    
    private func setupUI() {
        view.backgroundColor = AppColors.background
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        logoContainerView.addSubview(logoImageView)
        contentView.addSubview(logoContainerView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(forgotPasswordButton)
        contentView.addSubview(loginButton)
        contentView.addSubview(dividerView)
        contentView.addSubview(registerStackView)
        
        registerStackView.addArrangedSubview(dontHaveAccountLabel)
        registerStackView.addArrangedSubview(registerButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            logoContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
            logoContainerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoContainerView.widthAnchor.constraint(equalToConstant: 80),
            logoContainerView.heightAnchor.constraint(equalToConstant: 80),
            
            logoImageView.centerXAnchor.constraint(equalTo: logoContainerView.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: logoContainerView.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 40),
            logoImageView.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.topAnchor.constraint(equalTo: logoContainerView.bottomAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            
            emailTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            
            forgotPasswordButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            forgotPasswordButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            forgotPasswordButton.heightAnchor.constraint(equalToConstant: 32),
            
            loginButton.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 28),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            loginButton.heightAnchor.constraint(equalToConstant: 56),
            
            dividerView.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 32),
            dividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            dividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            dividerView.heightAnchor.constraint(equalToConstant: 20),
            
            registerStackView.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 32),
            registerStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            registerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
        
        setupKeyboardHandling()
    }
    
    private func setupBindings() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.render(state)
            }
            .store(in: &cancellables)
    }
    
    private func render(_ state: LoginViewModel.State) {
        switch state {
        case .idle:
            updateLoadingState(isLoading: false)
        case .loading:
            updateLoadingState(isLoading: true)
        case .success(let token):
            updateLoadingState(isLoading: false)
            handleLoginSuccess(token: token)
        case .error(let message):
            updateLoadingState(isLoading: false)
            showError(message: message)
        }
    }
    
    private func setupActions() {
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordButtonTapped), for: .touchUpInside)
        
        emailTextField.textFieldDelegate = self
        passwordTextField.textFieldDelegate = self
        
        hideKeyboardWhenTappedAround()
    }
    
    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.handleKeyboardWillShow(notification: notification)
        }
        
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.handleKeyboardWillHide()
        }
    }
    
    private func handleKeyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    private func handleKeyboardWillHide() {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    @objc private func loginButtonTapped() {
        view.endEditing(true)
        
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        viewModel.login(email: email, password: password)
    }
    
    @objc private func registerButtonTapped() {
        coordinator?.showRegister()
    }
    
    @objc private func forgotPasswordButtonTapped() {
        coordinator?.showPasswordReset()
    }
    
    private func updateLoadingState(isLoading: Bool) {
        loginButton.isLoading = isLoading
        emailTextField.textField.isEnabled = !isLoading
        passwordTextField.textField.isEnabled = !isLoading
        forgotPasswordButton.isEnabled = !isLoading
        registerButton.isEnabled = !isLoading
    }
    
    private func handleLoginSuccess(token: AuthToken) {
        coordinator?.didFinishLogin()
    }
    
    private func showError(message: String) {
        showErrorToast(message: message)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField.textField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField.textField {
            textField.resignFirstResponder()
            loginButtonTapped()
        }
        return true
    }
}
