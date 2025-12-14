import Foundation

/// Example usage of the Network Layer with async/await
/// This file demonstrates how to use the network layer in your app
/// Note: These are examples only - actual implementation uses Services and ViewModels

class NetworkLayerExamples {
    
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    // MARK: - Authentication Examples
    
    func loginExample() async {
        let loginModel = LoginModel(
            email: "user@example.com",
            password: "password123"
        )
        
        do {
            let user: ApplicationUserDTO = try await apiClient.request(.login(loginModel))
            print("✅ Login successful!")
            print("User: \(user.email ?? "")")
        } catch {
            print("❌ Login failed: \(error.localizedDescription)")
        }
    }
    
    func registerExample() async {
        let registerModel = RegisterModel(
            email: "newuser@example.com",
            password: "password123",
            firstName: "John",
            lastName: "Doe",
            profilePictureUrl: nil
        )
        
        do {
            let user: ApplicationUserDTO = try await apiClient.request(.register(registerModel))
            print("✅ Registration successful!")
        } catch {
            print("❌ Registration failed: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Catalog Examples
    
    func getCatalogItemsExample() async {
        do {
            let items: [CatalogItemDTO] = try await apiClient.request(.getCatalogItems)
            print("✅ Got \(items.count) items")
            items.forEach { item in
                print("- \(item.name ?? "") - $\(item.price)")
            }
        } catch {
            print("❌ Error: \(error.localizedDescription)")
        }
    }
    
    func getCatalogItemByIdExample(itemId: Int) async {
        do {
            let item: CatalogItemDTO = try await apiClient.request(.getCatalogItemById(itemId))
            print("✅ Item: \(item.name ?? "")")
            print("Price: $\(item.price)")
            print("Stock: \(item.stockQuantity)")
        } catch {
            print("❌ Error: \(error.localizedDescription)")
        }
    }
    
    func getItemsByTypeExample(typeName: String) async {
        do {
            let items: [CatalogItemDTO] = try await apiClient.request(.getCatalogItemsByTypeName(typeName))
            print("✅ Found \(items.count) items of type: \(typeName)")
        } catch {
            print("❌ Error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Cart Examples
    
    func getCartExample(userId: String) async {
        do {
            let cart: CartDTO = try await apiClient.request(.getCart(userId))
            print("✅ Cart loaded")
            print("Total items: \(cart.items?.count ?? 0)")
            print("Total price: $\(cart.totalPrice)")
        } catch {
            print("❌ Error: \(error.localizedDescription)")
        }
    }
    
    func addToCartExample(userId: String, catalogItemId: Int) async {
        let addModel = AddItemToCartModel(catalogItemId: catalogItemId)
        
        do {
            let cart: CartDTO = try await apiClient.request(.addItemToCart(userId: userId, addModel))
            print("✅ Item added to cart")
            print("Total: $\(cart.totalPrice)")
        } catch {
            print("❌ Error: \(error.localizedDescription)")
        }
    }
    
    func updateCartQuantityExample(userId: String, catalogItemId: Int, quantity: Int) async {
        let updateModel = UpdateCartItemQuantityModel(
            catalogItemId: catalogItemId,
            quantity: quantity
        )
        
        do {
            let cart: CartDTO = try await apiClient.request(.updateItemQuantity(userId: userId, updateModel))
            print("✅ Quantity updated")
        } catch {
            print("❌ Error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Order Examples
    
    func createOrderExample(userId: String) async {
        let orderModel = CreateOrderModel(
            deliveryName: "FedEx Standard",
            deliveryCost: 9.99,
            deliveryTime: 5,
            addressToShip: "123 Main St, City, State 12345",
            phoneNumber: "+1234567890"
        )
        
        do {
            let order: OrderDTO = try await apiClient.request(.createOrder(userId: userId, orderModel))
            print("✅ Order created!")
            print("Order ID: \(order.id)")
            print("Total: $\(order.totalPrice)")
        } catch {
            print("❌ Error: \(error.localizedDescription)")
        }
    }
    
    func getOrdersExample(userId: String) async {
        do {
            let orders: [OrderDTO] = try await apiClient.request(.getOrderByUserId(userId))
            print("✅ Got \(orders.count) orders")
            orders.forEach { order in
                print("Order #\(order.id) - $\(order.totalPrice)")
            }
        } catch {
            print("❌ Error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Review Examples
    
    func createReviewExample(userId: String, catalogItemId: Int) async {
        let reviewModel = CreateReviewModel(
            userId: userId,
            rating: 4.5,
            reviewText: "Great product!",
            catalogItemId: catalogItemId
        )
        
        do {
            let review: CatalogItemReviewDTO = try await apiClient.request(.createReview(reviewModel))
            print("✅ Review created!")
        } catch {
            print("❌ Error: \(error.localizedDescription)")
        }
    }
    
    func getReviewsForProductExample(catalogItemId: Int) async {
        do {
            let reviews: [CatalogItemReviewDTO] = try await apiClient.request(.getCatalogItemReview(catalogItemId))
            print("✅ Got \(reviews.count) reviews")
            let avgRating = reviews.map { $0.rating }.reduce(0, +) / Double(reviews.count)
            print("Average rating: \(avgRating)")
        } catch {
            print("❌ Error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Delete Examples (No Response Body)
    
    func deleteItemExample(itemId: Int) async {
        do {
            try await apiClient.request(.deleteCatalogItem(itemId))
            print("✅ Item deleted successfully")
        } catch {
            print("❌ Error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Error Handling Example
    
    func properErrorHandlingExample() async {
        do {
            let items: [CatalogItemDTO] = try await apiClient.request(.getCatalogItems)
            await MainActor.run {
                print("Update table view with \(items.count) items")
            }
        } catch let error as APIError {
            await MainActor.run {
                switch error {
                case .unauthorized:
                    TokenManager.shared.clearToken()
                    print("Navigate to login screen")
                    
                case .networkError:
                    print("Show alert: Check your internet connection")
                    
                case .serverError:
                    print("Show alert: Server error, try again later")
                    
                case .notFound:
                    print("Show alert: Items not found")
                    
                default:
                    print("Show alert: \(error.localizedDescription)")
                }
            }
        } catch {
            await MainActor.run {
                print("Show alert: \(error.localizedDescription)")
            }
        }
    }
}
