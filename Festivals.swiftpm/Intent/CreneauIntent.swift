import Foundation
import Combine
import SwiftUI

enum CreneauIntentState {
    case ready
    case testValidation(Creneau)
    case updateModel
}

enum CreneauxIntentState {
    case upToDate
    case listUpdated
    case deleteRequest(id: String)
    case createRequest(element: Creneau)
}

struct CreneauIntent {

    private var state = PassthroughSubject<CreneauIntentState,Never>()
    private var listState = PassthroughSubject<CreneauxIntentState,Never>()

    func addObserver(viewModel: CreneauViewModel){
        self.state.subscribe(viewModel)
    }

    func intentTestValidation(creneau: Creneau){
        self.state.send(.testValidation(creneau))
    }

    func intentValidation(creneau: Creneau) async -> Result<Bool,APIError> {
        let data = await API.creneauDAO().update(creneau: CreneauDTO(creneau: creneau))
        switch data {
            case .success(_):
                self.state.send(.updateModel)
                return .success(true)
            case .failure(let err):
                return .failure(err)
        }
    }

    func addListObserver(viewModel: CreneauxViewModel){
        self.listState.subscribe(viewModel)
    }

    func intentDeleteRequest(id: String) async -> Result<Bool,APIError> {
        let data = await API.creneauDAO().delete(creneauId: id)
        switch data {
            case .success(_):
                self.listState.send(.deleteRequest(id: id))
                return data
            case .failure(_):
                return data
        }
    }

    func intentCreateRequest(element: Creneau) {
        self.listState.send(.createRequest(element: element))
    }
}