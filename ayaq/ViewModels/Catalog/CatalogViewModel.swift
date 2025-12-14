import Foundation
import Combine

@MainActor
final class CatalogViewModel: ObservableObject {
    enum State {
        case idle
        case loading
        case loaded([Product])
        case error(String)
    }
    
    @Published private(set) var state: State = .idle
    @Published private(set) var brands: [Brand] = []
    @Published private(set) var types: [ProductType] = []
    
    private let catalogService: CatalogServiceProtocol
    private let brandService: BrandServiceProtocol
    private let typeService: TypeServiceProtocol
    private var loadTask: Task<Void, Never>?
    private var filterTask: Task<Void, Never>?
    
    init(catalogService: CatalogServiceProtocol, brandService: BrandServiceProtocol, typeService: TypeServiceProtocol) {
        self.catalogService = catalogService
        self.brandService = brandService
        self.typeService = typeService
    }
    
    func loadCatalog() {
        loadTask?.cancel()
        
        loadTask = Task {
            state = .loading
            
            do {
                async let products = catalogService.getCatalogItems()
                async let brands = brandService.getCatalogBrands()
                async let types = typeService.getCatalogTypes()
                
                let (loadedProducts, loadedBrands, loadedTypes) = try await (products, brands, types)
                
                guard !Task.isCancelled else { return }
                
                self.brands = loadedBrands
                self.types = loadedTypes
                state = .loaded(loadedProducts)
            } catch {
                guard !Task.isCancelled else { return }
                state = .error(error.localizedDescription)
            }
        }
    }
    
    func searchProducts(query: String) {
        filterTask?.cancel()
        
        guard !query.isEmpty else {
            loadCatalog()
            return
        }
        
        filterTask = Task {
            state = .loading
            
            do {
                let allProducts = try await catalogService.getCatalogItems()
                let filteredProducts = allProducts.filter { product in
                    product.name?.localizedCaseInsensitiveContains(query) ?? false
                }
                guard !Task.isCancelled else { return }
                state = .loaded(filteredProducts)
            } catch {
                guard !Task.isCancelled else { return }
                state = .error(error.localizedDescription)
            }
        }
    }
    
    func filterByBrand(brandName: String) {
        filterTask?.cancel()
        
        filterTask = Task {
            state = .loading
            
            do {
                let products = try await catalogService.getCatalogItemsByBrandName(brandName)
                guard !Task.isCancelled else { return }
                state = .loaded(products)
            } catch {
                guard !Task.isCancelled else { return }
                state = .error(error.localizedDescription)
            }
        }
    }
    
    func filterByType(typeName: String) {
        filterTask?.cancel()
        
        filterTask = Task {
            state = .loading
            
            do {
                let products = try await catalogService.getCatalogItemsByTypeName(typeName)
                guard !Task.isCancelled else { return }
                state = .loaded(products)
            } catch {
                guard !Task.isCancelled else { return }
                state = .error(error.localizedDescription)
            }
        }
    }
    
    func cancelAllOperations() {
        loadTask?.cancel()
        filterTask?.cancel()
    }
}
