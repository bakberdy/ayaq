import UIKit

final class CartItemCell: UITableViewCell {
    static let reuseIdentifier = "CartItemCell"
    
    private let productImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = AppColors.surface
        iv.layer.cornerRadius = 12
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = AppColors.textPrimary
        label.numberOfLines = 2
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = AppColors.primary
        return label
    }()
    
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = AppColors.textPrimary
        label.textAlignment = .right
        return label
    }()
    
    private let quantityContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.surface
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
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
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        button.tintColor = AppColors.error
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = AppColors.primary
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    var onIncreaseQuantity: (() -> Void)?
    var onDecreaseQuantity: (() -> Void)?
    var onDelete: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOpacity = 0.08
        
        contentView.addSubview(productImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(totalPriceLabel)
        contentView.addSubview(quantityContainerView)
        contentView.addSubview(deleteButton)
        contentView.addSubview(loadingIndicator)
        
        quantityContainerView.addSubview(decreaseButton)
        quantityContainerView.addSubview(quantityLabel)
        quantityContainerView.addSubview(increaseButton)
        
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        totalPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        quantityContainerView.translatesAutoresizingMaskIntoConstraints = false
        decreaseButton.translatesAutoresizingMaskIntoConstraints = false
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        increaseButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            productImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),
            productImageView.widthAnchor.constraint(equalToConstant: 80),
            productImageView.heightAnchor.constraint(equalToConstant: 80),
            
            nameLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 12),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -8),
            
            priceLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 12),
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            
            quantityContainerView.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 12),
            quantityContainerView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 12),
            quantityContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            quantityContainerView.heightAnchor.constraint(equalToConstant: 36),
            quantityContainerView.widthAnchor.constraint(equalToConstant: 110),
            
            decreaseButton.leadingAnchor.constraint(equalTo: quantityContainerView.leadingAnchor, constant: 8),
            decreaseButton.centerYAnchor.constraint(equalTo: quantityContainerView.centerYAnchor),
            decreaseButton.widthAnchor.constraint(equalToConstant: 24),
            decreaseButton.heightAnchor.constraint(equalToConstant: 24),
            
            quantityLabel.centerXAnchor.constraint(equalTo: quantityContainerView.centerXAnchor),
            quantityLabel.centerYAnchor.constraint(equalTo: quantityContainerView.centerYAnchor),
            quantityLabel.widthAnchor.constraint(equalToConstant: 40),
            
            increaseButton.trailingAnchor.constraint(equalTo: quantityContainerView.trailingAnchor, constant: -8),
            increaseButton.centerYAnchor.constraint(equalTo: quantityContainerView.centerYAnchor),
            increaseButton.widthAnchor.constraint(equalToConstant: 24),
            increaseButton.heightAnchor.constraint(equalToConstant: 24),
            
            totalPriceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            totalPriceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            deleteButton.widthAnchor.constraint(equalToConstant: 28),
            deleteButton.heightAnchor.constraint(equalToConstant: 28),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: quantityContainerView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: quantityContainerView.centerYAnchor)
        ])
        
        decreaseButton.addTarget(self, action: #selector(decreaseTapped), for: .touchUpInside)
        increaseButton.addTarget(self, action: #selector(increaseTapped), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
    }
    
    func configure(with item: CartItem, isUpdating: Bool = false) {
        nameLabel.text = item.productName
        quantityLabel.text = "\(item.quantity)"
        
        priceLabel.text = item.formattedUnitPrice
        totalPriceLabel.text = item.formattedTotalPrice
        
        if let url = item.imageURL {
            loadImage(from: url)
        } else {
            productImageView.image = UIImage(systemName: "photo")
        }
        
        setUpdating(isUpdating)
    }
    
    func setUpdating(_ isUpdating: Bool) {
        if isUpdating {
            loadingIndicator.startAnimating()
            quantityLabel.isHidden = true
            decreaseButton.isEnabled = false
            increaseButton.isEnabled = false
            deleteButton.isEnabled = false
        } else {
            loadingIndicator.stopAnimating()
            quantityLabel.isHidden = false
            decreaseButton.isEnabled = true
            increaseButton.isEnabled = true
            deleteButton.isEnabled = true
        }
    }
    
    private func loadImage(from url: URL) {
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    await MainActor.run {
                        productImageView.image = image
                    }
                }
            } catch {
                await MainActor.run {
                    productImageView.image = UIImage(systemName: "photo")
                }
            }
        }
    }
    
    @objc private func decreaseTapped() {
        onDecreaseQuantity?()
    }
    
    @objc private func increaseTapped() {
        onIncreaseQuantity?()
    }
    
    @objc private func deleteTapped() {
        onDelete?()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        nameLabel.text = nil
        priceLabel.text = nil
        totalPriceLabel.text = nil
        quantityLabel.text = nil
        loadingIndicator.stopAnimating()
    }
}
