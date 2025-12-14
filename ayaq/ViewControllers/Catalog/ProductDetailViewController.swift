import UIKit
import Combine

final class ProductDetailViewController: UIViewController {
    private let viewModel: ProductDetailViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = AppColors.background
        return sv
    }()
    
    private let contentView = UIView()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = AppColors.surface
        return iv
    }()
    
    private let brandLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = AppColors.textSecondary
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = AppColors.textPrimary
        label.numberOfLines = 0
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = AppColors.primary
        return label
    }()
    
    private let ratingStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()
    
    private let starImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "star.fill")
        iv.tintColor = .systemYellow
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = AppColors.textPrimary
        return label
    }()
    
    private let reviewCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = AppColors.textSecondary
        return label
    }()
    
    private let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = AppColors.textPrimary
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = AppColors.textSecondary
        label.numberOfLines = 0
        return label
    }()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = AppColors.textSecondary
        return label
    }()
    
    private let quantityContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.surface
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = AppColors.textPrimary
        label.textAlignment = .center
        return label
    }()
    
    private let decreaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        button.tintColor = AppColors.primary
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    private let increaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.tintColor = AppColors.primary
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    private let addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add to Cart", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = AppColors.primary
        button.layer.cornerRadius = 12
        return button
    }()
    
    private let wishlistButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = AppColors.primaryDark
        button.layer.cornerRadius = 12
        return button
    }()
    
    private let loadingView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = AppColors.primary
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    init(viewModel: ProductDetailViewModel) {
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
        viewModel.loadProduct()
    }
    
    private func setupUI() {
        view.backgroundColor = AppColors.background
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(imageView)
        contentView.addSubview(brandLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(ratingStackView)
        contentView.addSubview(descriptionTitleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(stockLabel)
        contentView.addSubview(quantityContainerView)
        contentView.addSubview(addToCartButton)
        contentView.addSubview(wishlistButton)
        
        ratingStackView.addArrangedSubview(starImageView)
        ratingStackView.addArrangedSubview(ratingLabel)
        ratingStackView.addArrangedSubview(reviewCountLabel)
        
        quantityContainerView.addSubview(decreaseButton)
        quantityContainerView.addSubview(quantityLabel)
        quantityContainerView.addSubview(increaseButton)
        
        view.addSubview(loadingView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        brandLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingStackView.translatesAutoresizingMaskIntoConstraints = false
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        stockLabel.translatesAutoresizingMaskIntoConstraints = false
        quantityContainerView.translatesAutoresizingMaskIntoConstraints = false
        decreaseButton.translatesAutoresizingMaskIntoConstraints = false
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        increaseButton.translatesAutoresizingMaskIntoConstraints = false
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false
        wishlistButton.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.0),
            
            brandLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            brandLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            brandLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            nameLabel.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            ratingStackView.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            ratingStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            starImageView.widthAnchor.constraint(equalToConstant: 20),
            starImageView.heightAnchor.constraint(equalToConstant: 20),
            
            stockLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 12),
            stockLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stockLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descriptionTitleLabel.topAnchor.constraint(equalTo: stockLabel.bottomAnchor, constant: 24),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            quantityContainerView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            quantityContainerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            quantityContainerView.heightAnchor.constraint(equalToConstant: 50),
            quantityContainerView.widthAnchor.constraint(equalToConstant: 150),
            
            decreaseButton.leadingAnchor.constraint(equalTo: quantityContainerView.leadingAnchor, constant: 12),
            decreaseButton.centerYAnchor.constraint(equalTo: quantityContainerView.centerYAnchor),
            decreaseButton.widthAnchor.constraint(equalToConstant: 32),
            decreaseButton.heightAnchor.constraint(equalToConstant: 32),
            
            quantityLabel.centerXAnchor.constraint(equalTo: quantityContainerView.centerXAnchor),
            quantityLabel.centerYAnchor.constraint(equalTo: quantityContainerView.centerYAnchor),
            
            increaseButton.trailingAnchor.constraint(equalTo: quantityContainerView.trailingAnchor, constant: -12),
            increaseButton.centerYAnchor.constraint(equalTo: quantityContainerView.centerYAnchor),
            increaseButton.widthAnchor.constraint(equalToConstant: 32),
            increaseButton.heightAnchor.constraint(equalToConstant: 32),
            
            wishlistButton.topAnchor.constraint(equalTo: quantityContainerView.bottomAnchor, constant: 24),
            wishlistButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            wishlistButton.widthAnchor.constraint(equalToConstant: 50),
            wishlistButton.heightAnchor.constraint(equalToConstant: 50),
            
            addToCartButton.topAnchor.constraint(equalTo: quantityContainerView.bottomAnchor, constant: 24),
            addToCartButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            addToCartButton.trailingAnchor.constraint(equalTo: wishlistButton.leadingAnchor, constant: -12),
            addToCartButton.heightAnchor.constraint(equalToConstant: 50),
            addToCartButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),
            
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupBindings() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.render(state)
            }
            .store(in: &cancellables)
        
        viewModel.$actionState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] actionState in
                self?.renderActionState(actionState)
            }
            .store(in: &cancellables)
        
        viewModel.$quantity
            .receive(on: DispatchQueue.main)
            .sink { [weak self] quantity in
                self?.quantityLabel.text = "\(quantity)"
            }
            .store(in: &cancellables)
    }
    
    private func setupActions() {
        decreaseButton.addTarget(self, action: #selector(decreaseTapped), for: .touchUpInside)
        increaseButton.addTarget(self, action: #selector(increaseTapped), for: .touchUpInside)
        addToCartButton.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)
        wishlistButton.addTarget(self, action: #selector(wishlistTapped), for: .touchUpInside)
    }
    
    private func render(_ state: ProductDetailViewModel.State) {
        switch state {
        case .idle:
            loadingView.stopAnimating()
            
        case .loading:
            loadingView.startAnimating()
            
        case .success(let product):
            loadingView.stopAnimating()
            configureProduct(product)
            
        case .error(let message):
            loadingView.stopAnimating()
            showError(message)
        }
    }
    
    private func configureProduct(_ product: Product) {
        title = product.name
        brandLabel.text = product.brand.displayName.uppercased()
        nameLabel.text = product.name
        priceLabel.text = product.formattedPrice
        descriptionLabel.text = product.description
        
        if let url = product.imageURL {
            loadImage(from: url)
        } else {
            imageView.image = UIImage(systemName: "photo")
        }
        
        if product.reviewCount > 0 {
            ratingLabel.text = String(format: "%.1f", product.averageRating)
            reviewCountLabel.text = "(\(product.reviewCount) reviews)"
            ratingStackView.isHidden = false
        } else {
            ratingStackView.isHidden = true
        }
        
        if product.isInStock {
            stockLabel.text = "In Stock: \(product.stockQuantity) available"
            stockLabel.textColor = AppColors.success
            addToCartButton.isEnabled = true
            addToCartButton.alpha = 1.0
        } else {
            stockLabel.text = "Out of Stock"
            stockLabel.textColor = AppColors.error
            addToCartButton.isEnabled = false
            addToCartButton.alpha = 0.5
        }
    }
    
    private func renderActionState(_ actionState: ProductDetailViewModel.ActionState) {
        switch actionState {
        case .idle:
            addToCartButton.isEnabled = true
            wishlistButton.isEnabled = true
            
        case .addingToCart:
            addToCartButton.isEnabled = false
            
        case .addedToCart:
            addToCartButton.isEnabled = true
            showSuccess("Added to cart!")
            
        case .addingToWishlist:
            wishlistButton.isEnabled = false
            
        case .addedToWishlist:
            wishlistButton.isEnabled = true
            wishlistButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            showSuccess("Added to wishlist!")
            
        case .error(let message):
            addToCartButton.isEnabled = true
            wishlistButton.isEnabled = true
            showError(message)
        }
    }
    
    private func loadImage(from url: URL) {
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    await MainActor.run {
                        imageView.image = image
                    }
                }
            } catch {
                await MainActor.run {
                    imageView.image = UIImage(systemName: "photo")
                }
            }
        }
    }
    
    @objc private func decreaseTapped() {
        viewModel.decreaseQuantity()
    }
    
    @objc private func increaseTapped() {
        viewModel.increaseQuantity()
    }
    
    @objc private func addToCartTapped() {
        viewModel.addToCart()
    }
    
    @objc private func wishlistTapped() {
        viewModel.addToWishlist()
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
    
    private func showSuccess(_ message: String) {
        let alert = UIAlertController(
            title: "Success",
            message: message,
            preferredStyle: .alert
        )
        present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            alert.dismiss(animated: true)
        }
    }
}
