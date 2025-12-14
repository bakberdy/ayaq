---
applyTo: '**'
---
Project Structure Overview
ECommerceApp/
├── App/
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   └── Constants.swift
│
├── Network/
│   ├── APIClient.swift
│   ├── APIEndpoints.swift
│   ├── APIError.swift
│   └── NetworkModels/
│       ├── DTOs.swift
│       ├── RequestModels.swift
│       └── ResponseModels.swift
│
├── Services/
│   ├── Auth/
│   │   ├── AuthServiceProtocol.swift
│   │   ├── AuthService.swift
│   │   └── TokenManager.swift
│   ├── Cart/
│   │   ├── CartServiceProtocol.swift
│   │   └── CartService.swift
│   ├── Product/
│   │   ├── CatalogServiceProtocol.swift
│   │   ├── CatalogService.swift
│   │   ├── BrandServiceProtocol.swift
│   │   ├── BrandService.swift
│   │   ├── TypeServiceProtocol.swift
│   │   └── TypeService.swift
│   ├── Order/
│   │   ├── OrderServiceProtocol.swift
│   │   └── OrderService.swift
│   ├── Wishlist/
│   │   ├── WishlistServiceProtocol.swift
│   │   └── WishlistService.swift
│   ├── Review/
│   │   ├── ReviewServiceProtocol.swift
│   │   └── ReviewService.swift
│   ├── User/
│   │   ├── UserServiceProtocol.swift
│   │   └── UserService.swift
│   └── Admin/
│       ├── AdminServiceProtocol.swift
│       └── AdminService.swift
│
├── Models/
│   ├── LocalModels.swift
│   ├── CoreDataModels/
│   │   └── CoreDataStack.swift
│   └── Enums.swift
│
├── ViewModels/
│   ├── Base/
│   │   └── BaseViewModel.swift
│   ├── Auth/
│   │   ├── LoginViewModel.swift
│   │   ├── RegisterViewModel.swift
│   │   ├── PasswordResetViewModel.swift
│   │   └── ChangePasswordViewModel.swift
│   ├── Catalog/
│   │   ├── ProductListViewModel.swift
│   │   ├── ProductDetailViewModel.swift
│   │   ├── BrandListViewModel.swift
│   │   └── TypeListViewModel.swift
│   ├── Cart/
│   │   └── CartViewModel.swift
│   ├── Wishlist/
│   │   └── WishlistViewModel.swift
│   ├── Orders/
│   │   ├── OrderListViewModel.swift
│   │   ├── OrderDetailViewModel.swift
│   │   ├── CheckoutViewModel.swift
│   │   └── OrderConfirmationViewModel.swift
│   ├── Reviews/
│   │   ├── ReviewListViewModel.swift
│   │   ├── CreateReviewViewModel.swift
│   │   └── EditReviewViewModel.swift
│   ├── Profile/
│   │   ├── ProfileViewModel.swift
│   │   └── EditProfileViewModel.swift
│   └── Admin/
│       ├── AdminDashboardViewModel.swift
│       ├── SalesReportViewModel.swift
│       ├── InventorySummaryViewModel.swift
│       └── ActivityLogsViewModel.swift
│
├── ViewControllers/
│   ├── Common/
│   │   ├── BaseViewController.swift
│   │   ├── BaseNavigationController.swift
│   │   └── LoadingViewController.swift
│   ├── Auth/
│   │   ├── LoginViewController.swift
│   │   ├── RegisterViewController.swift
│   │   ├── PasswordResetViewController.swift
│   │   └── ChangePasswordViewController.swift
│   ├── Home/
│   │   └── HomeViewController.swift
│   ├── Catalog/
│   │   ├── ProductListViewController.swift
│   │   ├── ProductDetailViewController.swift
│   │   ├── BrandListViewController.swift
│   │   └── TypeListViewController.swift
│   ├── Cart/
│   │   └── CartViewController.swift
│   ├── Wishlist/
│   │   └── WishlistViewController.swift
│   ├── Orders/
│   │   ├── OrderListViewController.swift
│   │   ├── OrderDetailViewController.swift
│   │   ├── CheckoutViewController.swift
│   │   └── OrderConfirmationViewController.swift
│   ├── Reviews/
│   │   ├── ReviewListViewController.swift
│   │   ├── CreateReviewViewController.swift
│   │   └── EditReviewViewController.swift
│   ├── Profile/
│   │   ├── ProfileViewController.swift
│   │   ├── EditProfileViewController.swift
│   │   └── UserDetailViewController.swift
│   ├── Admin/
│   │   ├── AdminDashboardViewController.swift
│   │   ├── SalesReportViewController.swift
│   │   ├── InventorySummaryViewController.swift
│   │   └── ActivityLogsViewController.swift
│   └── Support/
│       └── SupportViewController.swift
│
├── Views/
│   ├── Common/
│   │   ├── LoadingView.swift
│   │   ├── EmptyStateView.swift
│   │   ├── ErrorView.swift
│   │   ├── CustomButtons.swift
│   │   └── ActivityIndicator.swift
│   ├── Cart/
│   │   ├── CartItemCell.swift
│   │   └── CartSummaryView.swift
│   ├── Catalog/
│   │   ├── ProductCell.swift
│   │   ├── ProductDetailView.swift
│   │   ├── BrandCell.swift
│   │   └── TypeCell.swift
│   ├── Orders/
│   │   ├── OrderCell.swift
│   │   ├── OrderItemCell.swift
│   │   ├── ShippingMethodView.swift
│   │   └── ShippingDetailsView.swift
│   ├── Reviews/
│   │   ├── ReviewCell.swift
│   │   ├── RatingView.swift
│   │   └── ReviewFormView.swift
│   └── Profile/
│       └── UserInfoView.swift
│
├── Coordinators/
│   ├── Coordinator.swift (Protocol)
│   ├── AppCoordinator.swift
│   ├── AuthCoordinator.swift
│   ├── HomeCoordinator.swift
│   ├── CartCoordinator.swift
│   ├── OrderCoordinator.swift
│   └── ProfileCoordinator.swift
│
├── Managers/
│   ├── KeychainManager.swift
│   ├── UserDefaultsManager.swift
│   ├── DatabaseManager.swift
│   └── CacheManager.swift
│
├── Utilities/
│   ├── Extensions/
│   │   ├── UIViewControllerExtensions.swift
│   │   ├── UIViewExtensions.swift
│   │   ├── StringExtensions.swift
│   │   ├── DateExtensions.swift
│   │   └── URLExtensions.swift
│   ├── Validators/
│   │   ├── EmailValidator.swift
│   │   ├── PasswordValidator.swift
│   │   └── FormValidator.swift
│   ├── Formatters/
│   │   ├── PriceFormatter.swift
│   │   ├── DateFormatter.swift
│   │   └── ImageFormatter.swift
│   └── Helpers/
│       ├── AlertHelper.swift
│       ├── NavigationHelper.swift
│       └── LoggingHelper.swift
│
└── Resources/
    ├── Assets.xcassets/
    ├── Localization/
    │   └── Localizable.strings
    └── Colors.xcassets/


MVVM Pattern Architecture
What is MVVM?
Model → Data models (DTOs, local models) View → UIViewController + XIB/Storyboard (displays data) ViewModel→ Business logic, state management, data binding

Layer Breakdown
1. Model Layer
DTOs (from API)
Network/NetworkModels/DTOs.swift
├── CartDTO
├── CatalogItemDTO
├── OrderDTO
├── ApplicationUserDTO
├── CatalogItemReviewDTO
├── WishlistDTO
└── ... (all DTO responses from API)

Local Models
Models/LocalModels.swift
├── User (local representation)
├── Product (local representation)
├── CartItem (local representation)
├── Order (local representation)
└── ... (models used throughout the app)



Don't leave any comments. 
All Changes make inside ayaq folder.
use snapkit to set constraints
