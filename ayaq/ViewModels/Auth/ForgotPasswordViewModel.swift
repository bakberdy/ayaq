import Foundation
import Combine

@MainActor
final class ForgotPasswordViewModel: ObservableObject {
    enum State {
        case idle
        case loading
        case success(String)
        case error(String)
    }
    
    @Published private(set) var state: State = .idle
    
    private let authService: AuthServiceProtocol
    private var resetTask: Task<Void, Never>?
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    func requestPasswordReset(email: String) {
        resetTask?.cancel()
        
        switch validateInput(email: email) {
        case .success:
            break
        case .failure(let error):
            state = .error(error.localizedDescription)
            return
        }
        
        resetTask = Task {
            state = .loading
            
            do {
                let model = RequestPasswordResetModel(email: email, linkToResetPassword: "")
                try await authService.requestPasswordReset(model: model)
                guard !Task.isCancelled else { return }
                state = .success(email)
            } catch {
                guard !Task.isCancelled else { return }
                state = .error(error.localizedDescription)
            }
        }
    }
    
    func cancelRequest() {
        resetTask?.cancel()
        if case .loading = state {
            state = .idle
        }
    }
    
    private func validateInput(email: String) -> Result<Void, ValidationError> {
        guard !email.isEmpty else {
            return .failure(.emptyField("Email"))
        }
        
        guard EmailValidator.isValid(email) else {
            return .failure(.invalidFormat("Please enter a valid email"))
        }
        
        return .success(())
    }
}
