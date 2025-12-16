import UIKit
import Combine

final class CheckoutViewController: UIViewController {
    
    weak var coordinator: CartCoordinator?
    private let viewModel: CheckoutViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var successIconContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AppColors.success.withAlphaComponent(0.1)
        view.layer.cornerRadius = 60
        return view
    }()
    
    private lazy var successIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = AppColors.success
        imageView.image = UIImage(systemName: "checkmark.circle.fill")
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Payment Successful!"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = AppColors.textPrimary
        label.textAlignment = .center
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Thank you for your order"
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = AppColors.textSecondary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var orderInfoCard: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 12
        return view
    }()
    
    private lazy var orderNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Order Number"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = AppColors.textSecondary
        label.textAlignment = .center
        return label
    }()
    
    private lazy var orderNumberValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = AppColors.primary
        label.textAlignment = .center
        return label
    }()
    
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AppColors.divider
        return view
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "A confirmation email has been sent to your registered email address"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = AppColors.textSecondary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var continueShopping = ModernButton(title: "Continue Shopping", style: .primary)
    private lazy var viewOrdersButton = ModernButton(title: "View My Orders", style: .secondary)
    
    private lazy var processingContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 16
        view.isHidden = true
        return view
    }()
    
    private lazy var processingSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = AppColors.primary
        return spinner
    }()
    
    private lazy var processingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Processing Payment..."
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = AppColors.textPrimary
        label.textAlignment = .center
        return label
    }()
    
    private lazy var processingSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Please wait while we confirm your payment"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = AppColors.textSecondary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    init(viewModel: CheckoutViewModel) {
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if case .idle = viewModel.state {
            viewModel.processPayment()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = AppColors.background
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.addSubview(contentView)
        contentView.addSubview(successIconContainer)
        successIconContainer.addSubview(successIconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(orderInfoCard)
        
        orderInfoCard.addSubview(orderNumberLabel)
        orderInfoCard.addSubview(orderNumberValueLabel)
        orderInfoCard.addSubview(dividerView)
        orderInfoCard.addSubview(emailLabel)
        
        contentView.addSubview(continueShopping)
        contentView.addSubview(viewOrdersButton)
        
        view.addSubview(processingContainer)
        processingContainer.addSubview(processingSpinner)
        processingContainer.addSubview(processingLabel)
        processingContainer.addSubview(processingSubLabel)
        
        contentView.alpha = 0
        contentView.isHidden = true
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            successIconContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 80),
            successIconContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            successIconContainer.widthAnchor.constraint(equalToConstant: 120),
            successIconContainer.heightAnchor.constraint(equalToConstant: 120),
            
            successIconView.centerXAnchor.constraint(equalTo: successIconContainer.centerXAnchor),
            successIconView.centerYAnchor.constraint(equalTo: successIconContainer.centerYAnchor),
            successIconView.widthAnchor.constraint(equalToConstant: 70),
            successIconView.heightAnchor.constraint(equalToConstant: 70),
            
            titleLabel.topAnchor.constraint(equalTo: successIconContainer.bottomAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            
            orderInfoCard.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            orderInfoCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            orderInfoCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            
            orderNumberLabel.topAnchor.constraint(equalTo: orderInfoCard.topAnchor, constant: 24),
            orderNumberLabel.leadingAnchor.constraint(equalTo: orderInfoCard.leadingAnchor, constant: 24),
            orderNumberLabel.trailingAnchor.constraint(equalTo: orderInfoCard.trailingAnchor, constant: -24),
            
            orderNumberValueLabel.topAnchor.constraint(equalTo: orderNumberLabel.bottomAnchor, constant: 8),
            orderNumberValueLabel.leadingAnchor.constraint(equalTo: orderInfoCard.leadingAnchor, constant: 24),
            orderNumberValueLabel.trailingAnchor.constraint(equalTo: orderInfoCard.trailingAnchor, constant: -24),
            
            dividerView.topAnchor.constraint(equalTo: orderNumberValueLabel.bottomAnchor, constant: 20),
            dividerView.leadingAnchor.constraint(equalTo: orderInfoCard.leadingAnchor, constant: 24),
            dividerView.trailingAnchor.constraint(equalTo: orderInfoCard.trailingAnchor, constant: -24),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            emailLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 20),
            emailLabel.leadingAnchor.constraint(equalTo: orderInfoCard.leadingAnchor, constant: 24),
            emailLabel.trailingAnchor.constraint(equalTo: orderInfoCard.trailingAnchor, constant: -24),
            emailLabel.bottomAnchor.constraint(equalTo: orderInfoCard.bottomAnchor, constant: -24),
            
            continueShopping.topAnchor.constraint(equalTo: orderInfoCard.bottomAnchor, constant: 40),
            continueShopping.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            continueShopping.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            continueShopping.heightAnchor.constraint(equalToConstant: 56),
            
            viewOrdersButton.topAnchor.constraint(equalTo: continueShopping.bottomAnchor, constant: 16),
            viewOrdersButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            viewOrdersButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            viewOrdersButton.heightAnchor.constraint(equalToConstant: 56),
            
            processingContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            processingContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            processingContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            processingContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            processingSpinner.topAnchor.constraint(equalTo: processingContainer.topAnchor, constant: 40),
            processingSpinner.centerXAnchor.constraint(equalTo: processingContainer.centerXAnchor),
            
            processingLabel.topAnchor.constraint(equalTo: processingSpinner.bottomAnchor, constant: 24),
            processingLabel.leadingAnchor.constraint(equalTo: processingContainer.leadingAnchor, constant: 24),
            processingLabel.trailingAnchor.constraint(equalTo: processingContainer.trailingAnchor, constant: -24),
            
            processingSubLabel.topAnchor.constraint(equalTo: processingLabel.bottomAnchor, constant: 8),
            processingSubLabel.leadingAnchor.constraint(equalTo: processingContainer.leadingAnchor, constant: 24),
            processingSubLabel.trailingAnchor.constraint(equalTo: processingContainer.trailingAnchor, constant: -24),
            processingSubLabel.bottomAnchor.constraint(equalTo: processingContainer.bottomAnchor, constant: -40)
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
        continueShopping.addTarget(self, action: #selector(continueShoppingTapped), for: .touchUpInside)
        viewOrdersButton.addTarget(self, action: #selector(viewOrdersTapped), for: .touchUpInside)
    }
    
    private func render(_ state: CheckoutViewModel.State) {
        switch state {
        case .idle:
            break
            
        case .processing:
            showProcessing()
            
        case .success(let orderNumber):
            showSuccess(orderNumber: orderNumber)
            
        case .error(let message):
            showError(message)
        }
    }
    
    private func showProcessing() {
        processingContainer.isHidden = false
        processingSpinner.startAnimating()
        contentView.isHidden = true
    }
    
    private func showSuccess(orderNumber: String) {
        processingContainer.isHidden = true
        processingSpinner.stopAnimating()
        
        orderNumberValueLabel.text = orderNumber
        
        contentView.isHidden = false
        contentView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(
            withDuration: 0.6,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut
        ) {
            self.contentView.alpha = 1
            self.contentView.transform = .identity
        }
        
        animateSuccessIcon()
    }
    
    private func animateSuccessIcon() {
        successIconContainer.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        successIconContainer.alpha = 0
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0.2,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.8,
            options: .curveEaseOut
        ) {
            self.successIconContainer.transform = .identity
            self.successIconContainer.alpha = 1
        }
        
        let pulseAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        pulseAnimation.values = [1.0, 1.15, 1.0]
        pulseAnimation.keyTimes = [0, 0.5, 1]
        pulseAnimation.duration = 0.6
        pulseAnimation.beginTime = CACurrentMediaTime() + 0.7
        successIconView.layer.add(pulseAnimation, forKey: "pulse")
    }
    
    private func showError(_ message: String) {
        processingContainer.isHidden = true
        processingSpinner.stopAnimating()
        
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.coordinator?.didFinishCheckout()
        })
        present(alert, animated: true)
    }
    
    @objc private func continueShoppingTapped() {
        coordinator?.didFinishCheckout()
    }
    
    @objc private func viewOrdersTapped() {
        coordinator?.showOrders()
    }
}

