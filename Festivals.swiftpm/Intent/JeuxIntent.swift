import Foundation
import Combine
import SwiftUI

enum JeuxIntentState {
    case upToDate
    case listUpdated
    case deleteRequest(id: String)
    case createRequest(element: Jeu)
}

struct JeuxIntent {

    private var listState = PassthroughSubject<JeuxIntentState,Never>()

    func addListObserver(viewModel: JeuxViewModel){
        self.listState.subscribe(viewModel)
    }

    func intentDeleteRequest(id: String) async -> Result<Bool,APIError> {
        let data = await API.jeuDAO().delete(jeuId: id)
        switch data {
            case .success(_):
                self.listState.send(input: .deleteRequest(id: id))
                return data
            case .failure(_):
                return data
        }
    }

    func intentCreateRequest(element: Jeu) {
        self.listState.send(input: .createRequest(element: element))
    }
}