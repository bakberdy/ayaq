import Foundation

final class CatalogService: CatalogServiceProtocol {
    private let apiClient: APIClient
    
    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }
    
    func getCatalogItems() async throws -> [CatalogItemDTO] {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.getCatalogItems, expecting: [CatalogItemDTO].self) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func getCatalogItemById(_ id: Int) async throws -> CatalogItemDTO {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.getCatalogItemById(id), expecting: CatalogItemDTO.self) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func getCatalogItemsByTypeName(_ typeName: String) async throws -> [CatalogItemDTO] {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.getCatalogItemsByTypeName(typeName), expecting: [CatalogItemDTO].self) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func getCatalogItemsByBrandName(_ brandName: String) async throws -> [CatalogItemDTO] {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.getCatalogItemsByBrandName(brandName), expecting: [CatalogItemDTO].self) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func createCatalogItem(_ model: CreateCatalogItemModel) async throws -> CatalogItemDTO {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.createCatalogItem(model), expecting: CatalogItemDTO.self) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func updateCatalogItemDetails(id: Int, _ model: UpdateCatalogItemModel) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.updateCatalogItemDetails(id: id, model)) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func updateCatalogItemStockQuantity(id: Int, _ model: UpdateCatalogItemStockQuantityModel) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.updateCatalogItemStockQuantity(id: id, model)) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func updateCatalogItemPictureUrl(id: Int, _ model: UpdateCatalogItemPictureUrlModel) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.updateCatalogItemPictureUrl(id: id, model)) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func deleteCatalogItem(_ id: Int) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.deleteCatalogItem(id)) { result in
                continuation.resume(with: result)
            }
        }
    }
}
