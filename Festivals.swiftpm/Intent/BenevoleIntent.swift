import Foundation
import Combine
import SwiftUI

enum BenevoleIntentState {
    case ready
    case testValidation(Benevole)
    case updateModel
}

struct BenevoleIntent {

    private var state = PassthroughSubject<BenevoleIntentState,Never>()

    func addObserver(viewModel: BenevoleViewModel){
        self.state.subscribe(viewModel)
    }

    func intentTestValidation(benevole: Benevole){
        self.state.send(input: .testValidation(benevole))
    }

    func intentValidation(benevole: Benevole) async -> Result<Bool,APIError> {
        let data = await API.benevoleDAO().update(benevole: BenevoleDTO(benevole: benevole))
        switch data {
            case .success(_):
                self.state.send(input: .updateModel)
                return .success(true)
            case .failure(let err):
                return .failure(err)
        }
    }
}