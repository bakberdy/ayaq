import Foundation

final class CartService: CartServiceProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func getCart(userId: String) async throws -> Cart {
        let dto: CartDTO = try await apiClient.request(.getCart(userId))
        return Cart(from: dto)
    }
    
    func addItemToCart(userId: String, _ model: AddItemToCartModel) async throws -> Cart {
        let dto: CartDTO = try await apiClient.request(.addItemToCart(userId: userId, model))
        return Cart(from: dto)
    }
    
    func updateItemQuantity(userId: String, _ model: UpdateCartItemQuantityModel) async throws -> Cart {
        let dto: CartDTO = try await apiClient.request(.updateItemQuantity(userId: userId, model))
        return Cart(from: dto)
    }
    
    func removeItemFromCart(userId: String, _ model: RemoveItemFromCartModel) async throws {
        try await apiClient.request(.removeItemFromCart(userId: userId, model))
    }
    
    func removeCart(cartId: Int) async throws {
        try await apiClient.request(.removeCart(cartId))
    }
    
    func removeCartByUserId(userId: String) async throws {
        try await apiClient.request(.removeCartByUserId(userId))
    }
}
