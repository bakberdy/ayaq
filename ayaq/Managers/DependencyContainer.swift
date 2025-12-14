import Foundation

final class DependencyContainer {
    private let tokenManager: TokenManager
    private let authInterceptor: AuthenticationInterceptor
    private let apiClient: APIClientProtocol
    
    init() {
        self.tokenManager = TokenManager.shared
        self.authInterceptor = AuthenticationInterceptor()
        self.apiClient = APIClient(authInterceptor: authInterceptor)
    }
    
    func makeAuthService() -> AuthServiceProtocol {
        AuthService(apiClient: apiClient, tokenManager: tokenManager)
    }
    
    func makeCartService() -> CartServiceProtocol {
        CartService(apiClient: apiClient)
    }
    
    func makeCatalogService() -> CatalogServiceProtocol {
        CatalogService(apiClient: apiClient)
    }
    
    func makeBrandService() -> BrandServiceProtocol {
        BrandService(apiClient: apiClient)
    }
    
    func makeTypeService() -> TypeServiceProtocol {
        TypeService(apiClient: apiClient)
    }
    
    func makeOrderService() -> OrderServiceProtocol {
        OrderService(apiClient: apiClient)
    }
    
    func makeReviewService() -> ReviewServiceProtocol {
        ReviewService(apiClient: apiClient)
    }
    
    func makeUserService() -> UserServiceProtocol {
        UserService(apiClient: apiClient)
    }
    
    func makeWishlistService() -> WishlistServiceProtocol {
        WishlistService(apiClient: apiClient)
    }
    
    func makeAdminService() -> AdminServiceProtocol {
        AdminService(apiClient: apiClient)
    }
    
    func makeLoginViewModel() -> LoginViewModel {
        LoginViewModel(authService: makeAuthService())
    }
    
    func makeRegisterViewModel() -> RegisterViewModel {
        RegisterViewModel(authService: makeAuthService())
    }
    
    func makeForgotPasswordViewModel() -> ForgotPasswordViewModel {
        ForgotPasswordViewModel(authService: makeAuthService())
    }
    
    func makeResetPasswordViewModel() -> ResetPasswordViewModel {
        ResetPasswordViewModel(authService: makeAuthService())
    }
    
    func makeCartViewModel(userId: String) -> CartViewModel {
        CartViewModel(cartService: makeCartService(), userId: userId)
    }
    
    func makeCatalogViewModel() -> CatalogViewModel {
        CatalogViewModel(
            catalogService: makeCatalogService(),
            brandService: makeBrandService(),
            typeService: makeTypeService()
        )
    }
    
    func makeProfileViewModel() -> ProfileViewModel {
        ProfileViewModel(userService: makeUserService(), authService: makeAuthService())
    }
    
    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(catalogService: makeCatalogService(), brandService: makeBrandService())
    }
}
