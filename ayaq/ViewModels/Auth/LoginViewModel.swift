import Foundation

final class LoginViewModel {
    private let authService: AuthServiceProtocol
    
    var email: String = ""
    var password: String = ""
    
    var onLoginSuccess: ((String) -> Void)?
    var onLoginError: ((String) -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    
    private(set) var isLoading: Bool = false {
        didSet {
            onLoadingStateChanged?(isLoading)
        }
    }
    
    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }
    
    func login() {
        guard validateInputs() else { return }
        
        isLoading = true
        
        Task {
            do {
                let token = try await authService.login(email: email, password: password)
                await MainActor.run {
                    isLoading = false
                    onLoginSuccess?(token)
                }
            } catch let error as APIError {
                await MainActor.run {
                    isLoading = false
                    onLoginError?(error.localizedDescription)
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    onLoginError?(error.localizedDescription)
                }
            }
        }
    }
    
    private func validateInputs() -> Bool {
        guard !email.isEmpty else {
            onLoginError?("Email cannot be empty")
            return false
        }
        
        guard EmailValidator.isValid(email) else {
            onLoginError?("Please enter a valid email")
            return false
        }
        
        guard !password.isEmpty else {
            onLoginError?("Password cannot be empty")
            return false
        }
        
        guard password.count >= 6 else {
            onLoginError?("Password must be at least 6 characters")
            return false
        }
        
        return true
    }
}
