import Foundation

final class ReviewService: ReviewServiceProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func getCatalogItemReview(catalogItemId: Int) async throws -> [Review] {
        let dtos: [CatalogItemReviewDTO] = try await apiClient.request(.getCatalogItemReview(catalogItemId))
        return dtos.map { Review(from: $0) }
    }
    
    func getReviewsByUserId(userId: String) async throws -> [Review] {
        let dtos: [CatalogItemReviewDTO] = try await apiClient.request(.getReviewsByUserId(userId))
        return dtos.map { Review(from: $0) }
    }
    
    func getReviewById(id: Int) async throws -> Review {
        let dto: CatalogItemReviewDTO = try await apiClient.request(.getReviewById(id))
        return Review(from: dto)
    }
    
    func createReview(_ model: CreateReviewModel) async throws -> Review {
        let dto: CatalogItemReviewDTO = try await apiClient.request(.createReview(model))
        return Review(from: dto)
    }
    
    func updateReview(id: Int, _ model: UpdateReviewModel) async throws {
        try await apiClient.request(.updateReview(id: id, model))
    }
    
    func deleteReview(id: Int, _ model: DeleteReviewModel) async throws {
        try await apiClient.request(.deleteReview(id: id, model))
    }
}
