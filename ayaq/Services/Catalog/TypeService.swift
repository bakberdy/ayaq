import Foundation

final class TypeService: TypeServiceProtocol {
    private let apiClient: APIClient
    
    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }
    
    func getCatalogTypes() async throws -> [CatalogTypeDTO] {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.getCatalogTypes, expecting: [CatalogTypeDTO].self) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func getCatalogTypeById(_ id: Int) async throws -> CatalogTypeDTO {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.getCatalogTypeById(id), expecting: CatalogTypeDTO.self) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func getCatalogTypeByName(_ typeName: String) async throws -> CatalogTypeDTO {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.getCatalogTypeByName(typeName), expecting: CatalogTypeDTO.self) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func createCatalogType(_ model: CreateCatalogTypeModel) async throws -> CatalogTypeDTO {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.createCatalogType(model), expecting: CatalogTypeDTO.self) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func updateCatalogType(id: Int, _ model: UpdateTypeModel) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.updateCatalogType(id: id, model), expecting: EmptyResponse.self) { result in
                continuation.resume(with: result.map { _ in () })
            }
        }
    }
    
    func deleteCatalogType(_ id: Int) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.deleteCatalogType(id), expecting: EmptyResponse.self) { result in
                continuation.resume(with: result.map { _ in () })
            }
        }
    }
}
