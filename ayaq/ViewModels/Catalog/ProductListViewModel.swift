import Foundation
import Combine

@MainActor
final class ProductListViewModel: ObservableObject {
    enum State: Equatable {
        case idle
        case loading
        case success([Product])
        case error(String)
    }
    
    enum SortOption: String, CaseIterable {
        case priceAscending = "Price: Low to High"
        case priceDescending = "Price: High to Low"
        case nameAscending = "Name: A-Z"
        case nameDescending = "Name: Z-A"
        case ratingDescending = "Rating: High to Low"
    }
    
    @Published private(set) var state: State = .idle
    @Published var searchText: String = ""
    @Published var selectedBrands: Set<Int> = []
    @Published var selectedTypes: Set<Int> = []
    @Published var selectedSortOption: SortOption = .nameAscending
    @Published private(set) var brands: [Brand] = []
    @Published private(set) var types: [ProductType] = []
    
    private let catalogService: CatalogServiceProtocol
    private let brandService: BrandServiceProtocol
    private let typeService: TypeServiceProtocol
    
    private var allProducts: [Product] = []
    private var loadTask: Task<Void, Never>?
    private var searchCancellable: AnyCancellable?
    
    init(
        catalogService: CatalogServiceProtocol,
        brandService: BrandServiceProtocol,
        typeService: TypeServiceProtocol
    ) {
        self.catalogService = catalogService
        self.brandService = brandService
        self.typeService = typeService
        
        setupSearchDebounce()
    }
    
    private func setupSearchDebounce() {
        searchCancellable = $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.applyFilters()
            }
    }
    
    func loadInitialData() {
        loadTask?.cancel()
        
        loadTask = Task {
            state = .loading
            
            do {
                async let productsTask = catalogService.getCatalogItems()
                async let brandsTask = brandService.getCatalogBrands()
                async let typesTask = typeService.getCatalogTypes()
                
                let (products, fetchedBrands, fetchedTypes) = try await (
                    productsTask,
                    brandsTask,
                    typesTask
                )
                
                self.allProducts = products
                self.brands = fetchedBrands
                self.types = fetchedTypes
                
                applyFilters()
            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }
    
    func applyFilters() {
        var filtered = allProducts
        
        if !searchText.isEmpty {
            filtered = filtered.filter { product in
                let nameMatch = product.name?.lowercased().contains(searchText.lowercased()) ?? false
                let descMatch = product.description?.lowercased().contains(searchText.lowercased()) ?? false
                let brandMatch = product.brand.name?.lowercased().contains(searchText.lowercased()) ?? false
                let typeMatch = product.type.name?.lowercased().contains(searchText.lowercased()) ?? false
                return nameMatch || descMatch || brandMatch || typeMatch
            }
        }
        
        if !selectedBrands.isEmpty {
            filtered = filtered.filter { selectedBrands.contains($0.brand.id) }
        }
        
        if !selectedTypes.isEmpty {
            filtered = filtered.filter { selectedTypes.contains($0.type.id) }
        }
        
        filtered = sortProducts(filtered, by: selectedSortOption)
        
        state = .success(filtered)
    }
    
    private func sortProducts(_ products: [Product], by option: SortOption) -> [Product] {
        switch option {
        case .priceAscending:
            return products.sorted { $0.price < $1.price }
        case .priceDescending:
            return products.sorted { $0.price > $1.price }
        case .nameAscending:
            return products.sorted { ($0.name ?? "") < ($1.name ?? "") }
        case .nameDescending:
            return products.sorted { ($0.name ?? "") > ($1.name ?? "") }
        case .ratingDescending:
            return products.sorted { $0.averageRating > $1.averageRating }
        }
    }
    
    func toggleBrandFilter(_ brandId: Int) {
        if selectedBrands.contains(brandId) {
            selectedBrands.remove(brandId)
        } else {
            selectedBrands.insert(brandId)
        }
        applyFilters()
    }
    
    func toggleTypeFilter(_ typeId: Int) {
        if selectedTypes.contains(typeId) {
            selectedTypes.remove(typeId)
        } else {
            selectedTypes.insert(typeId)
        }
        applyFilters()
    }
    
    func clearAllFilters() {
        selectedBrands.removeAll()
        selectedTypes.removeAll()
        searchText = ""
        selectedSortOption = .nameAscending
        applyFilters()
    }
    
    func refresh() {
        loadInitialData()
    }
}
