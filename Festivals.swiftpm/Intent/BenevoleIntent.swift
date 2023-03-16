import Foundation
import Combine
import SwiftUI

enum BenevoleIntentState {
    case ready
    case testValidation(Benevole)
    case updateModel
}

enum BenevolesIntentState {
    case upToDate
    case listUpdated
    case deleteRequest(id: String)
    case createRequest(element: Benevole)
}

struct BenevoleIntent {

    private var state = PassthroughSubject<BenevoleIntentState,Never>()
    private var listState = PassthroughSubject<BenevolesIntentState,Never>()

    func addObserver(viewModel: BenevoleViewModel){
        self.state.subscribe(viewModel)
    }

    func addListObserver(viewModel: BenevolesViewModel){
        self.listState.subscribe(viewModel)
    }

    func intentTestValidation(benevole: Benevole){
        self.state.send(.testValidation(benevole))
    }

    func intentValidation(benevole: Benevole) async -> Result<Bool,APIError> {
        let data = await API.benevoleDAO().update(benevole: BenevoleDTO(benevole: benevole))
        switch data {
            case .success(_):
                self.state.send(.updateModel)
                return .success(true)
            case .failure(let err):
                return .failure(err)
        }
    }

    func intentCreateRequest(element: Benevole) {
        self.listState.send(.createRequest(element: element))
    }

    func intentDeleteRequest(id: String) async -> Result<Bool,APIError> {
        let data = await API.benevoleDAO().delete(benevoleId: id)
        switch data {
            case .success(_):
                self.listState.send(.deleteRequest(id: id))
                return data
            case .failure(_):
                return data
        }
    }
}