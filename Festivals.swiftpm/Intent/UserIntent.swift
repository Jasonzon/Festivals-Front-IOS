import Foundation
import Combine
import SwiftUI

enum UserIntentState {
    case ready
    case testValidation(User)
    case updateModel
}

struct UserIntent {

    private var state = PassthroughSubject<UserIntentState,Never>()

    func addObserver(viewModel: UserViewModel) {
        self.state.subscribe(viewModel)
    }

    func intentTestValidation(user: User) {
        self.state.send(input: .testValidation(user))
    }

    func intentValidation(user: User) async -> Result<Bool,APIError> {
        let data = await API.userDAO().update(user: UserDTO(user: user))
        switch data {
            case .success(_):
                self.state.send(input: .updateModel)
                return .success(true)
            case .failure(let err):
                return .failure(err)
        }
    }
}