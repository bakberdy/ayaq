import Foundation

/// Example usage of the Network Layer
/// This file demonstrates how to use the network layer in your app

class NetworkLayerExamples {
    
    // MARK: - Authentication Examples
    
    func loginExample() {
        let loginModel = LoginModel(
            email: "user@example.com",
            password: "password123"
        )
        
        APIClient.shared.request(
            .login(loginModel),
            expecting: ApplicationUserDTO.self
        ) { result in
            switch result {
            case .success(let user):
                print("✅ Login successful!")
                print("User: \(user.email ?? "")")
                // Save token here if API returns it
                
            case .failure(let error):
                print("❌ Login failed: \(error.localizedDescription)")
            }
        }
    }
    
    func registerExample() {
        let registerModel = RegisterModel(
            email: "newuser@example.com",
            password: "password123",
            firstName: "John",
            lastName: "Doe",
            profilePictureUrl: nil
        )
        
        APIClient.shared.request(
            .register(registerModel),
            expecting: ApplicationUserDTO.self
        ) { result in
            switch result {
            case .success(let user):
                print("✅ Registration successful!")
                
            case .failure(let error):
                print("❌ Registration failed: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Catalog Examples
    
    func getCatalogItemsExample() {
        APIClient.shared.request(
            .getCatalogItems,
            expecting: [CatalogItemDTO].self
        ) { result in
            switch result {
            case .success(let items):
                print("✅ Got \(items.count) items")
                items.forEach { item in
                    print("- \(item.name ?? "") - $\(item.price)")
                }
                
            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
            }
        }
    }
    
    func getCatalogItemByIdExample(itemId: Int) {
        APIClient.shared.request(
            .getCatalogItemById(itemId),
            expecting: CatalogItemDTO.self
        ) { result in
            switch result {
            case .success(let item):
                print("✅ Item: \(item.name ?? "")")
                print("Price: $\(item.price)")
                print("Stock: \(item.stockQuantity)")
                
            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
            }
        }
    }
    
    func getItemsByTypeExample(typeName: String) {
        APIClient.shared.request(
            .getCatalogItemsByTypeName(typeName),
            expecting: [CatalogItemDTO].self
        ) { result in
            switch result {
            case .success(let items):
                print("✅ Found \(items.count) items of type: \(typeName)")
                
            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Cart Examples
    
    func getCartExample(userId: String) {
        APIClient.shared.request(
            .getCart(userId),
            expecting: CartDTO.self
        ) { result in
            switch result {
            case .success(let cart):
                print("✅ Cart loaded")
                print("Total items: \(cart.items?.count ?? 0)")
                print("Total price: $\(cart.totalPrice)")
                
            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
            }
        }
    }
    
    func addToCartExample(userId: String, catalogItemId: Int) {
        let addModel = AddItemToCartModel(catalogItemId: catalogItemId)
        
        APIClient.shared.request(
            .addItemToCart(userId: userId, addModel),
            expecting: CartDTO.self
        ) { result in
            switch result {
            case .success(let cart):
                print("✅ Item added to cart")
                print("Total: $\(cart.totalPrice)")
                
            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
            }
        }
    }
    
    func updateCartQuantityExample(userId: String, catalogItemId: Int, quantity: Int) {
        let updateModel = UpdateCartItemQuantityModel(
            catalogItemId: catalogItemId,
            quantity: quantity
        )
        
        APIClient.shared.request(
            .updateItemQuantity(userId: userId, updateModel),
            expecting: CartDTO.self
        ) { result in
            switch result {
            case .success(let cart):
                print("✅ Quantity updated")
                
            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Order Examples
    
    func createOrderExample(userId: String) {
        let orderModel = CreateOrderModel(
            deliveryName: "FedEx Standard",
            deliveryCost: 9.99,
            deliveryTime: 5,
            addressToShip: "123 Main St, City, State 12345",
            phoneNumber: "+1234567890"
        )
        
        APIClient.shared.request(
            .createOrder(userId: userId, orderModel),
            expecting: OrderDTO.self
        ) { result in
            switch result {
            case .success(let order):
                print("✅ Order created!")
                print("Order ID: \(order.id)")
                print("Total: $\(order.totalPrice)")
                
            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
            }
        }
    }
    
    func getOrdersExample(userId: String) {
        APIClient.shared.request(
            .getOrderByUserId(userId),
            expecting: [OrderDTO].self
        ) { result in
            switch result {
            case .success(let orders):
                print("✅ Got \(orders.count) orders")
                orders.forEach { order in
                    print("Order #\(order.id) - $\(order.totalPrice)")
                }
                
            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Review Examples
    
    func createReviewExample(userId: String, catalogItemId: Int) {
        let reviewModel = CreateReviewModel(
            userId: userId,
            rating: 4.5,
            reviewText: "Great product!",
            catalogItemId: catalogItemId
        )
        
        APIClient.shared.request(
            .createReview(reviewModel),
            expecting: CatalogItemReviewDTO.self
        ) { result in
            switch result {
            case .success(let review):
                print("✅ Review created!")
                
            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
            }
        }
    }
    
    func getReviewsForProductExample(catalogItemId: Int) {
        APIClient.shared.request(
            .getCatalogItemReview(catalogItemId),
            expecting: [CatalogItemReviewDTO].self
        ) { result in
            switch result {
            case .success(let reviews):
                print("✅ Got \(reviews.count) reviews")
                let avgRating = reviews.map { $0.rating }.reduce(0, +) / Double(reviews.count)
                print("Average rating: \(avgRating)")
                
            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Delete Examples (No Response Body)
    
    func deleteItemExample(itemId: Int) {
        APIClient.shared.request(.deleteCatalogItem(itemId)) { result in
            switch result {
            case .success:
                print("✅ Item deleted successfully")
                
            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Token Management Examples
    
    func tokenExamples() {
        // Save token after login
        TokenManager.shared.saveToken("your-jwt-token-here")
        
        // Check if user is logged in
        if TokenManager.shared.hasToken() {
            print("User is logged in")
        } else {
            print("User not logged in")
        }
        
        // Get token
        if let token = TokenManager.shared.getToken() {
            print("Token: \(token)")
        }
        
        // Logout
        TokenManager.shared.clearToken()
    }
    
    // MARK: - Error Handling Example
    
    func properErrorHandlingExample() {
        APIClient.shared.request(
            .getCatalogItems,
            expecting: [CatalogItemDTO].self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let items):
                    // Update UI on main thread
                    print("Update table view with \(items.count) items")
                    
                case .failure(let error):
                    // Handle specific errors
                    switch error {
                    case .unauthorized:
                        // Session expired - navigate to login
                        TokenManager.shared.clearToken()
                        print("Navigate to login screen")
                        
                    case .networkError:
                        // No internet
                        print("Show alert: Check your internet connection")
                        
                    case .serverError:
                        // Server down
                        print("Show alert: Server error, try again later")
                        
                    case .notFound:
                        // Resource not found
                        print("Show alert: Items not found")
                        
                    default:
                        // Generic error
                        print("Show alert: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
