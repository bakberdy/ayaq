import UIKit

final class RegisterViewController: UIViewController {
    private let viewModel: RegisterViewModel
    weak var coordinator: AuthCoordinator?
    
    private let scrollView = UIScrollView.createAuthScrollView()
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let titleLabel = UILabel.createAuthTitleLabel(text: "Create Account")
    private let subtitleLabel = UILabel.createAuthSubtitleLabel(text: "Sign up to get started")
    private let firstNameTextField = UITextField.createAuthTextField(placeholder: "First Name")
    private let lastNameTextField = UITextField.createAuthTextField(placeholder: "Last Name")
    private let emailTextField = UITextField.createAuthTextField(placeholder: "Email", keyboardType: .emailAddress)
    private let passwordTextField = UITextField.createAuthTextField(placeholder: "Password", isSecure: true)
    private let confirmPasswordTextField = UITextField.createAuthTextField(placeholder: "Confirm Password", isSecure: true, returnKeyType: .done)
    private let registerButton = UIButton.createAuthPrimaryButton(title: "Sign Up")
    private let activityIndicator = UIActivityIndicatorView.createAuthLoadingIndicator()
    private let loginStackView = UIStackView.createAuthHorizontalStack()
    private let alreadyHaveAccountLabel = UILabel.createAuthSecondaryLabel(text: "Already have an account?")
    private let loginButton = UIButton.createAuthTextButton(title: "Login")
    
    init(viewModel: RegisterViewModel = RegisterViewModel()) {
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
        setupKeyboardObservers()
    }
    
    private func setupUI() {
        title = "Register"
        setupAuthUI(scrollView: scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(firstNameTextField)
        contentView.addSubview(lastNameTextField)
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(confirmPasswordTextField)
        contentView.addSubview(registerButton)
        contentView.addSubview(activityIndicator)
        contentView.addSubview(loginStackView)
        
        loginStackView.addArrangedSubview(alreadyHaveAccountLabel)
        loginStackView.addArrangedSubview(loginButton)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            firstNameTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 32),
            firstNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            firstNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            firstNameTextField.heightAnchor.constraint(equalToConstant: 48),
            
            lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 16),
            lastNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            lastNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            lastNameTextField.heightAnchor.constraint(equalToConstant: 48),
            
            emailTextField.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 16),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            emailTextField.heightAnchor.constraint(equalToConstant: 48),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            passwordTextField.heightAnchor.constraint(equalToConstant: 48),
            
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 48),
            
            registerButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 24),
            registerButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            registerButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            registerButton.heightAnchor.constraint(equalToConstant: 52),
            
            activityIndicator.centerXAnchor.constraint(equalTo: registerButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: registerButton.centerYAnchor),
            
            loginStackView.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 24),
            loginStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            loginStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
    
    private func setupBindings() {
        viewModel.onRegisterSuccess = { [weak self] in
            self?.handleRegisterSuccess()
        }
        
        viewModel.onRegisterError = { [weak self] errorMessage in
            self?.showError(message: errorMessage)
        }
        
        viewModel.onLoadingStateChanged = { [weak self] isLoading in
            self?.updateLoadingState(isLoading: isLoading)
        }
    }
    
    private func setupActions() {
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        firstNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func setupKeyboardObservers() {
    }
    
    @objc private func registerButtonTapped() {
        dismissKeyboard()
        viewModel.register()
    }
    
    @objc private func loginButtonTapped() {
        coordinator?.showLogin()
    }
    
    @objc private func textFieldDidChange() {
        viewModel.firstName = firstNameTextField.text ?? ""
        viewModel.lastName = lastNameTextField.text ?? ""
        viewModel.email = emailTextField.text ?? ""
        viewModel.password = passwordTextField.text ?? ""
        viewModel.confirmPassword = confirmPasswordTextField.text ?? ""
    }
    
    private func updateLoadingState(isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
            registerButton.setTitle("", for: .normal)
            registerButton.isEnabled = false
            firstNameTextField.isEnabled = false
            lastNameTextField.isEnabled = false
            emailTextField.isEnabled = false
            passwordTextField.isEnabled = false
            confirmPasswordTextField.isEnabled = false
        } else {
            activityIndicator.stopAnimating()
            registerButton.setTitle("Sign Up", for: .normal)
            registerButton.isEnabled = true
            firstNameTextField.isEnabled = true
            lastNameTextField.isEnabled = true
            emailTextField.isEnabled = true
            passwordTextField.isEnabled = true
            confirmPasswordTextField.isEnabled = true
        }
    }
    
    private func handleRegisterSuccess() {
        coordinator?.didFinishRegister()
    }
    
    private func showError(message: String) {
        showErrorToast(message: message)
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()
        } else if textField == lastNameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            confirmPasswordTextField.becomeFirstResponder()
        } else if textField == confirmPasswordTextField {
            textField.resignFirstResponder()
            registerButtonTapped()
        }
        return true
    }
}
