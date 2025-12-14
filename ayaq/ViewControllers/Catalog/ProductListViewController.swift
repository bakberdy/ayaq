import UIKit
import Combine

final class ProductListViewController: UIViewController {
    private let viewModel: ProductListViewModel
    private var cancellables = Set<AnyCancellable>()
    
    var onProductSelected: ((Int) -> Void)?
    
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Search products, brands, types..."
        sc.searchBar.tintColor = AppColors.primary
        return sc
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = AppColors.background
        cv.delegate = self
        cv.dataSource = self
        cv.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.reuseIdentifier)
        cv.refreshControl = refreshControl
        return cv
    }()
    
    private let refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.tintColor = AppColors.primary
        return rc
    }()
    
    private let loadingView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = AppColors.primary
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No products found"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = AppColors.textSecondary
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private let filterButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal.decrease.circle"),
            style: .plain,
            target: nil,
            action: nil
        )
        button.tintColor = AppColors.primary
        return button
    }()
    
    private let sortButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "arrow.up.arrow.down.circle"),
            style: .plain,
            target: nil,
            action: nil
        )
        button.tintColor = AppColors.primary
        return button
    }()
    
    private var products: [Product] = []
    
    init(viewModel: ProductListViewModel) {
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
        viewModel.loadInitialData()
    }
    
    private func setupUI() {
        title = "Catalog"
        view.backgroundColor = AppColors.background
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        navigationItem.rightBarButtonItems = [sortButton, filterButton]
        
        view.addSubview(collectionView)
        view.addSubview(loadingView)
        view.addSubview(emptyStateLabel)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
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
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        filterButton.target = self
        filterButton.action = #selector(showFilterOptions)
        sortButton.target = self
        sortButton.action = #selector(showSortOptions)
    }
    
    private func render(_ state: ProductListViewModel.State) {
        switch state {
        case .idle:
            loadingView.stopAnimating()
            refreshControl.endRefreshing()
            emptyStateLabel.isHidden = true
            
        case .loading:
            if !refreshControl.isRefreshing {
                loadingView.startAnimating()
            }
            emptyStateLabel.isHidden = true
            
        case .success(let products):
            loadingView.stopAnimating()
            refreshControl.endRefreshing()
            self.products = products
            collectionView.reloadData()
            emptyStateLabel.isHidden = !products.isEmpty
            
        case .error(let message):
            loadingView.stopAnimating()
            refreshControl.endRefreshing()
            showError(message)
        }
    }
    
    @objc private func handleRefresh() {
        viewModel.refresh()
    }
    
    @objc private func showFilterOptions() {
        let alertController = UIAlertController(
            title: "Filter Products",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let brandAction = UIAlertAction(title: "Filter by Brand", style: .default) { [weak self] _ in
            self?.showBrandFilter()
        }
        alertController.addAction(brandAction)
        
        let typeAction = UIAlertAction(title: "Filter by Type", style: .default) { [weak self] _ in
            self?.showTypeFilter()
        }
        alertController.addAction(typeAction)
        
        let clearAction = UIAlertAction(title: "Clear All Filters", style: .destructive) { [weak self] _ in
            self?.viewModel.clearAllFilters()
        }
        alertController.addAction(clearAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.barButtonItem = filterButton
        }
        
        present(alertController, animated: true)
    }
    
    private func showBrandFilter() {
        let filterVC = FilterViewController(
            title: "Brands",
            items: viewModel.brands.map { FilterItem(id: $0.id, name: $0.displayName) },
            selectedIds: viewModel.selectedBrands,
            onApply: { [weak self] selectedIds in
                self?.viewModel.selectedBrands = selectedIds
                self?.viewModel.applyFilters()
            }
        )
        navigationController?.pushViewController(filterVC, animated: true)
    }
    
    private func showTypeFilter() {
        let filterVC = FilterViewController(
            title: "Types",
            items: viewModel.types.map { FilterItem(id: $0.id, name: $0.displayName) },
            selectedIds: viewModel.selectedTypes,
            onApply: { [weak self] selectedIds in
                self?.viewModel.selectedTypes = selectedIds
                self?.viewModel.applyFilters()
            }
        )
        navigationController?.pushViewController(filterVC, animated: true)
    }
    
    @objc private func showSortOptions() {
        let alertController = UIAlertController(
            title: "Sort By",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        for option in ProductListViewModel.SortOption.allCases {
            let action = UIAlertAction(
                title: option.rawValue,
                style: .default
            ) { [weak self] _ in
                self?.viewModel.selectedSortOption = option
                self?.viewModel.applyFilters()
            }
            
            if viewModel.selectedSortOption == option {
                action.setValue(true, forKey: "checked")
            }
            
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.barButtonItem = sortButton
        }
        
        present(alertController, animated: true)
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
}

extension ProductListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchText = searchController.searchBar.text ?? ""
    }
}

extension ProductListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProductCell.reuseIdentifier,
            for: indexPath
        ) as? ProductCell else {
            return UICollectionViewCell()
        }
        
        let product = products[indexPath.item]
        cell.configure(with: product)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = products[indexPath.item]
        onProductSelected?(product.id)
    }
}

extension ProductListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let padding: CGFloat = 16
        let spacing: CGFloat = 12
        let availableWidth = collectionView.bounds.width - (padding * 2) - spacing
        let itemWidth = availableWidth / 2
        let itemHeight = itemWidth * 1.6
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
