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
}

struct ProductType: Codable, Equatable, Identifiable {
    let id: Int
    let name: String?
    
    var displayName: String {
        return name ?? "Unknown Type"
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
        formatter.currencyCode = "KZT"
        return formatter.string(from: price as NSDecimalNumber) ?? "₸\(price)"
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
        formatter.currencyCode = "KZT"
        return formatter.string(from: totalPrice as NSDecimalNumber) ?? "₸\(totalPrice)"
    }
    
    var formattedUnitPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "KZT"
        return formatter.string(from: unitPrice as NSDecimalNumber) ?? "₸\(unitPrice)"
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
        formatter.currencyCode = "KZT"
        return formatter.string(from: totalPrice as NSDecimalNumber) ?? "₸\(totalPrice)"
    }
    
    var itemCount: Int {
        return items?.reduce(0) { $0 + $1.quantity } ?? 0
    }
    
    var uniqueItemCount: Int {
        return items?.count ?? 0
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
        formatter.currencyCode = "KZT"
        return formatter.string(from: totalPrice as NSDecimalNumber) ?? "₸\(totalPrice)"
    }
}

struct ShippingMethod: Codable, Equatable {
    let name: String?
    let cost: Decimal
    let deliveryTime: String?
    
    var formattedCost: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "KZT"
        return formatter.string(from: cost as NSDecimalNumber) ?? "₸\(cost)"
    }
}

struct ShippingDetails: Codable, Equatable {
    let addressToShip: String?
    let phoneNumber: String?
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
        formatter.currencyCode = "KZT"
        return formatter.string(from: totalPrice as NSDecimalNumber) ?? "₸\(totalPrice)"
    }
    
    var status: OrderStatus {
        return isConfirmed ? .confirmed : .pending
    }
    
    var itemCount: Int {
        return items?.count ?? 0
    }
}

struct WishlistItem: Codable, Equatable, Identifiable {
    let id: Int
    let catalogItemId: Int
    let productName: String?
    let imageURL: URL?
    let wishlistId: Int
}

struct Wishlist: Codable, Equatable, Identifiable {
    let id: Int
    let userId: String?
    let items: [WishlistItem]?
    
    var itemCount: Int {
        return items?.count ?? 0
    }
}

struct AuthToken: Codable, Equatable {
    let token: String
    
    var isValid: Bool {
        return !token.isEmpty
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
}

struct SalesReport: Codable, Equatable {
    let month: String?
    let salesCount: Int
    
    var displayMonth: String {
        return month ?? "Unknown"
    }
}

struct CustomerActivityLog: Codable, Equatable {
    let userId: String?
    let justOrdered: Bool
    let orderDate: Date?
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
}

