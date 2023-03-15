import Foundation
import Combine
import SwiftUI

enum JeuIntentState {
    case ready
    case testValidation(Jeu)
    case updateModel
}

struct JeuIntent {

    private var state = PassthroughSubject<JeuIntentState,Never>()

    func addObserver(viewModel: JeuViewModel){
        self.state.subscribe(viewModel)
    }

    func intentTestValidation(jeu: Jeu){
        self.state.send(input: .testValidation(jeu))
    }

    func intentValidation(jeu: Jeu) async -> Result<Bool,APIError> {
        let data = await API.jeuDAO().update(jeu: JeuDTO(jeu: jeu))
        switch data {
            case .success(_):
                self.state.send(input: .updateModel)
                return .success(true)
            case .failure(let err):
                return .failure(err)
        }
    }
}