import Foundation
import Combine
import SwiftUI

enum CreneauIntentState {
    case ready
    case testValidation(Creneau)
    case updateModel
}

struct CreneauIntent {

    private var state = PassThroughSubject<CreneauIntentState,Never>()

    func addObserver(viewModel: CreneauViewModel){
        self.state.subscribe(viewModel)
    }

    func intentTestValidation(creneau: Creneau){
        self.state.send(.testValidation(creneau))
    }

    func intentValidation(creneau: Creneau) async -> Result<Bool,APIError> {
        let data = await API.creneauDAO().update(creneau: CreneauDTO(creneau))
        switch data {
            case .success(_):
                self.state.send(.updateModel)
                return .success(true)
            case .failure(let err):
                return .failure(err)
        }
    }
}