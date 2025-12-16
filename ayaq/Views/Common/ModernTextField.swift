import UIKit

final class ModernTextField: UIView {
    
    enum TextFieldType {
        case email
        case password
        case name
        case phone
        case `default`
        
        var icon: UIImage? {
            switch self {
            case .email:
                return UIImage(systemName: "envelope.fill")
            case .password:
                return UIImage(systemName: "lock.fill")
            case .name:
                return UIImage(systemName: "person.fill")
            case .phone:
                return UIImage(systemName: "phone.fill")
            case .default:
                return nil
            }
        }
        
        var keyboardType: UIKeyboardType {
            switch self {
            case .email:
                return .emailAddress
            case .phone:
                return .phonePad
            default:
                return .default
            }
        }
    }
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AppColors.surface
        view.layer.cornerRadius = 14
        view.layer.borderWidth = 1.5
        view.layer.borderColor = AppColors.divider.cgColor
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = AppColors.textSecondary
        return imageView
    }()
    
    private(set) lazy var textField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = .systemFont(ofSize: 16, weight: .regular)
        field.textColor = AppColors.textPrimary
        field.tintColor = AppColors.primary
        field.autocorrectionType = .no
        field.delegate = self
        return field
    }()
    
    private lazy var togglePasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        button.tintColor = AppColors.textSecondary
        button.isHidden = true
        button.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        return button
    }()
    
    private lazy var clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = AppColors.textSecondary
        button.isHidden = true
        button.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        return button
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = AppColors.error
        label.numberOfLines = 0
        label.alpha = 0
        return label
    }()
    
    private var isPasswordField = false
    private var isPasswordVisible = false
    
    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }
    
    var placeholder: String? {
        didSet {
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholder ?? "",
                attributes: [
                    .foregroundColor: AppColors.textSecondary.withAlphaComponent(0.6),
                    .font: UIFont.systemFont(ofSize: 16, weight: .regular)
                ]
            )
        }
    }
    
    var returnKeyType: UIReturnKeyType {
        get { textField.returnKeyType }
        set { textField.returnKeyType = newValue }
    }
    
    var textFieldDelegate: UITextFieldDelegate? {
        didSet {
            textField.delegate = textFieldDelegate
        }
    }
    
    init(type: TextFieldType, placeholder: String) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.isPasswordField = type == .password
        
        textField.keyboardType = type.keyboardType
        textField.autocapitalizationType = type == .email ? .none : (type == .name ? .words : .sentences)
        textField.isSecureTextEntry = type == .password
        
        setupUI(type: type)
        setupObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(type: TextFieldType) {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(textField)
        containerView.addSubview(togglePasswordButton)
        containerView.addSubview(clearButton)
        addSubview(errorLabel)
        
        iconImageView.image = type.icon
        
        let rightButton = isPasswordField ? togglePasswordButton : clearButton
        rightButton.isHidden = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 56),
            
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            textField.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            textField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            togglePasswordButton.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 8),
            togglePasswordButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            togglePasswordButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            togglePasswordButton.widthAnchor.constraint(equalToConstant: 24),
            togglePasswordButton.heightAnchor.constraint(equalToConstant: 24),
            
            clearButton.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 8),
            clearButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            clearButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            clearButton.widthAnchor.constraint(equalToConstant: 24),
            clearButton.heightAnchor.constraint(equalToConstant: 24),
            
            errorLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 6),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [
                .foregroundColor: AppColors.textSecondary.withAlphaComponent(0.6),
                .font: UIFont.systemFont(ofSize: 16, weight: .regular)
            ]
        )
    }
    
    private func setupObservers() {
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange() {
        if !isPasswordField {
            clearButton.isHidden = textField.text?.isEmpty ?? true
        }
        hideError()
    }
    
    @objc private func togglePasswordVisibility() {
        isPasswordVisible.toggle()
        textField.isSecureTextEntry = !isPasswordVisible
        
        let imageName = isPasswordVisible ? "eye.slash.fill" : "eye.fill"
        togglePasswordButton.setImage(UIImage(systemName: imageName), for: .normal)
        
        UIView.animate(withDuration: 0.2) {
            self.togglePasswordButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.togglePasswordButton.transform = .identity
            }
        }
    }
    
    @objc private func clearText() {
        textField.text = ""
        clearButton.isHidden = true
        textField.sendActions(for: .editingChanged)
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.containerView.layer.borderColor = AppColors.error.cgColor
            self.errorLabel.alpha = 1
            self.layoutIfNeeded()
        }
        
        let shake = CAKeyframeAnimation(keyPath: "transform.translation.x")
        shake.values = [0, -10, 10, -5, 5, 0]
        shake.duration = 0.4
        containerView.layer.add(shake, forKey: "shake")
    }
    
    func hideError() {
        UIView.animate(withDuration: 0.3) {
            self.containerView.layer.borderColor = AppColors.divider.cgColor
            self.errorLabel.alpha = 0
        }
    }
    
    func setFocusState(_ isFocused: Bool) {
        UIView.animate(withDuration: 0.2) {
            if isFocused {
                self.containerView.layer.borderColor = AppColors.primary.cgColor
                self.containerView.backgroundColor = AppColors.background
                self.iconImageView.tintColor = AppColors.primary
            } else {
                self.containerView.layer.borderColor = AppColors.divider.cgColor
                self.containerView.backgroundColor = AppColors.surface
                self.iconImageView.tintColor = AppColors.textSecondary
            }
        }
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }
}

extension ModernTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ UITextField: UITextField) {
        setFocusState(true)
    }
    
    func textFieldDidEndEditing(_ UITextField: UITextField) {
        setFocusState(false)
    }
}

