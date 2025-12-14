import UIKit
import Combine

final class ResetPasswordViewController: UIViewController {
    private let viewModel: ResetPasswordViewModel
    weak var coordinator: AuthCoordinator?
    private var cancellables = Set<AnyCancellable>()
    
    private let scrollView = UIScrollView.createAuthScrollView()
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let iconImageView = UIImageView.createAuthIconImageView(systemName: "checkmark.shield.fill", tintColor: .systemGreen)
    private let titleLabel = UILabel.createAuthTitleLabel(text: "Reset Password")
    private let subtitleLabel = UILabel.createAuthSubtitleLabel(text: "Enter the code sent to your email and create a new password")
    private let emailTextField = UITextField.createAuthTextField(placeholder: "Email", keyboardType: .emailAddress)
    private let codeTextField = UITextField.createAuthTextField(placeholder: "Verification Code", keyboardType: .numberPad)
    private let newPasswordTextField = UITextField.createAuthTextField(placeholder: "New Password", isSecure: true)
    private let confirmPasswordTextField = UITextField.createAuthTextField(placeholder: "Confirm Password", isSecure: true, returnKeyType: .done)
    private let resetButton = UIButton.createAuthPrimaryButton(title: "Reset Password", backgroundColor: .systemGreen)
    private let activityIndicator = UIActivityIndicatorView.createAuthLoadingIndicator()
    private let backToLoginButton = UIButton.createAuthTextButton(title: "Back to Login")
    private let email: String?
    
    init(viewModel: ResetPasswordViewModel, email: String? = nil) {
        self.viewModel = viewModel
        self.email = email
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
        
        if let email = email {
            emailTextField.text = email
        }
    }
    
    private func setupUI() {
        title = "Reset Password"
        setupAuthUI(scrollView: scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(emailTextField)
        contentView.addSubview(codeTextField)
        contentView.addSubview(newPasswordTextField)
        contentView.addSubview(confirmPasswordTextField)
        contentView.addSubview(resetButton)
        contentView.addSubview(activityIndicator)
        contentView.addSubview(backToLoginButton)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 80),
            iconImageView.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            emailTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 32),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            emailTextField.heightAnchor.constraint(equalToConstant: 48),
            
            codeTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            codeTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            codeTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            codeTextField.heightAnchor.constraint(equalToConstant: 48),
            
            newPasswordTextField.topAnchor.constraint(equalTo: codeTextField.bottomAnchor, constant: 16),
            newPasswordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            newPasswordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            newPasswordTextField.heightAnchor.constraint(equalToConstant: 48),
            
            confirmPasswordTextField.topAnchor.constraint(equalTo: newPasswordTextField.bottomAnchor, constant: 16),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 48),
            
            resetButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 24),
            resetButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            resetButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            resetButton.heightAnchor.constraint(equalToConstant: 52),
            
            activityIndicator.centerXAnchor.constraint(equalTo: resetButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: resetButton.centerYAnchor),
            
            backToLoginButton.topAnchor.constraint(equalTo: resetButton.bottomAnchor, constant: 24),
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
    
    private func setupActions() {
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        backToLoginButton.addTarget(self, action: #selector(backToLoginButtonTapped), for: .touchUpInside)
        
        emailTextField.delegate = self
        codeTextField.delegate = self
        newPasswordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        codeTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        newPasswordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func setupKeyboardObservers() {
        // TODO: Keyboard observers are handled in AuthUIHelpers.setupAuthKeyboardHandling
    }
    
    @objc private func resetButtonTapped() {
        dismissKeyboard()
        viewModel.resetPassword(
            email: emailTextField.text ?? "",
            code: codeTextField.text ?? "",
            newPassword: newPasswordTextField.text ?? "",
            confirmPassword: confirmPasswordTextField.text ?? ""
        )
    }
    
    @objc private func backToLoginButtonTapped() {
        coordinator?.showLogin()
    }
    
    @objc private func textFieldDidChange() {
        // Input validation can be added here if needed
    }
    
    private func render(_ state: ResetPasswordViewModel.State) {
        switch state {
        case .idle:
            activityIndicator.stopAnimating()
            resetButton.setTitle("Reset Password", for: .normal)
            resetButton.isEnabled = true
            setFieldsEnabled(true)
            
        case .loading:
            activityIndicator.startAnimating()
            resetButton.setTitle("", for: .normal)
            resetButton.isEnabled = false
            setFieldsEnabled(false)
            
        case .success:
            activityIndicator.stopAnimating()
            resetButton.setTitle("Reset Password", for: .normal)
            resetButton.isEnabled = true
            setFieldsEnabled(true)
            showSuccessToast(message: "Password reset successfully")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
                self?.coordinator?.showLogin()
            }
            
        case .error(let message):
            activityIndicator.stopAnimating()
            resetButton.setTitle("Reset Password", for: .normal)
            resetButton.isEnabled = true
            setFieldsEnabled(true)
            showErrorToast(message: message)
        }
    }
    
    private func setFieldsEnabled(_ enabled: Bool) {
        emailTextField.isEnabled = enabled
        codeTextField.isEnabled = enabled
        newPasswordTextField.isEnabled = enabled
        confirmPasswordTextField.isEnabled = enabled
    }
}

extension ResetPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            codeTextField.becomeFirstResponder()
        } else if textField == codeTextField {
            newPasswordTextField.becomeFirstResponder()
        } else if textField == newPasswordTextField {
            confirmPasswordTextField.becomeFirstResponder()
        } else if textField == confirmPasswordTextField {
            textField.resignFirstResponder()
            resetButtonTapped()
        }
        return true
    }
}
