import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    enum State: Equatable {
        case idle
        case loading
        case loaded(HomeData)
        case error(String)
    }
    
    struct CategorySection: Equatable {
        let title: String
        let products: [Product]
        let type: ProductType
    }
    
    struct HomeData: Equatable {
        let newArrivals: [Product]
        let categorySections: [CategorySection]
    }
    
    @Published private(set) var state: State = .idle
    
    private let catalogService: CatalogServiceProtocol
    private let brandService: BrandServiceProtocol
    private let typeService: TypeServiceProtocol
    private var loadTask: Task<Void, Never>?
    
    init(
        catalogService: CatalogServiceProtocol,
        brandService: BrandServiceProtocol,
        typeService: TypeServiceProtocol
    ) {
        self.catalogService = catalogService
        self.brandService = brandService
        self.typeService = typeService
    }
    
    func loadHomeData() {
        loadTask?.cancel()
        
        loadTask = Task {
            state = .loading
            
            do {
                async let catalogTask = catalogService.getCatalogItems()
                async let typesTask = typeService.getCatalogTypes()
                
                let (allProducts, types) = try await (catalogTask, typesTask)
                
                guard !Task.isCancelled else { return }
                
                let newArrivals = Array(allProducts.prefix(10))
                
                var categorySections: [CategorySection] = []
                for type in types.prefix(5) {
                    let productsForType = allProducts.filter { $0.type.id == type.id }
                    if !productsForType.isEmpty {
                        categorySections.append(
                            CategorySection(
                                title: type.displayName,
                                products: Array(productsForType.prefix(10)),
                                type: type
                            )
                        )
                    }
                }
                
                let homeData = HomeData(
                    newArrivals: newArrivals,
                    categorySections: categorySections
                )
                
                state = .loaded(homeData)
            } catch {
                guard !Task.isCancelled else { return }
                state = .error(error.localizedDescription)
            }
        }
    }
    
    func refresh() {
        loadHomeData()
    }
}
