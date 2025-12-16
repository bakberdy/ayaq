import UIKit
import Combine

final class ForgotPasswordViewController: UIViewController {
    private let viewModel: ForgotPasswordViewModel
    weak var coordinator: AuthCoordinator?
    private var cancellables = Set<AnyCancellable>()
    
    private let scrollView = UIScrollView.createAuthScrollView()
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let iconImageView = UIImageView.createAuthIconImageView(systemName: "lock.rotation")
    private let titleLabel = UILabel.createAuthTitleLabel(text: "Forgot Password?")
    private let subtitleLabel = UILabel.createAuthSubtitleLabel(text: "Enter your email to receive a reset code")
    private let emailTextField = UITextField.createAuthTextField(placeholder: "Email", keyboardType: .emailAddress, returnKeyType: .done)
    private let sendCodeButton = UIButton.createAuthPrimaryButton(title: "Send Reset Code")
    private let activityIndicator = UIActivityIndicatorView.createAuthLoadingIndicator()
    private let backToLoginButton = UIButton.createAuthTextButton(title: "Back to Login")
    
    init(viewModel: ForgotPasswordViewModel) {
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
        title = "Forgot Password"
        setupAuthUI(scrollView: scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(emailTextField)
        contentView.addSubview(sendCodeButton)
        contentView.addSubview(activityIndicator)
        contentView.addSubview(backToLoginButton)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60),
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 80),
            iconImageView.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            emailTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            emailTextField.heightAnchor.constraint(equalToConstant: 48),
            
            sendCodeButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 24),
            sendCodeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            sendCodeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            sendCodeButton.heightAnchor.constraint(equalToConstant: 52),
            
            activityIndicator.centerXAnchor.constraint(equalTo: sendCodeButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: sendCodeButton.centerYAnchor),
            
            backToLoginButton.topAnchor.constraint(equalTo: sendCodeButton.bottomAnchor, constant: 24),
            backToLoginButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            backToLoginButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
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
    
    private func render(_ state: ForgotPasswordViewModel.State) {
        switch state {
        case .idle:
            updateLoadingState(isLoading: false)
        case .loading:
            updateLoadingState(isLoading: true)
        case .success(let email):
            updateLoadingState(isLoading: false)
            coordinator?.showResetPassword(email: email)
        case .error(let message):
            updateLoadingState(isLoading: false)
            showError(message: message)
        }
    }
    
    private func setupActions() {
        sendCodeButton.addTarget(self, action: #selector(sendCodeButtonTapped), for: .touchUpInside)
        backToLoginButton.addTarget(self, action: #selector(backToLoginButtonTapped), for: .touchUpInside)
        
        emailTextField.delegate = self
    }
    
    private func setupKeyboardObservers() {
    }
    
    @objc private func sendCodeButtonTapped() {
        dismissKeyboard()
        let email = emailTextField.text ?? ""
        viewModel.requestPasswordReset(email: email)
    }
    
    @objc private func backToLoginButtonTapped() {
        coordinator?.showLogin()
    }
    
    private func updateLoadingState(isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
            sendCodeButton.setTitle("", for: .normal)
            sendCodeButton.isEnabled = false
            emailTextField.isEnabled = false
        } else {
            activityIndicator.stopAnimating()
            sendCodeButton.setTitle("Send Reset Code", for: .normal)
            sendCodeButton.isEnabled = true
            emailTextField.isEnabled = true
        }
    }
    
    private func showError(message: String) {
        showErrorToast(message: message)
    }
}

extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        sendCodeButtonTapped()
        return true
    }
}
