
import UIKit
import Combine

final class HomeViewController: UIViewController {
    
    private let viewModel: HomeViewModel
    private var cancellables = Set<AnyCancellable>()
    
    var onProductTapped: ((Int) -> Void)?
    var onCategoryTapped: ((ProductType) -> Void)?
    
    private let bannerImageURLs: [URL] = [
        URL(string: "https://assets.adidas.com/images/h_2000,f_auto,q_auto,fl_lossy,c_fill,g_auto/f63d6abefd494c4f9c3cdc81c9c57bdc_9366/Adizero_EVO_SL_Shoes_Black_KJ1363_01_00_standard.jpg")!,
        URL(string: "https://assets.adidas.com/images/h_2000,f_auto,q_auto,fl_lossy,c_fill,g_auto/4c6886694e564bd8ac716168bfa219e4_9366/Fear_of_God_Athletics_II_Basketball_Shoes_Green_JP6006_HM1.jpg")!,
        URL(string: "https://assets.adidas.com/images/h_2000,f_auto,q_auto,fl_lossy,c_fill,g_auto/ae33c80e55f1488fa3ce694bc950eece_9366/Fear_of_God_Athletics_II_Basketball_Shoes_Grey_HQ9426_HM1.jpg")!
    ]
    
    private var currentBannerIndex = 0
    private var autoScrollTimer: Timer?
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = AppColors.textSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Ayaq"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = AppColors.primary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let taglineLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Premium Sport Shoes Destination"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = AppColors.textSecondary
        label.numberOfLines = 2
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sectionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "New Arrivals"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = AppColors.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.primary
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var bannerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = false
        cv.decelerationRate = .fast
        cv.delegate = self
        cv.dataSource = self
        cv.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPageIndicatorTintColor = AppColors.primary
        pc.pageIndicatorTintColor = AppColors.divider
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()
    
    private let loadingView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = AppColors.primary
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.tintColor = AppColors.primary
        return rc
    }()
    
    private lazy var categorySectionsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    init(viewModel: HomeViewModel) {
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
        startAutoScroll()
        viewModel.loadHomeData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAutoScroll()
    }
    
    private func setupUI() {
        view.backgroundColor = AppColors.background
        title = "Home"
        
        pageControl.numberOfPages = bannerImageURLs.count
        pageControl.currentPage = 0
        
        scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(welcomeLabel)
        contentView.addSubview(appNameLabel)
        contentView.addSubview(taglineLabel)
        contentView.addSubview(dividerView)
        contentView.addSubview(sectionTitleLabel)
        contentView.addSubview(bannerCollectionView)
        contentView.addSubview(pageControl)
        contentView.addSubview(categorySectionsStack)
        
        view.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            welcomeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            welcomeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            appNameLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 4),
            appNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            taglineLabel.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 4),
            taglineLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            taglineLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            dividerView.topAnchor.constraint(equalTo: taglineLabel.bottomAnchor, constant: 16),
            dividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dividerView.widthAnchor.constraint(equalToConstant: 40),
            dividerView.heightAnchor.constraint(equalToConstant: 3),
            
            sectionTitleLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 24),
            sectionTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            bannerCollectionView.topAnchor.constraint(equalTo: sectionTitleLabel.bottomAnchor, constant: 16),
            bannerCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bannerCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bannerCollectionView.heightAnchor.constraint(equalToConstant: 180),
            
            pageControl.topAnchor.constraint(equalTo: bannerCollectionView.bottomAnchor, constant: 8),
            pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 30),
            
            categorySectionsStack.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 32),
            categorySectionsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categorySectionsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            categorySectionsStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),
            
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
    }
    
    private func render(_ state: HomeViewModel.State) {
        switch state {
        case .idle:
            loadingView.stopAnimating()
            refreshControl.endRefreshing()
            
        case .loading:
            if !refreshControl.isRefreshing {
                loadingView.startAnimating()
            }
            
        case .loaded(let homeData):
            loadingView.stopAnimating()
            refreshControl.endRefreshing()
            displayCategorySections(homeData.categorySections)
            
        case .error(let message):
            loadingView.stopAnimating()
            refreshControl.endRefreshing()
            showError(message)
        }
    }
    
    private func displayCategorySections(_ sections: [HomeViewModel.CategorySection]) {
        categorySectionsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for section in sections {
            let sectionView = CategorySectionView()
            sectionView.configure(title: section.title, products: section.products)
            
            sectionView.onProductTapped = { [weak self] productId in
                self?.onProductTapped?(productId)
            }
            
            sectionView.onSeeAllTapped = { [weak self] in
                self?.onCategoryTapped?(section.type)
            }
            
            categorySectionsStack.addArrangedSubview(sectionView)
        }
    }
    
    @objc private func handleRefresh() {
        viewModel.refresh()
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
    
    private func startAutoScroll() {
        autoScrollTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            self?.scrollToNextBanner()
        }
    }
    
    private func stopAutoScroll() {
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
    }
    
    private func scrollToNextBanner() {
        currentBannerIndex = (currentBannerIndex + 1) % bannerImageURLs.count
        
        let indexPath = IndexPath(item: currentBannerIndex, section: 0)
        bannerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage = currentBannerIndex
    }
    
    deinit {
        stopAutoScroll()
        cancellables.removeAll()
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bannerImageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.identifier, for: indexPath) as? BannerCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: bannerImageURLs[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 32
        return CGSize(width: width, height: 180)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.bounds.width
        
        guard pageWidth > 0 else { return }
        
        let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        
        if currentPage >= 0 && currentPage < bannerImageURLs.count {
            pageControl.currentPage = currentPage
            currentBannerIndex = currentPage
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopAutoScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startAutoScroll()
    }
}
