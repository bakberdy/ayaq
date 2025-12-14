import Foundation
import Combine

@MainActor
final class EditProfileViewModel: ObservableObject {
    enum State {
        case idle
        case loading
        case success
        case error(String)
    }
    
    enum ValidationError: LocalizedError {
        case firstNameEmpty
        case lastNameEmpty
        case firstNameTooShort
        case lastNameTooShort
        case invalidProfilePictureUrl
        
        var errorDescription: String? {
            switch self {
            case .firstNameEmpty:
                return "First name is required"
            case .lastNameEmpty:
                return "Last name is required"
            case .firstNameTooShort:
                return "First name must be at least 2 characters"
            case .lastNameTooShort:
                return "Last name must be at least 2 characters"
            case .invalidProfilePictureUrl:
                return "Profile picture URL is invalid"
            }
        }
    }
    
    @Published private(set) var state: State = .idle
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var profilePictureUrl: String = ""
    
    private let userService: UserServiceProtocol
    private let userId: String
    private var updateTask: Task<Void, Never>?
    
    init(userService: UserServiceProtocol, userId: String, currentUser: User) {
        self.userService = userService
        self.userId = userId
        self.firstName = currentUser.firstName ?? ""
        self.lastName = currentUser.lastName ?? ""
        self.profilePictureUrl = currentUser.profilePictureUrl ?? ""
    }
    
    func validateInput() -> Result<Void, ValidationError> {
        let trimmedFirstName = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedLastName = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedFirstName.isEmpty else {
            return .failure(.firstNameEmpty)
        }
        
        guard !trimmedLastName.isEmpty else {
            return .failure(.lastNameEmpty)
        }
        
        guard trimmedFirstName.count >= 2 else {
            return .failure(.firstNameTooShort)
        }
        
        guard trimmedLastName.count >= 2 else {
            return .failure(.lastNameTooShort)
        }
        
        if !profilePictureUrl.isEmpty {
            if URL(string: profilePictureUrl) == nil {
                return .failure(.invalidProfilePictureUrl)
            }
        }
        
        return .success(())
    }
    
    func updateProfile() {
        updateTask?.cancel()
        
        updateTask = Task {
            state = .loading
            
            guard case .success = validateInput() else {
                if case .failure(let error) = validateInput() {
                    state = .error(error.localizedDescription)
                }
                return
            }
            
            do {
                let trimmedFirstName = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
                let trimmedLastName = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
                let trimmedUrl = profilePictureUrl.trimmingCharacters(in: .whitespacesAndNewlines)
                
                let model = UpdateProfileInformationModel(
                    firstName: trimmedFirstName,
                    lastName: trimmedLastName,
                    profilePictureUrl: trimmedUrl.isEmpty ? nil : trimmedUrl
                )
                
                try await userService.updateProfileInformation(userId: userId, model)
                guard !Task.isCancelled else { return }
                state = .success
            } catch {
                guard !Task.isCancelled else { return }
                state = .error(error.localizedDescription)
            }
        }
    }
    
    func cancelUpdate() {
        updateTask?.cancel()
    }
}
