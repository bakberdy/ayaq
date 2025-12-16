import Foundation
import Combine

@MainActor
final class CheckoutViewModel: ObservableObject {
    enum State {
        case idle
        case processing
        case success(orderNumber: String)
        case error(String)
    }
    
    @Published private(set) var state: State = .idle
    
    private var processTask: Task<Void, Never>?
    
    func processPayment() {
        processTask?.cancel()
        
        processTask = Task {
            state = .processing
            
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            
            guard !Task.isCancelled else { return }
            
            let orderNumber = generateOrderNumber()
            state = .success(orderNumber: orderNumber)
        }
    }
    
    private func generateOrderNumber() -> String {
        let timestamp = Int(Date().timeIntervalSince1970)
        let random = Int.random(in: 1000...9999)
        return "ORD-\(timestamp)-\(random)"
    }
    
    func reset() {
        state = .idle
    }
    
    func cancelProcessing() {
        processTask?.cancel()
    }
}

