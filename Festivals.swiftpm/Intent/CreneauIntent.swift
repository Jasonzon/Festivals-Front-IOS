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
    case deleteRequest(id: Int)
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
        let data = await API.creneauDAO().update(creneau: creneau)
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

    func intentDeleteRequest(id: Int) async -> Result<Bool,APIError> {
        let data = await API.creneauDAO().delete(id: id)
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