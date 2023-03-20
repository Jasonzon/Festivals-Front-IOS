import Foundation
import Combine
import SwiftUI

enum JourIntentState {
    case ready
    case testValidation(Jour)
    case updateModel
}

enum JoursIntentState {
    case upToDate
    case listUpdated
    case deleteRequest(id: Int)
    case createRequest(element: Jour)
}

struct JourIntent {

    private var state = PassthroughSubject<JourIntentState,Never>()
    private var listState = PassthroughSubject<JoursIntentState,Never>()

    func addObserver(viewModel: JourViewModel){
        self.state.subscribe(viewModel)
    }

    func intentTestValidation(jour: Jour){
        self.state.send(.testValidation(jour))
    }

    func intentValidation(jour: Jour) async -> Result<Bool,APIError> {
        let data = await API.jourDAO().update(jour: jour)
        switch data {
            case .success(_):
                self.state.send(.updateModel)
                return .success(true)
            case .failure(let err):
                return .failure(err)
        }
    }

    func addListObserver(viewModel: JoursViewModel){
        self.listState.subscribe(viewModel)
    }

    func intentDeleteRequest(id: Int) async -> Result<Bool,APIError> {
        let data = await API.jourDAO().delete(id: id)
        switch data {
            case .success(_):
                self.listState.send(.deleteRequest(id: id))
                return data
            case .failure(_):
                return data
        }
    }

    func intentCreateRequest(element: Jour) {
        self.listState.send(.createRequest(element: element))
    }
}