import Foundation
import Combine

@MainActor
final class ProductDetailViewModel: ObservableObject {
    enum State: Equatable {
        case idle
        case loading
        case success(Product)
        case error(String)
    }
    
    enum ActionState: Equatable {
        case idle
        case addingToCart
        case addedToCart
        case addingToWishlist
        case addedToWishlist
        case error(String)
    }
    
    @Published private(set) var state: State = .idle
    @Published private(set) var actionState: ActionState = .idle
    @Published var quantity: Int = 1
    
    private let productId: Int
    private let catalogService: CatalogServiceProtocol
    private let cartService: CartServiceProtocol
    private let wishlistService: WishlistServiceProtocol
    private let tokenManager: TokenManager
    
    private var loadTask: Task<Void, Never>?
    private var actionTask: Task<Void, Never>?
    
    var product: Product? {
        if case .success(let product) = state {
            return product
        }
        return nil
    }
    
    init(
        productId: Int,
        catalogService: CatalogServiceProtocol,
        cartService: CartServiceProtocol,
        wishlistService: WishlistServiceProtocol,
        tokenManager: TokenManager
    ) {
        self.productId = productId
        self.catalogService = catalogService
        self.cartService = cartService
        self.wishlistService = wishlistService
        self.tokenManager = tokenManager
    }
    
    func loadProduct() {
        loadTask?.cancel()
        
        loadTask = Task {
            state = .loading
            
            do {
                let product = try await catalogService.getCatalogItemById(productId)
                state = .success(product)
            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }
    
    func increaseQuantity() {
        guard let product = product, quantity < product.stockQuantity else { return }
        quantity += 1
    }
    
    func decreaseQuantity() {
        guard quantity > 1 else { return }
        quantity -= 1
    }
    
    func addToCart() {
        guard let product = product,
              let userId = tokenManager.getUserId() else {
            actionState = .error("Please login to add items to cart")
            return
        }
        
        guard product.isInStock, quantity <= product.stockQuantity else {
            actionState = .error("Insufficient stock available")
            return
        }
        
        actionTask?.cancel()
        
        actionTask = Task {
            actionState = .addingToCart
            
            do {
                let model = AddItemToCartModel(catalogItemId: product.id)
                
                for _ in 0..<quantity {
                    _ = try await cartService.addItemToCart(userId: userId, model)
                }
                
                actionState = .addedToCart
                
                try? await Task.sleep(nanoseconds: 1_500_000_000)
                actionState = .idle
            } catch {
                actionState = .error(error.localizedDescription)
                
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                actionState = .idle
            }
        }
    }
    
    func addToWishlist() {
        guard let product = product,
              let userId = tokenManager.getUserId() else {
            actionState = .error("Please login to add items to wishlist")
            return
        }
        
        actionTask?.cancel()
        
        actionTask = Task {
            actionState = .addingToWishlist
            
            do {
                let model = AddItemToWishlistModel(catalogItemId: product.id)
                _ = try await wishlistService.addItemToWishlist(userId: userId, model)
                actionState = .addedToWishlist
                
                try? await Task.sleep(nanoseconds: 1_500_000_000)
                actionState = .idle
            } catch {
                actionState = .error(error.localizedDescription)
                
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                actionState = .idle
            }
        }
    }
    
    func refresh() {
        loadProduct()
    }
}
