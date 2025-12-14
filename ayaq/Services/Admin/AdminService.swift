import Foundation

final class AdminService: AdminServiceProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func getSalesReport() async throws -> [SalesReport] {
        let dtos: [SalesReportDTO] = try await apiClient.request(.getSalesReport)
        return dtos.map { SalesReport(from: $0) }
    }
    
    func getCustomerActivityLogs() async throws -> [CustomerActivityLog] {
        let dtos: [CustomerActivityLogDTO] = try await apiClient.request(.getCustomerActivityLogs)
        return dtos.map { CustomerActivityLog(from: $0) }
    }
    
    func getInventorySummary() async throws -> [InventoryItem] {
        let dtos: [InventorySummaryDTO] = try await apiClient.request(.getInventorySummary)
        return dtos.map { InventoryItem(from: $0) }
    }
}
