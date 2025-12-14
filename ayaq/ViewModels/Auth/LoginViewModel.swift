import Foundation
import Combine

enum ValidationError: LocalizedError {
    case emptyField(String)
    case invalidFormat(String)
    case tooShort(String, Int)
    
    var errorDescription: String? {
        switch self {
        case .emptyField(let field):
            return "\(field) cannot be empty"
        case .invalidFormat(let message):
            return message
        case .tooShort(let field, let minLength):
            return "\(field) must be at least \(minLength) characters"
        }
    }
}

@MainActor
final class LoginViewModel: ObservableObject {
    enum State {
        case idle
        case loading
        case success(AuthToken)
        case error(String)
    }
    
    @Published private(set) var state: State = .idle
    
    private let authService: AuthServiceProtocol
    private var loginTask: Task<Void, Never>?
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    func login(email: String, password: String) {
        loginTask?.cancel()
        
        switch validateInputs(email: email, password: password) {
        case .success:
            break
        case .failure(let error):
            state = .error(error.localizedDescription)
            return
        }
        
        loginTask = Task {
            state = .loading
            
            do {
                let authToken = try await authService.login(email: email, password: password)
                guard !Task.isCancelled else { return }
                state = .success(authToken)
            } catch {
                guard !Task.isCancelled else { return }
                state = .error(error.localizedDescription)
            }
        }
    }
    
    func cancelLogin() {
        loginTask?.cancel()
        if case .loading = state {
            state = .idle
        }
    }
    
    private func validateInputs(email: String, password: String) -> Result<Void, ValidationError> {
        guard !email.isEmpty else {
            return .failure(.emptyField("Email"))
        }
        
        guard EmailValidator.isValid(email) else {
            return .failure(.invalidFormat("Please enter a valid email"))
        }
        
        guard !password.isEmpty else {
            return .failure(.emptyField("Password"))
        }
        
        guard password.count >= 6 else {
            return .failure(.tooShort("Password", 6))
        }
        
        return .success(())
    }
}
