import UIKit

final class ProductCell: UICollectionViewCell {
    static let reuseIdentifier = "ProductCell"
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = AppColors.surface
        iv.layer.cornerRadius = 12
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = AppColors.textPrimary
        label.numberOfLines = 2
        return label
    }()
    
    private let brandLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = AppColors.textSecondary
        label.numberOfLines = 1
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = AppColors.primary
        label.numberOfLines = 1
        return label
    }()
    
    private let ratingStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = AppColors.textPrimary
        return label
    }()
    
    private let reviewCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = AppColors.textSecondary
        return label
    }()
    
    private let starImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "star.fill")
        iv.tintColor = .systemYellow
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let stockBadge: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.isHidden = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOpacity = 0.1
        
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(brandLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(ratingStackView)
        contentView.addSubview(stockBadge)
        
        ratingStackView.addArrangedSubview(starImageView)
        ratingStackView.addArrangedSubview(ratingLabel)
        ratingStackView.addArrangedSubview(reviewCountLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        brandLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingStackView.translatesAutoresizingMaskIntoConstraints = false
        stockBadge.translatesAutoresizingMaskIntoConstraints = false
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.0),
            
            stockBadge.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 8),
            stockBadge.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8),
            stockBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
            stockBadge.heightAnchor.constraint(equalToConstant: 24),
            
            brandLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            brandLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            brandLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            nameLabel.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            ratingStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            ratingStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            ratingStackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8),
            
            starImageView.widthAnchor.constraint(equalToConstant: 12),
            starImageView.heightAnchor.constraint(equalToConstant: 12),
            
            priceLabel.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 6),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            priceLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with product: Product) {
        nameLabel.text = product.name
        brandLabel.text = product.brand.displayName
        priceLabel.text = product.formattedPrice
        
        if let url = product.imageURL {
            loadImage(from: url)
        } else {
            imageView.image = UIImage(systemName: "photo")
        }
        
        if product.reviewCount > 0 {
            ratingLabel.text = String(format: "%.1f", product.averageRating)
            reviewCountLabel.text = "(\(product.reviewCount))"
            ratingStackView.isHidden = false
        } else {
            ratingStackView.isHidden = true
        }
        
        if !product.isInStock {
            stockBadge.text = "Out of Stock"
            stockBadge.backgroundColor = AppColors.error
            stockBadge.isHidden = false
        } else if product.stockQuantity < 10 {
            stockBadge.text = "Low Stock"
            stockBadge.backgroundColor = .systemOrange
            stockBadge.isHidden = false
        } else {
            stockBadge.isHidden = true
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
        brandLabel.text = nil
        priceLabel.text = nil
        ratingLabel.text = nil
        reviewCountLabel.text = nil
        stockBadge.isHidden = true
    }
}
