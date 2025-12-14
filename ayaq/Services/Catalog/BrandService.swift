import Foundation

final class BrandService: BrandServiceProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func getCatalogBrands() async throws -> [Brand] {
        let dtos: [CatalogBrandDTO] = try await apiClient.request(.getCatalogBrands)
        return dtos.map { Brand(from: $0) }
    }
    
    func getCatalogBrandById(_ id: Int) async throws -> Brand {
        let dto: CatalogBrandDTO = try await apiClient.request(.getCatalogBrandById(id))
        return Brand(from: dto)
    }
    
    func getCatalogBrandByName(_ brandName: String) async throws -> Brand {
        let dto: CatalogBrandDTO = try await apiClient.request(.getCatalogBrandByName(brandName))
        return Brand(from: dto)
    }
    
    func createCatalogBrand(_ model: CreateCatalogBrandModel) async throws -> Brand {
        let dto: CatalogBrandDTO = try await apiClient.request(.createCatalogBrand(model))
        return Brand(from: dto)
    }
    
    func updateCatalogBrand(id: Int, _ model: UpdateBrandModel) async throws {
        try await apiClient.request(.updateCatalogBrand(id: id, model))
    }
    
    func deleteCatalogBrand(_ id: Int) async throws {
        try await apiClient.request(.deleteCatalogBrand(id))
    }
}
