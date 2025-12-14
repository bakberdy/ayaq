import Foundation
import Combine

@MainActor
final class WishlistViewModel: ObservableObject {
    enum State {
        case idle
        case loading
        case loaded(Wishlist)
        case error(String)
    }
    
    @Published private(set) var state: State = .idle
    
    private let wishlistService: WishlistServiceProtocol
    private let userId: String
    private var loadTask: Task<Void, Never>?
    private var removeTask: Task<Void, Never>?
    private var clearTask: Task<Void, Never>?
    
    var wishlistItems: [WishlistItem] {
        if case .loaded(let wishlist) = state {
            return wishlist.items ?? []
        }
        return []
    }
    
    init(wishlistService: WishlistServiceProtocol, userId: String) {
        self.wishlistService = wishlistService
        self.userId = userId
    }
    
    func loadWishlist() {
        loadTask?.cancel()
        
        loadTask = Task {
            state = .loading
            
            do {
                let wishlist = try await wishlistService.getWishlist(userId: userId)
                guard !Task.isCancelled else { return }
                state = .loaded(wishlist)
            } catch {
                guard !Task.isCancelled else { return }
                state = .error(error.localizedDescription)
            }
        }
    }
    
    func removeItem(catalogItemId: Int) {
        removeTask?.cancel()
        
        guard case .loaded(let currentWishlist) = state else { return }
        
        removeTask = Task {
            do {
                let model = RemoveItemFromWishlistModel(catalogItemId: catalogItemId)
                try await wishlistService.removeItemFromWishlist(userId: userId, model)
                guard !Task.isCancelled else { return }
                
                let updatedItems = currentWishlist.items?.filter { $0.catalogItemId != catalogItemId }
                let updatedWishlist = Wishlist(
                    id: currentWishlist.id,
                    userId: currentWishlist.userId,
                    items: updatedItems
                )
                state = .loaded(updatedWishlist)
            } catch {
                guard !Task.isCancelled else { return }
                state = .error(error.localizedDescription)
                
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                state = .loaded(currentWishlist)
            }
        }
    }
    
    func clearWishlist() {
        clearTask?.cancel()
        
        clearTask = Task {
            do {
                try await wishlistService.removeWishlistByUserId(userId: userId)
                guard !Task.isCancelled else { return }
                
                let emptyWishlist = Wishlist(id: 0, userId: userId, items: [])
                state = .loaded(emptyWishlist)
            } catch {
                guard !Task.isCancelled else { return }
                state = .error(error.localizedDescription)
            }
        }
    }
    
    func refresh() {
        loadWishlist()
    }
    
    func cancelAllOperations() {
        loadTask?.cancel()
        removeTask?.cancel()
        clearTask?.cancel()
    }
}
