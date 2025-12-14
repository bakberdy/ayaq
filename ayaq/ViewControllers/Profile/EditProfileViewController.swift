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
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = AppColors.surface
        imageView.layer.cornerRadius = 60
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = AppColors.primary.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change Photo", for: .normal)
        button.setTitleColor(AppColors.primary, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var formContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var firstNameLabel: UILabel = {
        let label = UILabel()
        label.text = "First Name"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = AppColors.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your first name"
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.textColor = AppColors.textPrimary
        textField.borderStyle = .none
        textField.backgroundColor = AppColors.surface
        textField.layer.cornerRadius = 8
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.autocapitalizationType = .words
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var lastNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Last Name"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = AppColors.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your last name"
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.textColor = AppColors.textPrimary
        textField.borderStyle = .none
        textField.backgroundColor = AppColors.surface
        textField.layer.cornerRadius = 8
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.autocapitalizationType = .words
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var profilePictureLabel: UILabel = {
        let label = UILabel()
        label.text = "Profile Picture URL (Optional)"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = AppColors.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var profilePictureTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "https://example.com/avatar.jpg"
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.textColor = AppColors.textPrimary
        textField.borderStyle = .none
        textField.backgroundColor = AppColors.surface
        textField.layer.cornerRadius = 8
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.autocapitalizationType = .none
        textField.keyboardType = .URL
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Changes", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = AppColors.primary
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(AppColors.textSecondary, for: .normal)
        button.backgroundColor = AppColors.surface
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = AppColors.primary
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
        setupKeyboardObservers()
        populateFields()
    }
    
    private func setupUI() {
        view.backgroundColor = AppColors.background
        title = "Edit Profile"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(changePhotoButton)
        contentView.addSubview(formContainerView)
        
        formContainerView.addSubview(firstNameLabel)
        formContainerView.addSubview(firstNameTextField)
        formContainerView.addSubview(lastNameLabel)
        formContainerView.addSubview(lastNameTextField)
        formContainerView.addSubview(profilePictureLabel)
        formContainerView.addSubview(profilePictureTextField)
        
        contentView.addSubview(saveButton)
        contentView.addSubview(cancelButton)
        
        view.addSubview(loadingIndicator)
        
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
            
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 120),
            avatarImageView.heightAnchor.constraint(equalToConstant: 120),
            
            changePhotoButton.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            changePhotoButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            formContainerView.topAnchor.constraint(equalTo: changePhotoButton.bottomAnchor, constant: 24),
            formContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            formContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            firstNameLabel.topAnchor.constraint(equalTo: formContainerView.topAnchor, constant: 20),
            firstNameLabel.leadingAnchor.constraint(equalTo: formContainerView.leadingAnchor, constant: 20),
            firstNameLabel.trailingAnchor.constraint(equalTo: formContainerView.trailingAnchor, constant: -20),
            
            firstNameTextField.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor, constant: 8),
            firstNameTextField.leadingAnchor.constraint(equalTo: formContainerView.leadingAnchor, constant: 20),
            firstNameTextField.trailingAnchor.constraint(equalTo: formContainerView.trailingAnchor, constant: -20),
            firstNameTextField.heightAnchor.constraint(equalToConstant: 48),
            
            lastNameLabel.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 20),
            lastNameLabel.leadingAnchor.constraint(equalTo: formContainerView.leadingAnchor, constant: 20),
            lastNameLabel.trailingAnchor.constraint(equalTo: formContainerView.trailingAnchor, constant: -20),
            
            lastNameTextField.topAnchor.constraint(equalTo: lastNameLabel.bottomAnchor, constant: 8),
            lastNameTextField.leadingAnchor.constraint(equalTo: formContainerView.leadingAnchor, constant: 20),
            lastNameTextField.trailingAnchor.constraint(equalTo: formContainerView.trailingAnchor, constant: -20),
            lastNameTextField.heightAnchor.constraint(equalToConstant: 48),
            
            profilePictureLabel.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 20),
            profilePictureLabel.leadingAnchor.constraint(equalTo: formContainerView.leadingAnchor, constant: 20),
            profilePictureLabel.trailingAnchor.constraint(equalTo: formContainerView.trailingAnchor, constant: -20),
            
            profilePictureTextField.topAnchor.constraint(equalTo: profilePictureLabel.bottomAnchor, constant: 8),
            profilePictureTextField.leadingAnchor.constraint(equalTo: formContainerView.leadingAnchor, constant: 20),
            profilePictureTextField.trailingAnchor.constraint(equalTo: formContainerView.trailingAnchor, constant: -20),
            profilePictureTextField.heightAnchor.constraint(equalToConstant: 48),
            profilePictureTextField.bottomAnchor.constraint(equalTo: formContainerView.bottomAnchor, constant: -20),
            
            saveButton.topAnchor.constraint(equalTo: formContainerView.bottomAnchor, constant: 32),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            saveButton.heightAnchor.constraint(equalToConstant: 52),
            
            cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 16),
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            cancelButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            cancelButton.heightAnchor.constraint(equalToConstant: 52),
            cancelButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        setDefaultAvatar()
    }
    
    private func setupBindings() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.render(state)
            }
            .store(in: &cancellables)
        
        firstNameTextField.addTarget(self, action: #selector(firstNameChanged), for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(lastNameChanged), for: .editingChanged)
        profilePictureTextField.addTarget(self, action: #selector(profilePictureUrlChanged), for: .editingChanged)
    }
    
    private func setupActions() {
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        changePhotoButton.addTarget(self, action: #selector(changePhotoTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func populateFields() {
        firstNameTextField.text = viewModel.firstName
        lastNameTextField.text = viewModel.lastName
        profilePictureTextField.text = viewModel.profilePictureUrl
        
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
        let config = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
        avatarImageView.image = UIImage(systemName: "person.circle.fill", withConfiguration: config)
        avatarImageView.tintColor = AppColors.textSecondary
    }
    
    private func showEditLoading() {
        loadingIndicator.startAnimating()
        view.isUserInteractionEnabled = false
        saveButton.alpha = 0.5
    }
    
    private func hideEditLoading() {
        loadingIndicator.stopAnimating()
        view.isUserInteractionEnabled = true
        saveButton.alpha = 1.0
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
        viewModel.firstName = firstNameTextField.text ?? ""
    }
    
    @objc private func lastNameChanged() {
        viewModel.lastName = lastNameTextField.text ?? ""
    }
    
    @objc private func profilePictureUrlChanged() {
        viewModel.profilePictureUrl = profilePictureTextField.text ?? ""
        
        if let urlString = profilePictureTextField.text, !urlString.isEmpty, let url = URL(string: urlString) {
            loadImage(from: url)
        } else {
            setDefaultAvatar()
        }
    }
    
    @objc private func saveTapped() {
        handleDismissKeyboard()
        viewModel.updateProfile()
    }
    
    @objc private func cancelTapped() {
        coordinator?.didCancelEdit()
    }
    
    @objc private func changePhotoTapped() {
        profilePictureTextField.becomeFirstResponder()
    }
    
    @objc private func handleDismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let keyboardHeight = keyboardFrame.height
        scrollView.contentInset.bottom = keyboardHeight
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    deinit {
        Task { @MainActor in
            viewModel.cancelUpdate()
        }
        NotificationCenter.default.removeObserver(self)
    }
}
