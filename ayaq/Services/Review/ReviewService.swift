import Foundation

final class ReviewService: ReviewServiceProtocol {
    private let apiClient: APIClient
    
    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }
    
    func getCatalogItemReview(catalogItemId: Int) async throws -> [CatalogItemReviewDTO] {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.getCatalogItemReview(catalogItemId), expecting: [CatalogItemReviewDTO].self) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func getReviewsByUserId(userId: String) async throws -> [CatalogItemReviewDTO] {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.getReviewsByUserId(userId), expecting: [CatalogItemReviewDTO].self) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func getReviewById(id: Int) async throws -> CatalogItemReviewDTO {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.getReviewById(id), expecting: CatalogItemReviewDTO.self) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func createReview(_ model: CreateReviewModel) async throws -> CatalogItemReviewDTO {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.createReview(model), expecting: CatalogItemReviewDTO.self) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func updateReview(id: Int, _ model: UpdateReviewModel) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.updateReview(id: id, model), expecting: EmptyResponse.self) { result in
                continuation.resume(with: result.map { _ in () })
            }
        }
    }
    
    func deleteReview(id: Int, _ model: DeleteReviewModel) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.deleteReview(id: id, model), expecting: EmptyResponse.self) { result in
                continuation.resume(with: result.map { _ in () })
            }
        }
    }
}
