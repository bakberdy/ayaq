import UIKit
import Combine

final class CartViewController: UIViewController {
    private let viewModel: CartViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = AppColors.background
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(CartItemCell.self, forCellReuseIdentifier: "CartItemCell")
        table.rowHeight = 116
        return table
    }()
    
    private let summaryView: CartSummaryView = {
        let view = CartSummaryView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emptyStateView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.background
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "cart")
        imageView.tintColor = AppColors.textSecondary
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Your cart is empty"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = AppColors.textPrimary
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emptySubLabel: UILabel = {
        let label = UILabel()
        label.text = "Add items to get started"
        label.font = .systemFont(ofSize: 16)
        label.textColor = AppColors.textSecondary
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let startShoppingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start Shopping", for: .normal)
        button.backgroundColor = AppColors.primary
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let loadingView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = AppColors.primary
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = AppColors.primary
        return control
    }()
    
    private var cartItems: [CartItem] = []
    
    var onCheckout: (() -> Void)?
    var onContinueShopping: (() -> Void)?
    
    init(viewModel: CartViewModel) {
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
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadCart()
    }
    
    private func setupUI() {
        view.backgroundColor = AppColors.background
        title = "My Cart"
        
        view.addSubview(tableView)
        view.addSubview(summaryView)
        view.addSubview(emptyStateView)
        view.addSubview(loadingView)
        
        emptyStateView.addSubview(emptyImageView)
        emptyStateView.addSubview(emptyLabel)
        emptyStateView.addSubview(emptySubLabel)
        emptyStateView.addSubview(startShoppingButton)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(refreshCart), for: .valueChanged)
        startShoppingButton.addTarget(self, action: #selector(startShoppingTapped), for: .touchUpInside)
        
        summaryView.onCheckoutTapped = { [weak self] in
            self?.onCheckout?()
        }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: summaryView.topAnchor),
            
            summaryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            summaryView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            summaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            summaryView.heightAnchor.constraint(equalToConstant: 220),
            
            emptyStateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            emptyImageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyImageView.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor, constant: -80),
            emptyImageView.widthAnchor.constraint(equalToConstant: 100),
            emptyImageView.heightAnchor.constraint(equalToConstant: 100),
            
            emptyLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 24),
            emptyLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor, constant: 20),
            emptyLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor, constant: -20),
            
            emptySubLabel.topAnchor.constraint(equalTo: emptyLabel.bottomAnchor, constant: 8),
            emptySubLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor, constant: 20),
            emptySubLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor, constant: -20),
            
            startShoppingButton.topAnchor.constraint(equalTo: emptySubLabel.bottomAnchor, constant: 32),
            startShoppingButton.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            startShoppingButton.widthAnchor.constraint(equalToConstant: 200),
            startShoppingButton.heightAnchor.constraint(equalToConstant: 50),
            
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        let clearButton = UIBarButtonItem(
            title: "Clear",
            style: .plain,
            target: self,
            action: #selector(clearCartTapped)
        )
        clearButton.tintColor = AppColors.error
        navigationItem.rightBarButtonItem = clearButton
    }
    
    private func setupBindings() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.render(state)
            }
            .store(in: &cancellables)
    }
    
    private func render(_ state: CartViewModel.State) {
        refreshControl.endRefreshing()
        
        switch state {
        case .idle:
            loadingView.stopAnimating()
            
        case .loading:
            loadingView.startAnimating()
            emptyStateView.isHidden = true
            tableView.isHidden = false
            summaryView.isHidden = false
            
        case .loaded(let cart):
            loadingView.stopAnimating()
            cartItems = cart.items ?? []
            
            if cartItems.isEmpty {
                showEmptyState()
            } else {
                showCart(cart: cart)
            }
            
        case .error(let message):
            loadingView.stopAnimating()
            showError(message)
        }
    }
    
    private func showCart(cart: Cart) {
        emptyStateView.isHidden = true
        tableView.isHidden = false
        summaryView.isHidden = false
        
        tableView.reloadData()
        summaryView.configure(itemCount: cart.uniqueItemCount, total: cart.formattedTotalPrice)
        
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    private func showEmptyState() {
        emptyStateView.isHidden = false
        tableView.isHidden = true
        summaryView.isHidden = true
        
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.viewModel.loadCart()
        })
        present(alert, animated: true)
    }
    
    @objc private func refreshCart() {
        viewModel.loadCart()
    }
    
    @objc private func clearCartTapped() {
        let alert = UIAlertController(
            title: "Clear Cart",
            message: "Are you sure you want to remove all items from your cart?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Clear", style: .destructive) { [weak self] _ in
            self?.viewModel.clearCart()
        })
        
        present(alert, animated: true)
    }
    
    @objc private func startShoppingTapped() {
        onContinueShopping?()
    }
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath) as? CartItemCell else {
            return UITableViewCell()
        }
        
        let item = cartItems[indexPath.row]
        cell.configure(with: item)
        cell.selectionStyle = .none
        
        cell.onIncreaseQuantity = { [weak self] in
            self?.viewModel.increaseQuantity(itemId: item.id)
        }
        
        cell.onDecreaseQuantity = { [weak self] in
            self?.viewModel.decreaseQuantity(itemId: item.id)
        }
        
        cell.onDelete = { [weak self] in
            self?.confirmDelete(item: item)
        }
        
        return cell
    }
    
    private func confirmDelete(item: CartItem) {
        let alert = UIAlertController(
            title: "Remove Item",
            message: "Are you sure you want to remove this item from your cart?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Remove", style: .destructive) { [weak self] _ in
            self?.viewModel.removeItem(itemId: item.id)
        })
        
        present(alert, animated: true)
    }
}
