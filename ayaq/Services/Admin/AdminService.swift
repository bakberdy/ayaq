import Foundation

final class AdminService: AdminServiceProtocol {
    private let apiClient: APIClient
    
    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }
    
    func getSalesReport() async throws -> [SalesReportDTO] {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.getSalesReport, expecting: [SalesReportDTO].self) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func getCustomerActivityLogs() async throws -> [CustomerActivityLogDTO] {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.getCustomerActivityLogs, expecting: [CustomerActivityLogDTO].self) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func getInventorySummary() async throws -> [InventoryItemDTO] {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.getInventorySummary, expecting: [InventoryItemDTO].self) { result in
                continuation.resume(with: result)
            }
        }
    }
}
