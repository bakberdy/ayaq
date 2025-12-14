import Foundation

final class RegisterViewModel {
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var profilePictureUrl: String = ""
    
    var onRegisterSuccess: (() -> Void)?
    var onRegisterError: ((String) -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    
    private let authService: AuthServiceProtocol
    
    private(set) var isLoading: Bool = false {
        didSet {
            onLoadingStateChanged?(isLoading)
        }
    }
    
    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }
    
    func register() {
        guard validateInputs() else { return }
        
        isLoading = true
        
        let request = RegisterModel(
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName,
            profilePictureUrl: ""
        )
        
        Task {
            do {
                _ = try await authService.register(model: request)
                await MainActor.run {
                    self.isLoading = false
                    self.onRegisterSuccess?()
                }
            } catch let error as APIError {
                await MainActor.run {
                    self.isLoading = false
                    self.onRegisterError?(error.localizedDescription)
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.onRegisterError?("Registration failed. Please try again.")
                }
            }
        }
    }
    
    private func validateInputs() -> Bool {
        guard !firstName.isEmpty else {
            onRegisterError?("First name cannot be empty")
            return false
        }
        
        guard !lastName.isEmpty else {
            onRegisterError?("Last name cannot be empty")
            return false
        }
        
        guard !email.isEmpty else {
            onRegisterError?("Email cannot be empty")
            return false
        }
        
        guard EmailValidator.isValid(email) else {
            onRegisterError?("Please enter a valid email")
            return false
        }
        
        guard !password.isEmpty else {
            onRegisterError?("Password cannot be empty")
            return false
        }
        
        guard password.count >= 6 else {
            onRegisterError?("Password must be at least 6 characters")
            return false
        }
        
        guard password == confirmPassword else {
            onRegisterError?("Passwords do not match")
            return false
        }
        
        return true
    }
}
