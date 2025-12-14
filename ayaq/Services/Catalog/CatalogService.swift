import Foundation

final class CatalogService: CatalogServiceProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func getCatalogItems() async throws -> [Product] {
        let dtos: [CatalogItemDTO] = try await apiClient.request(.getCatalogItems)
        return dtos.map { Product(from: $0) }
    }
    
    func getCatalogItemById(_ id: Int) async throws -> Product {
        let dto: CatalogItemDTO = try await apiClient.request(.getCatalogItemById(id))
        return Product(from: dto)
    }
    
    func getCatalogItemsByTypeName(_ typeName: String) async throws -> [Product] {
        let dtos: [CatalogItemDTO] = try await apiClient.request(.getCatalogItemsByTypeName(typeName))
        return dtos.map { Product(from: $0) }
    }
    
    func getCatalogItemsByBrandName(_ brandName: String) async throws -> [Product] {
        let dtos: [CatalogItemDTO] = try await apiClient.request(.getCatalogItemsByBrandName(brandName))
        return dtos.map { Product(from: $0) }
    }
    
    func createCatalogItem(_ model: CreateCatalogItemModel) async throws -> Product {
        let dto: CatalogItemDTO = try await apiClient.request(.createCatalogItem(model))
        return Product(from: dto)
    }
    
    func updateCatalogItemDetails(id: Int, _ model: UpdateCatalogItemModel) async throws {
        try await apiClient.request(.updateCatalogItemDetails(id: id, model))
    }
    
    func updateCatalogItemStockQuantity(id: Int, _ model: UpdateCatalogItemStockQuantityModel) async throws {
        try await apiClient.request(.updateCatalogItemStockQuantity(id: id, model))
    }
    
    func updateCatalogItemPictureUrl(id: Int, _ model: UpdateCatalogItemPictureUrlModel) async throws {
        try await apiClient.request(.updateCatalogItemPictureUrl(id: id, model))
    }
    
    func deleteCatalogItem(_ id: Int) async throws {
        try await apiClient.request(.deleteCatalogItem(id))
    }
}
