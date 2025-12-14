import UIKit

final class CategorySectionView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = AppColors.textPrimary
        return label
    }()
    
    private let seeAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("See All", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(AppColors.primary, for: .normal)
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(HomeProductCell.self, forCellWithReuseIdentifier: HomeProductCell.reuseIdentifier)
        return cv
    }()
    
    private var products: [Product] = []
    var onProductTapped: ((Int) -> Void)?
    var onSeeAllTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(seeAllButton)
        addSubview(collectionView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        seeAllButton.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        seeAllButton.addTarget(self, action: #selector(seeAllTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            seeAllButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            seeAllButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            seeAllButton.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 8),
            
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func configure(title: String, products: [Product]) {
        titleLabel.text = title
        self.products = products
        collectionView.reloadData()
    }
    
    @objc private func seeAllTapped() {
        onSeeAllTapped?()
    }
}

extension CategorySectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HomeProductCell.reuseIdentifier,
            for: indexPath
        ) as? HomeProductCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: products[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = products[indexPath.item]
        onProductTapped?(product.id)
    }
}
