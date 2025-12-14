//
//  LocalModels.swift
//  ayaq
//
//  Created by Bakberdi Esentai on 14.12.2025.
//

import Foundation

struct User: Codable, Equatable, Identifiable {
    let id: String
    let firstName: String?
    let lastName: String?
    let userName: String?
    let email: String?
    let profilePictureUrl: String?
    let roles: [UserRole]?
    
    var fullName: String {
        let first = firstName ?? ""
        let last = lastName ?? ""
        return "\(first) \(last)".trimmingCharacters(in: .whitespaces)
    }
    
    var displayName: String {
        return fullName.isEmpty ? (userName ?? email ?? "Unknown User") : fullName
    }
    
    var isAdmin: Bool {
        return roles?.contains(.admin) ?? false
    }
    
    init(from dto: ApplicationUserDTO) {
        self.id = dto.userId ?? ""
        self.firstName = dto.firstName
        self.lastName = dto.lastName
        self.userName = dto.userName
        self.email = dto.email
        self.profilePictureUrl = dto.profilePictureUrl
        self.roles = dto.roles?.compactMap { UserRole(rawValue: $0) }
    }
}

struct ProductType: Codable, Equatable, Identifiable {
    let id: Int
    let name: String?
    
    var displayName: String {
        return name ?? "Unknown Type"
    }
    
    init(from dto: CatalogTypeDTO) {
        self.id = dto.id
        self.name = dto.type
    }
    
    init(id: Int, name: String?) {
        self.id = id
        self.name = name
    }
}

struct Brand: Codable, Equatable, Identifiable {
    let id: Int
    let name: String?
    
    var displayName: String {
        return name ?? "Unknown Brand"
    }
    
    init(from dto: CatalogBrandDTO) {
        self.id = dto.id
        self.name = dto.brand
    }
    
    init(id: Int, name: String?) {
        self.id = id
        self.name = name
    }
}

struct Product: Codable, Equatable, Identifiable {
    let id: Int
    let name: String?
    let description: String?
    let price: Decimal
    let imageURL: URL?
    let stockQuantity: Int
    let type: ProductType
    let brand: Brand
    let reviews: [Review]?
    
    var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: price as NSDecimalNumber) ?? "$\(price)"
    }
    
    var averageRating: Double {
        guard let reviews = reviews, !reviews.isEmpty else {
            return 0.0
        }
        let totalRating = reviews.reduce(0.0) { $0 + $1.rating }
        return totalRating / Double(reviews.count)
    }
    
    var reviewCount: Int {
        return reviews?.count ?? 0
    }
    
    var isInStock: Bool {
        return stockQuantity > 0
    }
    
    init(from dto: CatalogItemDTO, type: ProductType? = nil, brand: Brand? = nil) {
        self.id = dto.id
        self.name = dto.name
        self.description = dto.description
        self.price = Decimal(dto.price)
        self.imageURL = URL(string: dto.pictureUrl ?? "")
        self.stockQuantity = dto.stockQuantity
        
        if let type = type {
            self.type = type
        } else {
            self.type = ProductType(
                id: dto.catalogTypeId,
                name: dto.catalogItemTypeName
            )
        }
        
        if let brand = brand {
            self.brand = brand
        } else {
            self.brand = Brand(
                id: dto.catalogBrandId,
                name: dto.catalogItemBrandName
            )
        }
        
        self.reviews = dto.reviews?.map { Review(from: $0) }
    }
}

struct Review: Codable, Equatable, Identifiable {
    let id: Int
    let userId: String?
    let rating: Double
    let reviewText: String?
    let createdTime: Date?
    let catalogItemId: Int
    
