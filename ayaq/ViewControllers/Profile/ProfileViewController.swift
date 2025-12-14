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
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.primary
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = AppColors.surface
        imageView.layer.cornerRadius = 60
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = UIColor.white.cgColor
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
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = AppColors.textSecondary
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = AppColors.textSecondary
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var rolesBadge: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = AppColors.primary
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var infoContainerView: UIView = {
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
    
    private lazy var editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = AppColors.primary
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(AppColors.error, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 2
        button.layer.borderColor = AppColors.error.cgColor
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var removeAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Remove Account", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = AppColors.error
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
    
    private lazy var errorView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.surface
        view.layer.cornerRadius = 12
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = AppColors.error
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retry", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = AppColors.primary
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var errorLogoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(AppColors.error, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 2
        button.layer.borderColor = AppColors.error.cgColor
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
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
        
        contentView.addSubview(headerView)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(infoContainerView)
        
        infoContainerView.addSubview(nameLabel)
        infoContainerView.addSubview(usernameLabel)
        infoContainerView.addSubview(emailLabel)
        infoContainerView.addSubview(rolesBadge)
        
        contentView.addSubview(editProfileButton)
        contentView.addSubview(logoutButton)
        contentView.addSubview(removeAccountButton)
        
        view.addSubview(loadingIndicator)
        view.addSubview(errorView)
        errorView.addSubview(errorLabel)
        errorView.addSubview(retryButton)
        view.addSubview(errorLogoutButton)
        
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
            
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 120),
            
            avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarImageView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -60),
            avatarImageView.widthAnchor.constraint(equalToConstant: 120),
            avatarImageView.heightAnchor.constraint(equalToConstant: 120),
            
            infoContainerView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            infoContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            infoContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            nameLabel.topAnchor.constraint(equalTo: infoContainerView.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -20),
            
            usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            usernameLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 20),
            usernameLabel.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -20),
            
            emailLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 4),
            emailLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -20),
            
            rolesBadge.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 16),
            rolesBadge.centerXAnchor.constraint(equalTo: infoContainerView.centerXAnchor),
            rolesBadge.heightAnchor.constraint(equalToConstant: 24),
            rolesBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 80),
            rolesBadge.bottomAnchor.constraint(equalTo: infoContainerView.bottomAnchor, constant: -20),
            
            editProfileButton.topAnchor.constraint(equalTo: infoContainerView.bottomAnchor, constant: 32),
            editProfileButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            editProfileButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            editProfileButton.heightAnchor.constraint(equalToConstant: 52),
            
            logoutButton.topAnchor.constraint(equalTo: editProfileButton.bottomAnchor, constant: 16),
            logoutButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            logoutButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            removeAccountButton.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 16),
            removeAccountButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            removeAccountButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            removeAccountButton.heightAnchor.constraint(equalToConstant: 52),
            removeAccountButton.heightAnchor.constraint(equalToConstant: 52),
            logoutButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            errorLabel.topAnchor.constraint(equalTo: errorView.topAnchor, constant: 20),
            errorLabel.leadingAnchor.constraint(equalTo: errorView.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: errorView.trailingAnchor, constant: -20),
            
            retryButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 16),
            retryButton.centerXAnchor.constraint(equalTo: errorView.centerXAnchor),
            retryButton.widthAnchor.constraint(equalToConstant: 120),
            retryButton.heightAnchor.constraint(equalToConstant: 40),
            retryButton.bottomAnchor.constraint(equalTo: errorView.bottomAnchor, constant: -20),
            
            errorLogoutButton.topAnchor.constraint(equalTo: errorView.bottomAnchor, constant: 24),
            errorLogoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            errorLogoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            errorLogoutButton.heightAnchor.constraint(equalToConstant: 52)
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
        editProfileButton.addTarget(self, action: #selector(editProfileTapped), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        removeAccountButton.addTarget(self, action: #selector(removeAccountTapped), for: .touchUpInside)
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
        usernameLabel.text = "@\(user.userName ?? "")"
        emailLabel.text = user.email
        
        if let roles = user.roles, !roles.isEmpty {
            let roleText = roles.map { $0.rawValue.capitalized }.joined(separator: ", ")
            rolesBadge.text = "  \(roleText)  "
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
        errorView.isHidden = true
        errorLogoutButton.isHidden = true
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
    
    private func showProfileLoading() {
        loadingIndicator.startAnimating()
        scrollView.isHidden = true
        errorView.isHidden = true
        errorLogoutButton.isHidden = true
    }
    
    private func hideProfileLoading() {
        loadingIndicator.stopAnimating()
    }
    
    private func showErrorState(_ message: String) {
        errorLabel.text = message
        errorView.isHidden = false
        errorLogoutButton.isHidden = false
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
            title: "Remove Account",
            message: "Are you sure you want to remove your account? This will log you out of the app.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Remove", style: .destructive) { [weak self] _ in
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
    
    deinit {
        Task { @MainActor in
            viewModel.cancelAllOperations()
        }
    }
}
