import UIKit

extension UITextField {
    static func createAuthTextField(placeholder: String, keyboardType: UIKeyboardType = .default, isSecure: Bool = false, returnKeyType: UIReturnKeyType = .next) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.keyboardType = keyboardType
        textField.isSecureTextEntry = isSecure
        textField.returnKeyType = returnKeyType
        textField.autocapitalizationType = keyboardType == .emailAddress ? .none : .words
        textField.autocorrectionType = keyboardType == .emailAddress ? .no : .default
        return textField
    }
}

extension UIButton {
    static func createAuthPrimaryButton(title: String, backgroundColor: UIColor = .systemBlue) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.backgroundColor = backgroundColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        return button
    }
    
    static func createAuthTextButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        return button
    }
}

extension UILabel {
    static func createAuthTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        return label
    }
    
    static func createAuthSubtitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }
    
    static func createAuthSecondaryLabel(text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }
}

extension UIScrollView {
    static func createAuthScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .interactive
        return scrollView
    }
}

extension UIImageView {
    static func createAuthIconImageView(systemName: String, tintColor: UIColor = .systemBlue) -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = tintColor
        imageView.image = UIImage(systemName: systemName)
        return imageView
    }
}

extension UIActivityIndicatorView {
    static func createAuthLoadingIndicator() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }
}

extension UIStackView {
    static func createAuthHorizontalStack(spacing: CGFloat = 4) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = spacing
        stackView.alignment = .center
        return stackView
    }
}

extension UIViewController {
    func setupAuthUI(scrollView: UIScrollView) {
        view.backgroundColor = .systemBackground
        scrollView.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        hideKeyboardWhenTappedAround()
        setupAuthKeyboardHandling(for: scrollView)
    }
    
    func setupAuthKeyboardHandling(for scrollView: UIScrollView) {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.handleAuthKeyboardWillShow(notification: notification, scrollView: scrollView)
        }
        
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.handleAuthKeyboardWillHide(scrollView: scrollView)
        }
    }
    
    private func handleAuthKeyboardWillShow(notification: Notification, scrollView: UIScrollView) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    private func handleAuthKeyboardWillHide(scrollView: UIScrollView) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
}
