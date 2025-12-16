import UIKit

final class ProfileInfoCard: UIView {
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = AppColors.primary
        return imageView
    }()
    
    private let iconContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AppColors.primary.withAlphaComponent(0.1)
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = AppColors.textSecondary
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = AppColors.textPrimary
        label.numberOfLines = 0
        return label
    }()
    
    init(icon: UIImage?, title: String) {
        super.init(frame: .zero)
        iconImageView.image = icon
        titleLabel.text = title
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = 14
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.06
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 8
        
        iconContainerView.addSubview(iconImageView)
        addSubview(iconContainerView)
        addSubview(titleLabel)
        addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            iconContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            iconContainerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconContainerView.widthAnchor.constraint(equalToConstant: 48),
            iconContainerView.heightAnchor.constraint(equalToConstant: 48),
            
            iconImageView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            valueLabel.leadingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant: 16),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    func setValue(_ value: String) {
        valueLabel.text = value
    }
}

