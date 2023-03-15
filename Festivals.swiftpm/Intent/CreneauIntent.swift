import Foundation
import Combine
import SwiftUI

enum CreneauIntentState {
    case ready
    case testValidation(Creneau)
    case updateModel
}

struct CreneauIntent {

    private var state = PassthroughSubject<CreneauIntentState,Never>()

    func addObserver(viewModel: CreneauViewModel){
        self.state.subscribe(viewModel)
    }

    func intentTestValidation(creneau: Creneau){
        self.state.send(input: .testValidation(creneau))
    }

    func intentValidation(creneau: Creneau) async -> Result<Bool,APIError> {
        let data = await API.creneauDAO().update(creneau: CreneauDTO(creneau: creneau))
        switch data {
            case .success(_):
                self.state.send(input: .updateModel)
                return .success(true)
            case .failure(let err):
                return .failure(err)
        }
    }
}