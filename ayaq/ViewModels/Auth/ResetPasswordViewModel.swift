import Foundation
import Combine

@MainActor
final class ResetPasswordViewModel: ObservableObject {
    enum State {
        case idle
        case loading
        case success
        case error(String)
    }
    
    @Published private(set) var state: State = .idle
    
    private let authService: AuthServiceProtocol
    private var resetTask: Task<Void, Never>?
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    func resetPassword(email: String, code: String, newPassword: String, confirmPassword: String) {
        resetTask?.cancel()
        
        switch validateInputs(email: email, code: code, newPassword: newPassword, confirmPassword: confirmPassword) {
        case .success:
            break
        case .failure(let error):
            state = .error(error.localizedDescription)
            return
        }
        
        resetTask = Task {
            state = .loading
            
            do {
                guard let codeInt = Int(code) else {
                    state = .error("Invalid verification code")
                    return
                }
                let model = ResetPasswordModel(email: email, code: codeInt, newPassword: newPassword)
                try await authService.resetPassword(model: model)
                guard !Task.isCancelled else { return }
                state = .success
            } catch {
                guard !Task.isCancelled else { return }
                state = .error(error.localizedDescription)
            }
        }
    }
    
    func cancelReset() {
        resetTask?.cancel()
        if case .loading = state {
            state = .idle
        }
    }
    
    private func validateInputs(email: String, code: String, newPassword: String, confirmPassword: String) -> Result<Void, ValidationError> {
        guard !email.isEmpty else {
            return .failure(.emptyField("Email"))
        }
        
        guard EmailValidator.isValid(email) else {
            return .failure(.invalidFormat("Please enter a valid email"))
        }
        
        guard !code.isEmpty else {
            return .failure(.emptyField("Verification code"))
        }
        
        guard let codeInt = Int(code), codeInt > 0 else {
            return .failure(.invalidFormat("Please enter a valid verification code"))
        }
        
        guard !newPassword.isEmpty else {
            return .failure(.emptyField("New password"))
        }
        
        guard newPassword.count >= 6 else {
            return .failure(.tooShort("Password", 6))
        }
        
        guard newPassword == confirmPassword else {
            return .failure(.invalidFormat("Passwords do not match"))
        }
        
        return .success(())
    }
}
