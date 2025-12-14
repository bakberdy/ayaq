import Foundation
import Combine

@MainActor
final class CartViewModel: ObservableObject {
    enum State {
        case idle
        case loading
        case loaded(Cart)
        case error(String)
    }
    
    @Published private(set) var state: State = .idle
    
    private let cartService: CartServiceProtocol
    private let userId: String
    private var loadTask: Task<Void, Never>?
    private var addTask: Task<Void, Never>?
    private var removeTask: Task<Void, Never>?
    private var updateTask: Task<Void, Never>?
    private var clearTask: Task<Void, Never>?
    
    init(cartService: CartServiceProtocol, userId: String) {
        self.cartService = cartService
        self.userId = userId
    }
    
    func loadCart() {
        loadTask?.cancel()
        
        loadTask = Task {
            state = .loading
            
            do {
                let cart = try await cartService.getCart(userId: userId)
                guard !Task.isCancelled else { return }
                state = .loaded(cart)
            } catch {
                guard !Task.isCancelled else { return }
                state = .error(error.localizedDescription)
            }
        }
    }
    
    func addToCart(catalogItemId: Int) {
        addTask?.cancel()
        
        addTask = Task {
            do {
                let model = AddItemToCartModel(catalogItemId: catalogItemId)
                let cart = try await cartService.addItemToCart(userId: userId, model)
                guard !Task.isCancelled else { return }
                state = .loaded(cart)
            } catch {
                guard !Task.isCancelled else { return }
                state = .error(error.localizedDescription)
            }
        }
    }
    
    func removeFromCart(catalogItemId: Int) {
        removeTask?.cancel()
        
        removeTask = Task {
            do {
                let model = RemoveItemFromCartModel(catalogItemId: catalogItemId)
                try await cartService.removeItemFromCart(userId: userId, model)
                guard !Task.isCancelled else { return }
                
                let cart = try await cartService.getCart(userId: userId)
                state = .loaded(cart)
            } catch {
                guard !Task.isCancelled else { return }
                state = .error(error.localizedDescription)
            }
        }
    }
    
    func updateQuantity(catalogItemId: Int, quantity: Int) {
        updateTask?.cancel()
        
        updateTask = Task {
            do {
                let model = UpdateCartItemQuantityModel(catalogItemId: catalogItemId, quantity: quantity)
                let cart = try await cartService.updateItemQuantity(userId: userId, model)
                guard !Task.isCancelled else { return }
                state = .loaded(cart)
            } catch {
                guard !Task.isCancelled else { return }
                state = .error(error.localizedDescription)
            }
        }
    }
    
    func increaseQuantity(itemId: Int) {
        updateTask?.cancel()
        
        guard case .loaded(let cart) = state,
              let items = cart.items,
              let item = items.first(where: { $0.id == itemId }) else {
            return
        }
        
        updateQuantity(catalogItemId: item.catalogItemId, quantity: item.quantity + 1)
    }
    
    func decreaseQuantity(itemId: Int) {
        updateTask?.cancel()
        
        guard case .loaded(let cart) = state,
              let items = cart.items,
              let item = items.first(where: { $0.id == itemId }) else {
            return
        }
        
        if item.quantity > 1 {
            updateQuantity(catalogItemId: item.catalogItemId, quantity: item.quantity - 1)
        } else {
            removeItem(itemId: itemId)
        }
    }
    
    func removeItem(itemId: Int) {
        removeTask?.cancel()
        
        guard case .loaded(let cart) = state,
              let items = cart.items,
              let item = items.first(where: { $0.id == itemId }) else {
            return
        }
        
        removeFromCart(catalogItemId: item.catalogItemId)
    }
    
    func clearCart() {
        clearTask?.cancel()
        
        clearTask = Task {
            do {
                try await cartService.removeCartByUserId(userId: userId)
                guard !Task.isCancelled else { return }
                
                let emptyCart = Cart(id: 0, userId: userId, items: [])
                state = .loaded(emptyCart)
            } catch {
                guard !Task.isCancelled else { return }
                state = .error(error.localizedDescription)
            }
        }
    }
    
    func cancelAllOperations() {
        loadTask?.cancel()
        addTask?.cancel()
        removeTask?.cancel()
        updateTask?.cancel()
        clearTask?.cancel()
    }
}
