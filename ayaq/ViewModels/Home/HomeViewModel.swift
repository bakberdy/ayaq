import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    enum State {
        case idle
        case loading
        case loaded(HomeData)
        case error(String)
    }
    
    struct HomeData {
        let featuredProducts: [Product]
        let newArrivals: [Product]
        let popularBrands: [Brand]
    }
    
    @Published private(set) var state: State = .idle
    
    private let catalogService: CatalogServiceProtocol
    private let brandService: BrandServiceProtocol
    private var loadTask: Task<Void, Never>?
    
    init(catalogService: CatalogServiceProtocol, brandService: BrandServiceProtocol) {
        self.catalogService = catalogService
        self.brandService = brandService
    }
    
    func loadHomeData() {
        loadTask?.cancel()
        
        loadTask = Task {
            state = .loading
            
            do {
                async let catalog = catalogService.getCatalogItems()
                async let brands = brandService.getCatalogBrands()
                
                let (products, allBrands) = try await (catalog, brands)
                
                guard !Task.isCancelled else { return }
                
                let featuredProducts = Array(products.prefix(10))
                let newArrivals = Array(products.suffix(10))
                let popularBrands = Array(allBrands.prefix(5))
                
                let homeData = HomeData(
                    featuredProducts: featuredProducts,
                    newArrivals: newArrivals,
                    popularBrands: popularBrands
                )
                
                state = .loaded(homeData)
            } catch {
                guard !Task.isCancelled else { return }
                state = .error(error.localizedDescription)
            }
        }
    }
    
    func cancelLoad() {
        loadTask?.cancel()
        if case .loading = state {
            state = .idle
        }
    }
}
