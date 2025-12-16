
import Foundation

enum UserRole: String, Codable, CaseIterable {
    case user = "user"
    case admin = "admin"
    
    var displayName: String {
        switch self {
        case .user:
            return "User"
        case .admin:
            return "Admin"
        }
    }
}

enum OrderStatus: String, Codable, CaseIterable {
    case pending = "pending"
    case confirmed = "confirmed"
    case delivered = "delivered"
    
    var displayName: String {
        switch self {
        case .pending:
            return "Pending"
        case .confirmed:
            return "Confirmed"
        case .delivered:
            return "Delivered"
        }
    }
}

enum SortOption: String, Codable, CaseIterable {
    case priceAscending = "price_asc"
    case priceDescending = "price_desc"
    case rating = "rating"
    case newest = "newest"
    
    var displayName: String {
        switch self {
        case .priceAscending:
            return "Price: Low to High"
        case .priceDescending:
            return "Price: High to Low"
        case .rating:
            return "Highest Rated"
        case .newest:
            return "Newest First"
        }
    }
}

struct FilterOption: Codable, Equatable {
    var brandIds: [Int]?
    var typeIds: [Int]?
    var minPrice: Decimal?
    var maxPrice: Decimal?
    var minRating: Double?
    
    init(
        brandIds: [Int]? = nil,
        typeIds: [Int]? = nil,
        minPrice: Decimal? = nil,
        maxPrice: Decimal? = nil,
        minRating: Double? = nil
    ) {
        self.brandIds = brandIds
        self.typeIds = typeIds
        self.minPrice = minPrice
        self.maxPrice = maxPrice
        self.minRating = minRating
    }
    
    var isEmpty: Bool {
        return brandIds?.isEmpty ?? true &&
               typeIds?.isEmpty ?? true &&
               minPrice == nil &&
               maxPrice == nil &&
               minRating == nil
    }
    
    mutating func reset() {
        brandIds = nil
        typeIds = nil
        minPrice = nil
        maxPrice = nil
        minRating = nil
    }
}

