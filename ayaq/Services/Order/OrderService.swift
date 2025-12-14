import Foundation

final class OrderService: OrderServiceProtocol {
    private let apiClient: APIClient
    
    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }
    
    func getOrders() async throws -> [OrderDTO] {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.getOrders, expecting: [OrderDTO].self) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func getOrderById(orderId: Int) async throws -> OrderDTO {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.getOrderById(orderId), expecting: OrderDTO.self) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func getOrderByUserId(userId: String) async throws -> [OrderDTO] {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.getOrderByUserId(userId), expecting: [OrderDTO].self) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func createOrder(userId: String, _ model: CreateOrderModel) async throws -> OrderDTO {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.createOrder(userId: userId, model), expecting: OrderDTO.self) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func confirmOrder(orderId: Int) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.confirmOrder(orderId)) { result in
                continuation.resume(with: result)
            }
        }
    }
}
