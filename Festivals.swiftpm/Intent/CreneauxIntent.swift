import Foundation

enum CreneauxIntentState {
    case upToDate
    case listUpdated
    case deleteRequest(id: String)
    case createRequest(element: Creneau)
}

struct CreneauxIntent {

    private var listState = PassthroughSubject<CreneauxIntentState<Creneau>,Never>()

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