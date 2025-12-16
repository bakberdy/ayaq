import UIKit
import Combine

final class EditProfileViewController: UIViewController {
    
    weak var coordinator: ProfileCoordinator?
    private let viewModel: EditProfileViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.keyboardDismissMode = .interactive
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var avatarContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 65
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.12
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 12
        return view
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = AppColors.surface
        imageView.layer.cornerRadius = 58
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var editAvatarIconView: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = AppColors.primary
        container.layer.cornerRadius = 18
        container.layer.borderWidth = 3
        container.layer.borderColor = UIColor.white.cgColor
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "camera.fill")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        
        container.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 18),
            imageView.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        return container
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Edit Profile"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = AppColors.textPrimary
        label.textAlignment = .center
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Update your personal information"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = AppColors.textSecondary
        label.textAlignment = .center
        return label
    }()
    
    private lazy var firstNameField = ModernTextField(type: .name, placeholder: "First name")
    private lazy var lastNameField = ModernTextField(type: .name, placeholder: "Last name")
    private lazy var profilePictureField = ModernTextField(type: .default, placeholder: "Profile picture URL (optional)")
    
    private lazy var saveButton = ModernButton(title: "Save Changes", style: .primary)
    private lazy var cancelButton = ModernButton(title: "Cancel", style: .secondary)
    
    private lazy var loadingOverlay: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.isHidden = true
        return view
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    init(viewModel: EditProfileViewModel) {
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
        setupKeyboardHandling()
        populateFields()
    }
    
    private func setupUI() {
        view.backgroundColor = AppColors.background
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(avatarContainerView)
        avatarContainerView.addSubview(avatarImageView)
        avatarContainerView.addSubview(editAvatarIconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(firstNameField)
        contentView.addSubview(lastNameField)
        contentView.addSubview(profilePictureField)
        contentView.addSubview(saveButton)
        contentView.addSubview(cancelButton)
        
        view.addSubview(loadingOverlay)
        loadingOverlay.addSubview(loadingIndicator)
        
        profilePictureField.textField.keyboardType = .URL
        profilePictureField.textField.autocapitalizationType = .none
        
        firstNameField.returnKeyType = .next
        lastNameField.returnKeyType = .next
        profilePictureField.returnKeyType = .done
        
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
            
            avatarContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            avatarContainerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarContainerView.widthAnchor.constraint(equalToConstant: 130),
            avatarContainerView.heightAnchor.constraint(equalToConstant: 130),
            
            avatarImageView.centerXAnchor.constraint(equalTo: avatarContainerView.centerXAnchor),
            avatarImageView.centerYAnchor.constraint(equalTo: avatarContainerView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 116),
            avatarImageView.heightAnchor.constraint(equalToConstant: 116),
            
            editAvatarIconView.bottomAnchor.constraint(equalTo: avatarContainerView.bottomAnchor),
            editAvatarIconView.trailingAnchor.constraint(equalTo: avatarContainerView.trailingAnchor),
            editAvatarIconView.widthAnchor.constraint(equalToConstant: 36),
            editAvatarIconView.heightAnchor.constraint(equalToConstant: 36),
            
            titleLabel.topAnchor.constraint(equalTo: avatarContainerView.bottomAnchor, constant: 28),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            
            firstNameField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            firstNameField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            firstNameField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            
            lastNameField.topAnchor.constraint(equalTo: firstNameField.bottomAnchor, constant: 20),
            lastNameField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            lastNameField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            
            profilePictureField.topAnchor.constraint(equalTo: lastNameField.bottomAnchor, constant: 20),
            profilePictureField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            profilePictureField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            
            saveButton.topAnchor.constraint(equalTo: profilePictureField.bottomAnchor, constant: 40),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            saveButton.heightAnchor.constraint(equalToConstant: 56),
            
            cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 16),
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            cancelButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            cancelButton.heightAnchor.constraint(equalToConstant: 56),
            cancelButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            
            loadingOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            loadingOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: loadingOverlay.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: loadingOverlay.centerYAnchor)
        ])
        
        setDefaultAvatar()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        avatarContainerView.addGestureRecognizer(tapGesture)
        avatarContainerView.isUserInteractionEnabled = true
    }
    
    private func setupBindings() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.render(state)
            }
            .store(in: &cancellables)
        
        firstNameField.textField.addTarget(self, action: #selector(firstNameChanged), for: .editingChanged)
        lastNameField.textField.addTarget(self, action: #selector(lastNameChanged), for: .editingChanged)
        profilePictureField.textField.addTarget(self, action: #selector(profilePictureUrlChanged), for: .editingChanged)
    }
    
    private func setupActions() {
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        
        firstNameField.textFieldDelegate = self
        lastNameField.textFieldDelegate = self
        profilePictureField.textFieldDelegate = self
        
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
    
    private func populateFields() {
        firstNameField.text = viewModel.firstName
        lastNameField.text = viewModel.lastName
        profilePictureField.text = viewModel.profilePictureUrl
        
        if !viewModel.profilePictureUrl.isEmpty, let url = URL(string: viewModel.profilePictureUrl) {
            loadImage(from: url)
        }
    }
    
    private func render(_ state: EditProfileViewModel.State) {
        switch state {
        case .idle:
            hideEditLoading()
            
        case .loading:
            showEditLoading()
            
        case .success:
            hideEditLoading()
            showSuccessAlert()
            
        case .error(let message):
            hideEditLoading()
            showError(message)
        }
    }
    
    private func loadImage(from url: URL) {
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    await MainActor.run {
                        avatarImageView.image = image
                    }
                } else {
                    await MainActor.run {
                        setDefaultAvatar()
                    }
                }
            } catch {
                await MainActor.run {
                    setDefaultAvatar()
                }
            }
        }
    }
    
    private func setDefaultAvatar() {
        let config = UIImage.SymbolConfiguration(pointSize: 56, weight: .light)
        avatarImageView.image = UIImage(systemName: "person.circle.fill", withConfiguration: config)
        avatarImageView.tintColor = AppColors.textSecondary
    }
    
    private func showEditLoading() {
        loadingOverlay.isHidden = false
        loadingIndicator.startAnimating()
        view.isUserInteractionEnabled = false
    }
    
    private func hideEditLoading() {
        loadingOverlay.isHidden = true
        loadingIndicator.stopAnimating()
        view.isUserInteractionEnabled = true
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showSuccessAlert() {
        let alert = UIAlertController(
            title: "Success",
            message: "Your profile has been updated successfully",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.coordinator?.didUpdateProfile()
        })
        present(alert, animated: true)
    }
    
    @objc private func firstNameChanged() {
        viewModel.firstName = firstNameField.text ?? ""
        firstNameField.hideError()
    }
    
    @objc private func lastNameChanged() {
        viewModel.lastName = lastNameField.text ?? ""
        lastNameField.hideError()
    }
    
    @objc private func profilePictureUrlChanged() {
        viewModel.profilePictureUrl = profilePictureField.text ?? ""
        profilePictureField.hideError()
        
        if let urlString = profilePictureField.text, !urlString.isEmpty, let url = URL(string: urlString) {
            loadImage(from: url)
        } else {
            setDefaultAvatar()
        }
    }
    
    @objc private func saveTapped() {
        view.endEditing(true)
        
        firstNameField.hideError()
        lastNameField.hideError()
        profilePictureField.hideError()
        
        switch viewModel.validateInput() {
        case .success:
            viewModel.updateProfile()
        case .failure(let error):
            handleValidationError(error)
        }
    }
    
    private func handleValidationError(_ error: EditProfileViewModel.ValidationError) {
        switch error {
        case .firstNameEmpty, .firstNameTooShort:
            firstNameField.showError(error.localizedDescription)
            firstNameField.becomeFirstResponder()
        case .lastNameEmpty, .lastNameTooShort:
            lastNameField.showError(error.localizedDescription)
            lastNameField.becomeFirstResponder()
        case .invalidProfilePictureUrl:
            profilePictureField.showError(error.localizedDescription)
            profilePictureField.becomeFirstResponder()
        }
    }
    
    @objc private func cancelTapped() {
        coordinator?.didCancelEdit()
    }
    
    @objc private func avatarTapped() {
        profilePictureField.becomeFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameField.textField {
            lastNameField.becomeFirstResponder()
        } else if textField == lastNameField.textField {
            profilePictureField.becomeFirstResponder()
        } else if textField == profilePictureField.textField {
            textField.resignFirstResponder()
            saveTapped()
        }
        return true
    }
}
