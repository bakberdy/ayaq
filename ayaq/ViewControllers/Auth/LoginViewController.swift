import UIKit
import Combine

final class LoginViewController: UIViewController {
    private let viewModel: LoginViewModel
    weak var coordinator: AuthCoordinator?
    private var cancellables = Set<AnyCancellable>()
    
    private let scrollView = UIScrollView.createAuthScrollView()
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let logoImageView = UIImageView.createAuthIconImageView(systemName: "cart.fill")
    private let titleLabel = UILabel.createAuthTitleLabel(text: "Welcome Back")
    private let subtitleLabel = UILabel.createAuthSubtitleLabel(text: "Login to your account")
    private let emailTextField = UITextField.createAuthTextField(placeholder: "Email", keyboardType: .emailAddress)
    private let passwordTextField = UITextField.createAuthTextField(placeholder: "Password", isSecure: true, returnKeyType: .done)
    private let forgotPasswordButton = UIButton.createAuthTextButton(title: "Forgot Password?")
    private let loginButton = UIButton.createAuthPrimaryButton(title: "Login")
    private let activityIndicator = UIActivityIndicatorView.createAuthLoadingIndicator()
    private let registerStackView = UIStackView.createAuthHorizontalStack()
    private let dontHaveAccountLabel = UILabel.createAuthSecondaryLabel(text: "Don't have an account?")
    private let registerButton = UIButton.createAuthTextButton(title: "Register")
    
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
        setupKeyboardObservers()
    }
    
    private func setupUI() {
        title = "Login"
        setupAuthUI(scrollView: scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(logoImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(forgotPasswordButton)
        contentView.addSubview(loginButton)
        contentView.addSubview(activityIndicator)
        contentView.addSubview(registerStackView)
        
        registerStackView.addArrangedSubview(dontHaveAccountLabel)
        registerStackView.addArrangedSubview(registerButton)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            emailTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            emailTextField.heightAnchor.constraint(equalToConstant: 48),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            passwordTextField.heightAnchor.constraint(equalToConstant: 48),
            
            forgotPasswordButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 12),
            forgotPasswordButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            loginButton.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 24),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            loginButton.heightAnchor.constraint(equalToConstant: 52),
            
            activityIndicator.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor),
            
            registerStackView.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 24),
            registerStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            registerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
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
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        hideKeyboardWhenTappedAround()
    }
    
    private func setupKeyboardObservers() {
        // TODO: Keyboard observers are handled in AuthUIHelpers.setupAuthKeyboardHandling
    }
    
    @objc private func loginButtonTapped() {
        dismissKeyboard()
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
        if isLoading {
            activityIndicator.startAnimating()
            loginButton.setTitle("", for: .normal)
            loginButton.isEnabled = false
            emailTextField.isEnabled = false
            passwordTextField.isEnabled = false
        } else {
            activityIndicator.stopAnimating()
            loginButton.setTitle("Login", for: .normal)
            loginButton.isEnabled = true
            emailTextField.isEnabled = true
            passwordTextField.isEnabled = true
        }
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
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            loginButtonTapped()
        }
        return true
    }
}
