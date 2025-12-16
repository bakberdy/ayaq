import UIKit
import Combine

final class ProfileViewController: UIViewController {
    
    weak var coordinator: ProfileCoordinator?
    private let viewModel: ProfileViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var headerGradientView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var avatarContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 70
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.15
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 12
        return view
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = AppColors.surface
        imageView.layer.cornerRadius = 62
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = AppColors.textPrimary
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var rolesBadge: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = AppColors.primary.withAlphaComponent(0.1)
        container.layer.cornerRadius = 14
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = AppColors.primary
        label.textAlignment = .center
        label.tag = 100
        
        container.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8)
        ])
        
        return container
    }()
    
    private lazy var usernameCard: ProfileInfoCard = {
        let card = ProfileInfoCard(
            icon: UIImage(systemName: "at.circle.fill"),
            title: "Username"
        )
        return card
    }()
    
    private lazy var emailCard: ProfileInfoCard = {
        let card = ProfileInfoCard(
            icon: UIImage(systemName: "envelope.circle.fill"),
            title: "Email Address"
        )
        return card
    }()
    
    private lazy var editProfileButton = ModernButton(title: "Edit Profile", style: .primary)
    private lazy var logoutButton = ModernButton(title: "Logout", style: .secondary)
    
    private lazy var deleteAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Delete Account", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.setTitleColor(AppColors.error, for: .normal)
        return button
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = AppColors.primary
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var errorContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 12
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var errorIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = AppColors.error
        imageView.image = UIImage(systemName: "exclamationmark.triangle.fill")
        return imageView
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = AppColors.textPrimary
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var retryButton = ModernButton(title: "Retry", style: .primary)
    private lazy var errorLogoutButton = ModernButton(title: "Logout", style: .secondary)
    
    init(viewModel: ProfileViewModel) {
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
        setupGradient()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserProfile()
    }
    
    private func setupUI() {
        view.backgroundColor = AppColors.background
        title = "Profile"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerGradientView)
        contentView.addSubview(avatarContainerView)
        avatarContainerView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(rolesBadge)
        contentView.addSubview(usernameCard)
        contentView.addSubview(emailCard)
        contentView.addSubview(editProfileButton)
        contentView.addSubview(logoutButton)
        contentView.addSubview(deleteAccountButton)
        
        view.addSubview(loadingIndicator)
        view.addSubview(errorContainerView)
        errorContainerView.addSubview(errorIconView)
        errorContainerView.addSubview(errorLabel)
        errorContainerView.addSubview(retryButton)
        errorContainerView.addSubview(errorLogoutButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            headerGradientView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerGradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerGradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerGradientView.heightAnchor.constraint(equalToConstant: 180),
            
            avatarContainerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarContainerView.topAnchor.constraint(equalTo: headerGradientView.bottomAnchor, constant: -70),
            avatarContainerView.widthAnchor.constraint(equalToConstant: 140),
            avatarContainerView.heightAnchor.constraint(equalToConstant: 140),
            
            avatarImageView.centerXAnchor.constraint(equalTo: avatarContainerView.centerXAnchor),
            avatarImageView.centerYAnchor.constraint(equalTo: avatarContainerView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 124),
            avatarImageView.heightAnchor.constraint(equalToConstant: 124),
            
            nameLabel.topAnchor.constraint(equalTo: avatarContainerView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            
            rolesBadge.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
            rolesBadge.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            usernameCard.topAnchor.constraint(equalTo: rolesBadge.bottomAnchor, constant: 32),
            usernameCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            usernameCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            
            emailCard.topAnchor.constraint(equalTo: usernameCard.bottomAnchor, constant: 16),
            emailCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            emailCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            
            editProfileButton.topAnchor.constraint(equalTo: emailCard.bottomAnchor, constant: 32),
            editProfileButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            editProfileButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            editProfileButton.heightAnchor.constraint(equalToConstant: 56),
            
            logoutButton.topAnchor.constraint(equalTo: editProfileButton.bottomAnchor, constant: 16),
            logoutButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            logoutButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            logoutButton.heightAnchor.constraint(equalToConstant: 56),
            
            deleteAccountButton.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 20),
            deleteAccountButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            deleteAccountButton.heightAnchor.constraint(equalToConstant: 44),
            deleteAccountButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            errorContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            
            errorIconView.topAnchor.constraint(equalTo: errorContainerView.topAnchor, constant: 32),
            errorIconView.centerXAnchor.constraint(equalTo: errorContainerView.centerXAnchor),
            errorIconView.widthAnchor.constraint(equalToConstant: 56),
            errorIconView.heightAnchor.constraint(equalToConstant: 56),
            
            errorLabel.topAnchor.constraint(equalTo: errorIconView.bottomAnchor, constant: 20),
            errorLabel.leadingAnchor.constraint(equalTo: errorContainerView.leadingAnchor, constant: 24),
            errorLabel.trailingAnchor.constraint(equalTo: errorContainerView.trailingAnchor, constant: -24),
            
            retryButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 24),
            retryButton.leadingAnchor.constraint(equalTo: errorContainerView.leadingAnchor, constant: 24),
            retryButton.trailingAnchor.constraint(equalTo: errorContainerView.trailingAnchor, constant: -24),
            retryButton.heightAnchor.constraint(equalToConstant: 52),
            
            errorLogoutButton.topAnchor.constraint(equalTo: retryButton.bottomAnchor, constant: 12),
            errorLogoutButton.leadingAnchor.constraint(equalTo: errorContainerView.leadingAnchor, constant: 24),
            errorLogoutButton.trailingAnchor.constraint(equalTo: errorContainerView.trailingAnchor, constant: -24),
            errorLogoutButton.heightAnchor.constraint(equalToConstant: 52),
            errorLogoutButton.bottomAnchor.constraint(equalTo: errorContainerView.bottomAnchor, constant: -24)
        ])
    }
    
    private func setupGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            AppColors.primary.cgColor,
            AppColors.primary.withAlphaComponent(0.8).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 180)
        headerGradientView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let gradientLayer = headerGradientView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = headerGradientView.bounds
        }
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
        editProfileButton.addTarget(self, action: #selector(editProfileTapped), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        deleteAccountButton.addTarget(self, action: #selector(removeAccountTapped), for: .touchUpInside)
        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
        errorLogoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
    }
    
    private func loadUserProfile() {
        guard let userId = TokenManager.shared.getUserId() else {
            showErrorState("Unable to load profile. Please login again.")
            return
        }
        viewModel.loadProfile(userId: userId)
    }
    
    private func render(_ state: ProfileViewModel.State) {
        switch state {
        case .idle:
            hideProfileLoading()
            
        case .loading:
            showProfileLoading()
            
        case .loaded(let user):
            hideProfileLoading()
            displayUserInfo(user)
            
        case .error(let message):
            hideProfileLoading()
            showErrorState(message)
        }
    }
    
    private func displayUserInfo(_ user: User) {
        nameLabel.text = user.fullName
        usernameCard.setValue("@\(user.userName ?? "unknown")")
        emailCard.setValue(user.email ?? "No email provided")
        
        if let roles = user.roles, !roles.isEmpty {
            let roleText = roles.map { $0.rawValue.capitalized }.joined(separator: ", ")
            if let badgeLabel = rolesBadge.viewWithTag(100) as? UILabel {
                badgeLabel.text = roleText
            }
            rolesBadge.isHidden = false
        } else {
            rolesBadge.isHidden = true
        }
        
        if let urlString = user.profilePictureUrl, let url = URL(string: urlString) {
            loadImage(from: url)
        } else {
            setDefaultAvatar()
        }
        
        scrollView.isHidden = false
        errorContainerView.isHidden = true
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
        let config = UIImage.SymbolConfiguration(pointSize: 60, weight: .light)
        avatarImageView.image = UIImage(systemName: "person.circle.fill", withConfiguration: config)
        avatarImageView.tintColor = AppColors.textSecondary
    }
    
    private func showProfileLoading() {
        loadingIndicator.startAnimating()
        scrollView.isHidden = true
        errorContainerView.isHidden = true
    }
    
    private func hideProfileLoading() {
        loadingIndicator.stopAnimating()
    }
    
    private func showErrorState(_ message: String) {
        errorLabel.text = message
        errorContainerView.isHidden = false
        scrollView.isHidden = true
    }
    
    @objc private func editProfileTapped() {
        guard case .loaded(let user) = viewModel.state else { return }
        coordinator?.showEditProfile(user: user)
    }
    
    @objc private func logoutTapped() {
        let alert = UIAlertController(
            title: "Logout",
            message: "Are you sure you want to logout?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive) { [weak self] _ in
            self?.performLogout()
        })
        
        present(alert, animated: true)
    }
    
    @objc private func removeAccountTapped() {
        let alert = UIAlertController(
            title: "Delete Account",
            message: "Are you sure you want to delete your account? This action cannot be undone and will log you out.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.performLogout()
        })
        
        present(alert, animated: true)
    }
    
    @objc private func retryTapped() {
        loadUserProfile()
    }
    
    private func performLogout() {
        viewModel.logout()
        TokenManager.shared.clearToken()
        coordinator?.didLogout()
    }
}
