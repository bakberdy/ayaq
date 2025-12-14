import Foundation

final class TypeService: TypeServiceProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func getCatalogTypes() async throws -> [ProductType] {
        let dtos: [CatalogTypeDTO] = try await apiClient.request(.getCatalogTypes)
        return dtos.map { ProductType(from: $0) }
    }
    
    func getCatalogTypeById(_ id: Int) async throws -> ProductType {
        let dto: CatalogTypeDTO = try await apiClient.request(.getCatalogTypeById(id))
        return ProductType(from: dto)
    }
    
    func getCatalogTypeByName(_ typeName: String) async throws -> ProductType {
        let dto: CatalogTypeDTO = try await apiClient.request(.getCatalogTypeByName(typeName))
        return ProductType(from: dto)
    }
    
    func createCatalogType(_ model: CreateCatalogTypeModel) async throws -> ProductType {
        let dto: CatalogTypeDTO = try await apiClient.request(.createCatalogType(model))
        return ProductType(from: dto)
    }
    
    func updateCatalogType(id: Int, _ model: UpdateTypeModel) async throws {
        try await apiClient.request(.updateCatalogType(id: id, model))
    }
    
    func deleteCatalogType(_ id: Int) async throws {
        try await apiClient.request(.deleteCatalogType(id))
    }
}
