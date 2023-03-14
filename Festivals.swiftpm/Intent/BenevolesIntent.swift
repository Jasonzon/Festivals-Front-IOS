import Foundation

enum BenevolesIntentState {
    case upToDate
    case listUpdated
    case deleteRequest(id: String)
    case createRequest(element: Benevole)
}

struct BenevolesIntent {

    private var listState = PassthroughSubject<BenevolesIntentState<Benevole>,Never>()

    func addListObserver(viewModel: BenevolesViewModel){
        self.listState.subscribe(viewModel)
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

    func intentCreateRequest(element: Benevole) {
        self.listState.send(.createRequest(element: element))
    }
}