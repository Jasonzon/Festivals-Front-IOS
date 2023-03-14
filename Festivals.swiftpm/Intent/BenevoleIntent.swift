import Foundation
import Combine
import SwiftUi

enum BenevoleIntentState {
    case ready
    case testValidation(Benevole)
    case updateModel
}

struct BenevoleIntent {

    private var state = PassThroughSubject<BenevoleIntentState,Never>()

    func addObserver(viewModel: BenevoleViewModel){
        self.state.subscribe(viewModel)
    }

    func intentTestValidation(benevole: Benevole){
        self.state.send(.testValidation(benevole))
    }

    func intentValidation(benevole: Benevole) async -> Result<Bool,APIError> {
        let data = await API.benevoleDAO().update(benevole: BenevoleDTO(benevole))
        switch data {
            case .success(_):
                self.state.send(.updateModel)
                return .success(true)
            case .failure(let err):
                return .failure(err)
        }
    }
}