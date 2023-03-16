import Foundation
import Combine
import SwiftUI

enum JeuIntentState {
    case ready
    case testValidation(Jeu)
    case updateModel
}

enum JeuxIntentState {
    case upToDate
    case listUpdated
    case deleteRequest(id: String)
    case createRequest(element: Jeu)
}

struct JeuIntent {

    private var state = PassthroughSubject<JeuIntentState,Never>()
    private var listState = PassthroughSubject<JeuxIntentState,Never>()

    func addObserver(viewModel: JeuViewModel){
        self.state.subscribe(viewModel)
    }

    func intentTestValidation(jeu: Jeu){
        self.state.send(.testValidation(jeu))
    }

    func intentValidation(jeu: Jeu) async -> Result<Bool,APIError> {
        let data = await API.jeuDAO().update(jeu: JeuDTO(jeu: jeu))
        switch data {
            case .success(_):
                self.state.send(.updateModel)
                return .success(true)
            case .failure(let err):
                return .failure(err)
        }
    }

    func addListObserver(viewModel: JeuxViewModel){
        self.listState.subscribe(viewModel)
    }

    func intentDeleteRequest(id: String) async -> Result<Bool,APIError> {
        let data = await API.jeuDAO().delete(jeuId: id)
        switch data {
            case .success(_):
                self.listState.send(.deleteRequest(id: id))
                return data
            case .failure(_):
                return data
        }
    }

    func intentCreateRequest(element: Jeu) {
        self.listState.send(.createRequest(element: element))
    }
}