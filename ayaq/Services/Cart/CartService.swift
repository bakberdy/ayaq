import Foundation

final class CartService: CartServiceProtocol {
    private let apiClient: APIClient
    
    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }
    
    func getCart(userId: String) async throws -> CartDTO {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.getCart(userId), expecting: CartDTO.self) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func addItemToCart(userId: String, _ model: AddItemToCartModel) async throws -> CartDTO {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.addItemToCart(userId: userId, model), expecting: CartDTO.self) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func updateItemQuantity(userId: String, _ model: UpdateCartItemQuantityModel) async throws -> CartDTO {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.updateItemQuantity(userId: userId, model), expecting: CartDTO.self) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func removeItemFromCart(userId: String, _ model: RemoveItemFromCartModel) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.removeItemFromCart(userId: userId, model), expecting: EmptyResponse.self) { result in
                continuation.resume(with: result.map { _ in () })
            }
        }
    }
    
    func removeCart(cartId: Int) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.removeCart(cartId), expecting: EmptyResponse.self) { result in
                continuation.resume(with: result.map { _ in () })
            }
        }
    }
    
    func removeCartByUserId(userId: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.removeCartByUserId(userId), expecting: EmptyResponse.self) { result in
                continuation.resume(with: result.map { _ in () })
            }
        }
    }
}