    var formattedDate: String {
        guard let date = createdTime else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var shortDate: String {
        guard let date = createdTime else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    init(from dto: CatalogItemReviewDTO) {
        self.id = dto.id
        self.userId = dto.userId
        self.rating = dto.rating
        self.reviewText = dto.reviewText
        self.catalogItemId = dto.catalogItemId
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        self.createdTime = dateFormatter.date(from: dto.createdTime)
    }
}

struct CartItem: Codable, Equatable, Identifiable {
    let id: Int
    let catalogItemId: Int
    let unitPrice: Decimal
    let quantity: Int
    let productName: String?
    let imageURL: URL?
    let cartId: Int
    
    var totalPrice: Decimal {
        return unitPrice * Decimal(quantity)
    }
    
    var formattedTotalPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: totalPrice as NSDecimalNumber) ?? "$\(totalPrice)"
    }
    
    var formattedUnitPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: unitPrice as NSDecimalNumber) ?? "$\(unitPrice)"
    }
    
    init(from dto: CartItemDTO) {
        self.id = dto.id
        self.catalogItemId = dto.catalogItemId
        self.unitPrice = Decimal(dto.unitPrice)
        self.quantity = dto.quantity
        self.productName = dto.productName
        self.imageURL = URL(string: dto.pictureUrl ?? "")
        self.cartId = dto.cartId
    }
}

struct Cart: Codable, Equatable, Identifiable {
    let id: Int
    let userId: String?
    let items: [CartItem]?
    
    var totalPrice: Decimal {
        guard let items = items else { return 0 }
        return items.reduce(0) { $0 + $1.totalPrice }
    }
    
    var formattedTotalPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: totalPrice as NSDecimalNumber) ?? "$\(totalPrice)"
    }
    
    var itemCount: Int {
        return items?.reduce(0) { $0 + $1.quantity } ?? 0
    }
    
    var uniqueItemCount: Int {
        return items?.count ?? 0
    }
    
    init(from dto: CartDTO) {
        self.id = dto.id
        self.userId = dto.userId
        self.items = dto.items?.map { CartItem(from: $0) }
    }
}

struct OrderItem: Codable, Equatable, Identifiable {
    let id: Int
    let catalogItemId: Int
    let unitPrice: Decimal
    let quantity: Int
    let productName: String?
    let orderId: Int
    
    var totalPrice: Decimal {
        return unitPrice * Decimal(quantity)
    }
    
    var formattedTotalPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: totalPrice as NSDecimalNumber) ?? "$\(totalPrice)"
    }
    
    init(from dto: OrderItemDTO) {
        self.id = dto.id
        self.catalogItemId = dto.catalogItemId
        self.unitPrice = Decimal(dto.unitPrice)
        self.quantity = dto.quantity
        self.productName = dto.productName
        self.orderId = dto.orderId
    }
}

struct ShippingMethod: Codable, Equatable {
    let name: String?
    let cost: Decimal
    let deliveryTime: String?
    
    var formattedCost: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: cost as NSDecimalNumber) ?? "$\(cost)"
    }
    
    init(from dto: ShippingMethodDTO) {
        self.name = dto.name
        self.cost = Decimal(dto.cost)
        self.deliveryTime = dto.deliveryTime
    }
}

struct ShippingDetails: Codable, Equatable {
    let addressToShip: String?
    let phoneNumber: String?
    
    init(from dto: ShippingDetailsDTO) {
        self.addressToShip = dto.addressToShip
        self.phoneNumber = dto.phoneNumber
    }
}

struct Order: Codable, Equatable, Identifiable {
    let id: Int
    let userId: String?
    let orderDate: Date?
    let isConfirmed: Bool
    let shippingMethod: ShippingMethod?
    let shippingDetails: ShippingDetails?
    let items: [OrderItem]?
    
    var totalPrice: Decimal {
        guard let items = items else { return 0 }
        let itemsTotal = items.reduce(Decimal(0)) { $0 + $1.totalPrice }
        let shippingCost = shippingMethod?.cost ?? 0
        return itemsTotal + shippingCost
    }
    
