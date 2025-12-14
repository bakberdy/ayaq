import UIKit

final class CartSummaryView: UIView {
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.1
        return view
    }()
    
    private let itemsCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = AppColors.textSecondary
        return label
    }()
    
    private let subtotalLabel: UILabel = {
        let label = UILabel()
        label.text = "Subtotal"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = AppColors.textPrimary
        return label
    }()
    
    private let subtotalValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = AppColors.textPrimary
        label.textAlignment = .right
        return label
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.divider
        return view
    }()
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.text = "Total"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = AppColors.textPrimary
        return label
    }()
    
    private let totalValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = AppColors.primary
        label.textAlignment = .right
        return label
    }()
    
    private let checkoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Proceed to Checkout", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = AppColors.primary
        button.layer.cornerRadius = 12
        return button
    }()
    
    var onCheckoutTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = AppColors.background
        
        addSubview(containerView)
        containerView.addSubview(itemsCountLabel)
        containerView.addSubview(subtotalLabel)
        containerView.addSubview(subtotalValueLabel)
        containerView.addSubview(dividerView)
        containerView.addSubview(totalLabel)
        containerView.addSubview(totalValueLabel)
        containerView.addSubview(checkoutButton)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        itemsCountLabel.translatesAutoresizingMaskIntoConstraints = false
        subtotalLabel.translatesAutoresizingMaskIntoConstraints = false
        subtotalValueLabel.translatesAutoresizingMaskIntoConstraints = false
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        totalValueLabel.translatesAutoresizingMaskIntoConstraints = false
        checkoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        checkoutButton.addTarget(self, action: #selector(checkoutTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            itemsCountLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            itemsCountLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            itemsCountLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            subtotalLabel.topAnchor.constraint(equalTo: itemsCountLabel.bottomAnchor, constant: 12),
            subtotalLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            
            subtotalValueLabel.centerYAnchor.constraint(equalTo: subtotalLabel.centerYAnchor),
            subtotalValueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            subtotalValueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: subtotalLabel.trailingAnchor, constant: 8),
            
            dividerView.topAnchor.constraint(equalTo: subtotalLabel.bottomAnchor, constant: 16),
            dividerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            dividerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            totalLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 16),
            totalLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            
            totalValueLabel.centerYAnchor.constraint(equalTo: totalLabel.centerYAnchor),
            totalValueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            totalValueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: totalLabel.trailingAnchor, constant: 8),
            
            checkoutButton.topAnchor.constraint(equalTo: totalLabel.bottomAnchor, constant: 20),
            checkoutButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            checkoutButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            checkoutButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            checkoutButton.heightAnchor.constraint(equalToConstant: 54)
        ])
    }
    
    func configure(itemCount: Int, total: String) {
        itemsCountLabel.text = "\(itemCount) item\(itemCount != 1 ? "s" : "") in cart"
        subtotalValueLabel.text = total
        totalValueLabel.text = total
    }
    
    @objc private func checkoutTapped() {
        onCheckoutTapped?()
    }
}
