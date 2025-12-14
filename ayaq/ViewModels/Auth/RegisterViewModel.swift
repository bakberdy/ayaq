import Foundation
import Combine

@MainActor
final class RegisterViewModel: ObservableObject {
    enum State {
        case idle
        case loading
        case success(AuthToken)
        case error(String)
    }
    
    @Published private(set) var state: State = .idle
    
    private let authService: AuthServiceProtocol
    private var registerTask: Task<Void, Never>?
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    func register(email: String, password: String, confirmPassword: String, firstName: String, lastName: String) {
        registerTask?.cancel()
        
        switch validateInputs(email: email, password: password, confirmPassword: confirmPassword, firstName: firstName, lastName: lastName) {
        case .success:
            break
        case .failure(let error):
            state = .error(error.localizedDescription)
            return
        }
        
        registerTask = Task {
            state = .loading
            
            let request = RegisterModel(
                email: email,
                password: password,
                firstName: firstName,
                lastName: lastName,
                profilePictureUrl: ""
            )
            
            do {
                let authToken = try await authService.register(model: request)
                guard !Task.isCancelled else { return }
                state = .success(authToken)
            } catch {
                guard !Task.isCancelled else { return }
                state = .error(error.localizedDescription)
            }
        }
    }
    
    func cancelRegister() {
        registerTask?.cancel()
        if case .loading = state {
            state = .idle
        }
    }
    
    private func validateInputs(email: String, password: String, confirmPassword: String, firstName: String, lastName: String) -> Result<Void, ValidationError> {
        guard !firstName.isEmpty else {
            return .failure(.emptyField("First name"))
        }
        
        guard !lastName.isEmpty else {
            return .failure(.emptyField("Last name"))
        }
        
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
        
        guard password == confirmPassword else {
            return .failure(.invalidFormat("Passwords do not match"))
        }
        
        return .success(())
    }
}