    var formattedTotalPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: totalPrice as NSDecimalNumber) ?? "$\(totalPrice)"
    }
    
    var status: OrderStatus {
        return isConfirmed ? .confirmed : .pending
    }
    
    var itemCount: Int {
        return items?.count ?? 0
    }
    
    init(from dto: OrderDTO) {
        self.id = dto.id
        self.userId = dto.userId
        self.isConfirmed = dto.isConfirmed
        self.shippingMethod = dto.shippingMethod.map { ShippingMethod(from: $0) }
        self.shippingDetails = dto.shippingDetails.map { ShippingDetails(from: $0) }
        self.items = dto.items?.map { OrderItem(from: $0) }
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        self.orderDate = dateFormatter.date(from: dto.orderDate)
    }
}

struct WishlistItem: Codable, Equatable, Identifiable {
    let id: Int
    let catalogItemId: Int
    let productName: String?
    let imageURL: URL?
    let wishlistId: Int
    
    init(from dto: WishlistItemDTO) {
        self.id = dto.id
        self.catalogItemId = dto.catalogItemId
        self.productName = dto.productName
        self.imageURL = URL(string: dto.pictureUrl ?? "")
        self.wishlistId = dto.wishlistId
    }
}

struct Wishlist: Codable, Equatable, Identifiable {
    let id: Int
    let userId: String?
    let items: [WishlistItem]?
    
    var itemCount: Int {
        return items?.count ?? 0
    }
    
    init(from dto: WishlistDTO) {
        self.id = dto.id
        self.userId = dto.userId
        self.items = dto.items?.map { WishlistItem(from: $0) }
    }
}

struct AuthToken: Codable, Equatable {
    let token: String
    
    var isValid: Bool {
        return !token.isEmpty
    }
    
    init(from dto: TokenDTO) {
        self.token = dto.authToken ?? ""
    }
    
    init(token: String) {
        self.token = token
    }
}

struct JwtPayload: Codable, Equatable {
    let userId: String?
    let userName: String?
    let roles: [UserRole]?
    let notBefore: Date
    let expires: Date
    let issuedAt: Date
    
    var isExpired: Bool {
        return Date() > expires
    }
    
    var isActive: Bool {
        return Date() >= notBefore && !isExpired
    }
    
    init(from dto: JwtPayloadDTO) {
        self.userId = dto.nameId
        self.userName = dto.name
        self.roles = dto.roles?.compactMap { UserRole(rawValue: $0) }
        self.notBefore = Date(timeIntervalSince1970: TimeInterval(dto.notBefore))
        self.expires = Date(timeIntervalSince1970: TimeInterval(dto.expires))
        self.issuedAt = Date(timeIntervalSince1970: TimeInterval(dto.issuedAt))
    }
}

struct SalesReport: Codable, Equatable {
    let month: String?
    let salesCount: Int
    
    var displayMonth: String {
        return month ?? "Unknown"
    }
    
    init(from dto: SalesReportDTO) {
        self.month = dto.month
        self.salesCount = dto.salesCount
    }
}

struct CustomerActivityLog: Codable, Equatable {
    let userId: String?
    let justOrdered: Bool
    let orderDate: Date?
    
    init(from dto: CustomerActivityLogDTO) {
        self.userId = dto.userId
        self.justOrdered = dto.justOrdered
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        self.orderDate = dateFormatter.date(from: dto.orderDate)
    }
}

struct InventoryItem: Codable, Equatable {
    let productName: String?
    let stockQuantity: Int
    
    var displayName: String {
        return productName ?? "Unknown Product"
    }
    
    var isOutOfStock: Bool {
        return stockQuantity <= 0
    }
    
    var isLowStock: Bool {
        return stockQuantity > 0 && stockQuantity <= 10
    }
    
    init(from dto: InventorySummaryDTO) {
        self.productName = dto.productName
        self.stockQuantity = dto.stockQuantity
    }
}

