import Foundation

final class BrandService: BrandServiceProtocol {
    private let apiClient: APIClient
    
    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }
    
    func getCatalogBrands() async throws -> [CatalogBrandDTO] {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.getCatalogBrands, expecting: [CatalogBrandDTO].self) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func getCatalogBrandById(_ id: Int) async throws -> CatalogBrandDTO {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.getCatalogBrandById(id), expecting: CatalogBrandDTO.self) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func getCatalogBrandByName(_ brandName: String) async throws -> CatalogBrandDTO {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.getCatalogBrandByName(brandName), expecting: CatalogBrandDTO.self) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func createCatalogBrand(_ model: CreateCatalogBrandModel) async throws -> CatalogBrandDTO {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.createCatalogBrand(model), expecting: CatalogBrandDTO.self) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func updateCatalogBrand(id: Int, _ model: UpdateBrandModel) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.updateCatalogBrand(id: id, model), expecting: EmptyResponse.self) { result in
                continuation.resume(with: result.map { _ in () })
            }
        }
    }
    
    func deleteCatalogBrand(_ id: Int) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.deleteCatalogBrand(id), expecting: EmptyResponse.self) { result in
                continuation.resume(with: result.map { _ in () })
            }
        }
    }
}
