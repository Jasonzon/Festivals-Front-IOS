import Foundation
import Combine
import SwiftUi

enum JeuIntentState {
    case ready
    case testValidation(Jeu)
    case updateModel
}

struct JeuIntent {

    private var state = PassThroughSubject<JeuIntentState,Never>()

    func addObserver(viewModel: JeuViewModel){
        self.state.subscribe(viewModel)
    }

    func intentTestValidation(jeu: Jeu){
        self.state.send(.testValidation(jeu))
    }

    func intentValidation(jeu: Jeu) async -> Result<Bool,APIError> {
        let data = await API.jeuDAO().update(jeu: JeuDTO(jeu))
        switch data {
            case .success(_):
                self.state.send(.updateModel)
                return .success(true)
            case .failure(let err):
                return .failure(err)
        }
    }
}