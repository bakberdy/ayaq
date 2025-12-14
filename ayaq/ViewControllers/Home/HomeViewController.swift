//
//  HomeViewController.swift
//  ayaq
//
//  Created on 14/12/2025.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private let bannerImageURLs: [URL] = [
        URL(string: "https://sneakertown.kz/upload/resize_cache/iblock/01a/450_450_140cd750bba9870f18aada2478b24840a/08rv0o5uzpht3dbd56042m7e65gstbce.jpg")!,
        URL(string: "https://sneakertown.kz/upload/resize_cache/iblock/b65/450_450_140cd750bba9870f18aada2478b24840a/lop913xqd4akwt53em8paw3t6fz4rwa3.jpg")!,
        URL(string: "https://sneakertown.kz/upload/resize_cache/iblock/017/450_450_140cd750bba9870f18aada2478b24840a/4znbe1z0gpsoi96prw0gbcsyv2rjcf47.jpg")!
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
    
    private let categoriesLabel: UILabel = {
        let label = UILabel()
        label.text = "Shop by Category"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = AppColors.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var categoriesStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Featured Products"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = AppColors.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startAutoScroll()
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
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(welcomeLabel)
        contentView.addSubview(appNameLabel)
        contentView.addSubview(taglineLabel)
        contentView.addSubview(dividerView)
        contentView.addSubview(sectionTitleLabel)
        contentView.addSubview(bannerCollectionView)
        contentView.addSubview(pageControl)
        contentView.addSubview(categoriesLabel)
        contentView.addSubview(categoriesStackView)
        
        setupCategories()
        
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
            
            categoriesLabel.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 32),
            categoriesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            categoriesStackView.topAnchor.constraint(equalTo: categoriesLabel.bottomAnchor, constant: 16),
            categoriesStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            categoriesStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            categoriesStackView.heightAnchor.constraint(equalToConstant: 100),
            categoriesStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }
    
    private func setupCategories() {
        let categories = [
            ("Running", "🏃"),
            ("Basketball", "🏀"),
            ("Football", "⚽️")
        ]
        
        for (title, emoji) in categories {
            let button = createCategoryButton(title: title, emoji: emoji)
            categoriesStackView.addArrangedSubview(button)
        }
    }
    
    private func createCategoryButton(title: String, emoji: String) -> UIView {
        let container = UIView()
        container.backgroundColor = AppColors.surface
        container.layer.cornerRadius = 12
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.08
        container.layer.shadowOffset = CGSize(width: 0, height: 2)
        container.layer.shadowRadius = 8
        
        let emojiLabel = UILabel()
        emojiLabel.text = emoji
        emojiLabel.font = .systemFont(ofSize: 32)
        emojiLabel.textAlignment = .center
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = AppColors.textPrimary
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(emojiLabel)
        container.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            emojiLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 20),
            
            titleLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(categoryTapped))
        container.addGestureRecognizer(tapGesture)
        
        return container
    }
    
    @objc private func categoryTapped() {
        
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
