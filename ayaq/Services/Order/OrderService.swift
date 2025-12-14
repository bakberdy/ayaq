import Foundation

final class OrderService: OrderServiceProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func getOrders() async throws -> [Order] {
        let dtos: [OrderDTO] = try await apiClient.request(.getOrders)
        return dtos.map { Order(from: $0) }
    }
    
    func getOrderById(orderId: Int) async throws -> Order {
        let dto: OrderDTO = try await apiClient.request(.getOrderById(orderId))
        return Order(from: dto)
    }
    
    func getOrderByUserId(userId: String) async throws -> [Order] {
        let dtos: [OrderDTO] = try await apiClient.request(.getOrderByUserId(userId))
        return dtos.map { Order(from: $0) }
    }
    
    func createOrder(userId: String, _ model: CreateOrderModel) async throws -> Order {
        let dto: OrderDTO = try await apiClient.request(.createOrder(userId: userId, model))
        return Order(from: dto)
    }
    
    func confirmOrder(orderId: Int) async throws {
        try await apiClient.request(.confirmOrder(orderId))
    }
}
