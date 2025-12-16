import UIKit
import Combine

final class RegisterViewController: UIViewController {
    private let viewModel: RegisterViewModel
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
        view.layer.cornerRadius = 35
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
        label.text = "Create Account"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = AppColors.textPrimary
        label.textAlignment = .left
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Join us and start shopping"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = AppColors.textSecondary
        label.textAlignment = .left
        return label
    }()
    
    private lazy var firstNameTextField = ModernTextField(type: .name, placeholder: "First name")
    private lazy var lastNameTextField = ModernTextField(type: .name, placeholder: "Last name")
    private lazy var emailTextField = ModernTextField(type: .email, placeholder: "Email address")
    private lazy var passwordTextField = ModernTextField(type: .password, placeholder: "Password")
    private lazy var confirmPasswordTextField = ModernTextField(type: .password, placeholder: "Confirm password")
    
    private let registerButton = ModernButton(title: "Create Account", style: .primary)
    
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
    
    private let loginStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
    }()
    
    private let alreadyHaveAccountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Already have an account?"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = AppColors.textSecondary
        return label
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign In", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.setTitleColor(AppColors.primary, for: .normal)
        return button
    }()
    
    init(viewModel: RegisterViewModel) {
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
        contentView.addSubview(firstNameTextField)
        contentView.addSubview(lastNameTextField)
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(confirmPasswordTextField)
        contentView.addSubview(registerButton)
        contentView.addSubview(dividerView)
        contentView.addSubview(loginStackView)
        
        loginStackView.addArrangedSubview(alreadyHaveAccountLabel)
        loginStackView.addArrangedSubview(loginButton)
        
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
            
            logoContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            logoContainerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoContainerView.widthAnchor.constraint(equalToConstant: 70),
            logoContainerView.heightAnchor.constraint(equalToConstant: 70),
            
            logoImageView.centerXAnchor.constraint(equalTo: logoContainerView.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: logoContainerView.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 35),
            logoImageView.heightAnchor.constraint(equalToConstant: 35),
            
            titleLabel.topAnchor.constraint(equalTo: logoContainerView.bottomAnchor, constant: 28),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            
            firstNameTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 32),
            firstNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            firstNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            
            lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 16),
            lastNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            lastNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            
            emailTextField.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 16),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            
            registerButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 28),
            registerButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            registerButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            registerButton.heightAnchor.constraint(equalToConstant: 56),
            
            dividerView.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 28),
            dividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            dividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            dividerView.heightAnchor.constraint(equalToConstant: 20),
            
            loginStackView.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 28),
            loginStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            loginStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
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
    
    private func render(_ state: RegisterViewModel.State) {
        switch state {
        case .idle:
            updateLoadingState(isLoading: false)
        case .loading:
            updateLoadingState(isLoading: true)
        case .success(let authToken):
            updateLoadingState(isLoading: false)
            handleRegisterSuccess(authToken: authToken)
        case .error(let message):
            updateLoadingState(isLoading: false)
            showError(message: message)
        }
    }
    
    private func setupActions() {
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        firstNameTextField.textFieldDelegate = self
        lastNameTextField.textFieldDelegate = self
        emailTextField.textFieldDelegate = self
        passwordTextField.textFieldDelegate = self
        confirmPasswordTextField.textFieldDelegate = self
        
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
    
    @objc private func registerButtonTapped() {
        view.endEditing(true)
        
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let confirmPassword = confirmPasswordTextField.text ?? ""
        
        viewModel.register(
            email: email,
            password: password,
            confirmPassword: confirmPassword,
            firstName: firstName,
            lastName: lastName
        )
    }
    
    @objc private func loginButtonTapped() {
        coordinator?.showLogin()
    }
    
    private func updateLoadingState(isLoading: Bool) {
        registerButton.isLoading = isLoading
        firstNameTextField.textField.isEnabled = !isLoading
        lastNameTextField.textField.isEnabled = !isLoading
        emailTextField.textField.isEnabled = !isLoading
        passwordTextField.textField.isEnabled = !isLoading
        confirmPasswordTextField.textField.isEnabled = !isLoading
        loginButton.isEnabled = !isLoading
    }
    
    private func handleRegisterSuccess(authToken: AuthToken) {
        coordinator?.didFinishRegister()
    }
    
    private func showError(message: String) {
        showErrorToast(message: message)
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTextField.textField {
            lastNameTextField.becomeFirstResponder()
        } else if textField == lastNameTextField.textField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField.textField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField.textField {
            confirmPasswordTextField.becomeFirstResponder()
        } else if textField == confirmPasswordTextField.textField {
            textField.resignFirstResponder()
            registerButtonTapped()
        }
        return true
    }
}
