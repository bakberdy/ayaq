import UIKit
import Combine

final class ProductDetailViewController: UIViewController {
    private let viewModel: ProductDetailViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = AppColors.background
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    private let contentView = UIView()
    
    private let imageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.surface
        view.layer.cornerRadius = 24
        view.layer.masksToBounds = true
        return view
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .clear
        return iv
    }()
    
    private let infoCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 12
        view.layer.shadowOpacity = 0.08
        return view
    }()
    
    private let brandLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = AppColors.primary
        label.layer.cornerRadius = 6
        label.clipsToBounds = true
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.textColor = AppColors.textPrimary
        label.numberOfLines = 0
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .heavy)
        label.textColor = AppColors.primary
        return label
    }()
    
    private let ratingContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.surface
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let ratingStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 6
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
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = AppColors.textPrimary
        return label
    }()
    
    private let reviewCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = AppColors.textSecondary
        return label
    }()
    
    private let stockBadgeView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = AppColors.textPrimary
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 12
        view.layer.shadowOpacity = 0.08
        return view
    }()
    
    private let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = AppColors.textPrimary
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = AppColors.textSecondary
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let quantityCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 12
        view.layer.shadowOpacity = 0.08
        return view
    }()
    
    private let quantityTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Quantity"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = AppColors.textPrimary
        return label
    }()
    
    private let quantityContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.surface
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = AppColors.textPrimary
        label.textAlignment = .center
        return label
    }()
    
    private let quantityHintLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = AppColors.textSecondary
        label.textAlignment = .center
        label.alpha = 0
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
    
    private let buttonContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add to Cart", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = AppColors.primary
        button.layer.cornerRadius = 16
        button.layer.shadowColor = AppColors.primary.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 12
        button.layer.shadowOpacity = 0.3
        return button
    }()
    
    private let wishlistButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        button.tintColor = AppColors.primary
        button.backgroundColor = AppColors.surface
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 2
        button.layer.borderColor = AppColors.primary.cgColor
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
        
        contentView.addSubview(imageContainerView)
        imageContainerView.addSubview(imageView)
        
        contentView.addSubview(infoCardView)
        infoCardView.addSubview(brandLabel)
        infoCardView.addSubview(nameLabel)
        infoCardView.addSubview(priceLabel)
        infoCardView.addSubview(ratingContainerView)
        infoCardView.addSubview(stockBadgeView)
        
        ratingContainerView.addSubview(ratingStackView)
        stockBadgeView.addSubview(stockLabel)
        
        ratingStackView.addArrangedSubview(starImageView)
        ratingStackView.addArrangedSubview(ratingLabel)
        ratingStackView.addArrangedSubview(reviewCountLabel)
        
        contentView.addSubview(descriptionCardView)
        descriptionCardView.addSubview(descriptionTitleLabel)
        descriptionCardView.addSubview(descriptionLabel)
        
        contentView.addSubview(quantityCardView)
        quantityCardView.addSubview(quantityTitleLabel)
        quantityCardView.addSubview(quantityContainerView)
        quantityCardView.addSubview(quantityHintLabel)
        
        quantityContainerView.addSubview(decreaseButton)
        quantityContainerView.addSubview(quantityLabel)
        quantityContainerView.addSubview(increaseButton)
        
        contentView.addSubview(buttonContainerView)
        buttonContainerView.addSubview(addToCartButton)
        buttonContainerView.addSubview(wishlistButton)
        
        view.addSubview(loadingView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        infoCardView.translatesAutoresizingMaskIntoConstraints = false
        brandLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingContainerView.translatesAutoresizingMaskIntoConstraints = false
        ratingStackView.translatesAutoresizingMaskIntoConstraints = false
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        stockBadgeView.translatesAutoresizingMaskIntoConstraints = false
        stockLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionCardView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        quantityCardView.translatesAutoresizingMaskIntoConstraints = false
        quantityTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        quantityContainerView.translatesAutoresizingMaskIntoConstraints = false
        quantityHintLabel.translatesAutoresizingMaskIntoConstraints = false
        decreaseButton.translatesAutoresizingMaskIntoConstraints = false
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        increaseButton.translatesAutoresizingMaskIntoConstraints = false
        buttonContainerView.translatesAutoresizingMaskIntoConstraints = false
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
            
            imageContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            imageContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imageContainerView.heightAnchor.constraint(equalTo: imageContainerView.widthAnchor, multiplier: 0.9),
            
            imageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor),
            
            infoCardView.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: 20),
            infoCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            infoCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            brandLabel.topAnchor.constraint(equalTo: infoCardView.topAnchor, constant: 20),
            brandLabel.leadingAnchor.constraint(equalTo: infoCardView.leadingAnchor, constant: 20),
            
            nameLabel.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: infoCardView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: infoCardView.trailingAnchor, constant: -20),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            priceLabel.leadingAnchor.constraint(equalTo: infoCardView.leadingAnchor, constant: 20),
            
            ratingContainerView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 16),
            ratingContainerView.leadingAnchor.constraint(equalTo: infoCardView.leadingAnchor, constant: 20),
            ratingContainerView.heightAnchor.constraint(equalToConstant: 32),
            
            ratingStackView.topAnchor.constraint(equalTo: ratingContainerView.topAnchor, constant: 6),
            ratingStackView.leadingAnchor.constraint(equalTo: ratingContainerView.leadingAnchor, constant: 12),
            ratingStackView.trailingAnchor.constraint(equalTo: ratingContainerView.trailingAnchor, constant: -12),
            ratingStackView.bottomAnchor.constraint(equalTo: ratingContainerView.bottomAnchor, constant: -6),
            
            starImageView.widthAnchor.constraint(equalToConstant: 16),
            starImageView.heightAnchor.constraint(equalToConstant: 16),
            
            stockBadgeView.centerYAnchor.constraint(equalTo: ratingContainerView.centerYAnchor),
            stockBadgeView.trailingAnchor.constraint(equalTo: infoCardView.trailingAnchor, constant: -20),
            stockBadgeView.heightAnchor.constraint(equalToConstant: 32),
            
            stockLabel.topAnchor.constraint(equalTo: stockBadgeView.topAnchor, constant: 6),
            stockLabel.leadingAnchor.constraint(equalTo: stockBadgeView.leadingAnchor, constant: 12),
            stockLabel.trailingAnchor.constraint(equalTo: stockBadgeView.trailingAnchor, constant: -12),
            stockLabel.bottomAnchor.constraint(equalTo: stockBadgeView.bottomAnchor, constant: -6),
            
            infoCardView.bottomAnchor.constraint(equalTo: stockBadgeView.bottomAnchor, constant: 20),
            
            descriptionCardView.topAnchor.constraint(equalTo: infoCardView.bottomAnchor, constant: 16),
            descriptionCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descriptionTitleLabel.topAnchor.constraint(equalTo: descriptionCardView.topAnchor, constant: 20),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: descriptionCardView.leadingAnchor, constant: 20),
            descriptionTitleLabel.trailingAnchor.constraint(equalTo: descriptionCardView.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: descriptionCardView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: descriptionCardView.trailingAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(equalTo: descriptionCardView.bottomAnchor, constant: -20),
            
            quantityCardView.topAnchor.constraint(equalTo: descriptionCardView.bottomAnchor, constant: 16),
            quantityCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            quantityCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            quantityTitleLabel.topAnchor.constraint(equalTo: quantityCardView.topAnchor, constant: 20),
            quantityTitleLabel.leadingAnchor.constraint(equalTo: quantityCardView.leadingAnchor, constant: 20),
            
            quantityContainerView.topAnchor.constraint(equalTo: quantityTitleLabel.bottomAnchor, constant: 16),
            quantityContainerView.centerXAnchor.constraint(equalTo: quantityCardView.centerXAnchor),
            quantityContainerView.heightAnchor.constraint(equalToConstant: 56),
            quantityContainerView.widthAnchor.constraint(equalToConstant: 180),
            
            decreaseButton.leadingAnchor.constraint(equalTo: quantityContainerView.leadingAnchor, constant: 16),
            decreaseButton.centerYAnchor.constraint(equalTo: quantityContainerView.centerYAnchor),
            decreaseButton.widthAnchor.constraint(equalToConstant: 36),
            decreaseButton.heightAnchor.constraint(equalToConstant: 36),
            
            quantityLabel.centerXAnchor.constraint(equalTo: quantityContainerView.centerXAnchor),
            quantityLabel.centerYAnchor.constraint(equalTo: quantityContainerView.centerYAnchor),
            
            increaseButton.trailingAnchor.constraint(equalTo: quantityContainerView.trailingAnchor, constant: -16),
            increaseButton.centerYAnchor.constraint(equalTo: quantityContainerView.centerYAnchor),
            increaseButton.widthAnchor.constraint(equalToConstant: 36),
            increaseButton.heightAnchor.constraint(equalToConstant: 36),
            
            quantityHintLabel.topAnchor.constraint(equalTo: quantityContainerView.bottomAnchor, constant: 8),
            quantityHintLabel.centerXAnchor.constraint(equalTo: quantityCardView.centerXAnchor),
            quantityHintLabel.bottomAnchor.constraint(equalTo: quantityCardView.bottomAnchor, constant: -16),
            
            buttonContainerView.topAnchor.constraint(equalTo: quantityCardView.bottomAnchor, constant: 24),
            buttonContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            buttonContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            buttonContainerView.heightAnchor.constraint(equalToConstant: 60),
            buttonContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),
            
            addToCartButton.topAnchor.constraint(equalTo: buttonContainerView.topAnchor),
            addToCartButton.leadingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor),
            addToCartButton.bottomAnchor.constraint(equalTo: buttonContainerView.bottomAnchor),
            addToCartButton.trailingAnchor.constraint(equalTo: wishlistButton.leadingAnchor, constant: -12),
            
            wishlistButton.topAnchor.constraint(equalTo: buttonContainerView.topAnchor),
            wishlistButton.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor),
            wishlistButton.bottomAnchor.constraint(equalTo: buttonContainerView.bottomAnchor),
            wishlistButton.widthAnchor.constraint(equalToConstant: 60),
            
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
        viewModel.$isInWishlist
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isInWishlist in
                self?.wishlistButton.isSelected = isInWishlist
            }
            .store(in: &cancellables)        
        viewModel.$quantity
            .receive(on: DispatchQueue.main)
            .sink { [weak self] quantity in
                self?.updateQuantityDisplay(quantity)
            }
            .store(in: &cancellables)
    }
    
    private func updateQuantityDisplay(_ quantity: Int) {
        quantityLabel.text = "\(quantity)"
        
        guard let product = viewModel.product else { return }
        let stockQuantity = product.stockQuantity
        
        decreaseButton.isEnabled = quantity > 1
        decreaseButton.alpha = quantity > 1 ? 1.0 : 0.5
        
        increaseButton.isEnabled = quantity < stockQuantity
        increaseButton.alpha = quantity < stockQuantity ? 1.0 : 0.5
        
        if quantity >= stockQuantity {
            showQuantityHint("Maximum available")
            increaseButton.tintColor = AppColors.textSecondary
        } else if quantity == 1 {
            showQuantityHint("Minimum quantity")
            decreaseButton.tintColor = AppColors.textSecondary
        } else {
            hideQuantityHint()
            increaseButton.tintColor = AppColors.primary
            decreaseButton.tintColor = AppColors.primary
        }
        
        UIView.animate(withDuration: 0.2) {
            self.quantityLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.quantityLabel.transform = .identity
            }
        }
    }
    
    private func showQuantityHint(_ message: String) {
        quantityHintLabel.text = message
        UIView.animate(withDuration: 0.3) {
            self.quantityHintLabel.alpha = 1.0
        }
    }
    
    private func hideQuantityHint() {
        UIView.animate(withDuration: 0.3) {
            self.quantityHintLabel.alpha = 0
        }
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
            reviewCountLabel.text = "(\(product.reviewCount))"
            ratingContainerView.isHidden = false
        } else {
            ratingContainerView.isHidden = true
        }
        
        if product.isInStock {
            if product.stockQuantity <= 5 {
                stockLabel.text = "Only \(product.stockQuantity) left!"
                stockBadgeView.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.15)
                stockLabel.textColor = .systemOrange
            } else {
                stockLabel.text = "In Stock"
                stockBadgeView.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.15)
                stockLabel.textColor = .systemGreen
            }
            addToCartButton.isEnabled = true
            addToCartButton.alpha = 1.0
            quantityCardView.isHidden = false
        } else {
            stockLabel.text = "Out of Stock"
            stockBadgeView.backgroundColor = UIColor.systemRed.withAlphaComponent(0.15)
            stockLabel.textColor = .systemRed
            addToCartButton.isEnabled = false
            addToCartButton.alpha = 0.5
            addToCartButton.setTitle("Out of Stock", for: .normal)
            quantityCardView.isHidden = true
        }
        
        updateQuantityDisplay(viewModel.quantity)
    }
    
    private func renderActionState(_ actionState: ProductDetailViewModel.ActionState) {
        switch actionState {
        case .idle:
            addToCartButton.isEnabled = true
            addToCartButton.setTitle("Add to Cart", for: .normal)
            wishlistButton.isEnabled = true
            
        case .addingToCart:
            addToCartButton.isEnabled = false
            addToCartButton.setTitle("Adding...", for: .normal)
            addToCartButton.alpha = 0.7
            
        case .addedToCart:
            addToCartButton.isEnabled = true
            addToCartButton.alpha = 1.0
            addToCartButton.setTitle("Added ✓", for: .normal)
            animateButton(addToCartButton)
            showSuccess("Added \(viewModel.quantity) item(s) to cart!")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                self?.addToCartButton.setTitle("Add to Cart", for: .normal)
            }
            
        case .addingToWishlist:
            wishlistButton.isEnabled = false
            wishlistButton.alpha = 0.7
            
        case .addedToWishlist:
            wishlistButton.isEnabled = true
            wishlistButton.alpha = 1.0
            showSuccess("Added to wishlist!")
            
        case .removingFromWishlist:
            wishlistButton.isEnabled = false
            wishlistButton.alpha = 0.7
            
        case .removedFromWishlist:
            wishlistButton.isEnabled = true
            wishlistButton.alpha = 1.0
            showSuccess("Removed from wishlist!")
            
        case .error(let message):
            addToCartButton.isEnabled = true
            addToCartButton.alpha = 1.0
            addToCartButton.setTitle("Add to Cart", for: .normal)
            wishlistButton.isEnabled = true
            wishlistButton.alpha = 1.0
            showError(message)
        }
    }
    
    private func animateButton(_ button: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1, animations: {
                button.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    button.transform = .identity
                }
            }
        }
    }
    
    private func animateHeartButton() {
        let scaleUp = CGAffineTransform(scaleX: 1.3, y: 1.3)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
            self.wishlistButton.transform = scaleUp
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: [.curveEaseInOut], animations: {
                self.wishlistButton.transform = .identity
            })
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
        guard viewModel.quantity > 1 else { return }
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        viewModel.decreaseQuantity()
    }
    
    @objc private func increaseTapped() {
        guard let product = viewModel.product,
              viewModel.quantity < product.stockQuantity else {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
            return
        }
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        viewModel.increaseQuantity()
    }
    
    @objc private func addToCartTapped() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        viewModel.addToCart()
    }
    
    @objc private func wishlistTapped() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        animateHeartButton()
        viewModel.toggleWishlist()
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
    
    deinit {
        cancellables.removeAll()
    }
}
