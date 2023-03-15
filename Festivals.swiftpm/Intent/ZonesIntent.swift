import Foundation
import Combine
import SwiftUI

enum ZonesIntentState {
    case upToDate
    case listUpdated
    case deleteRequest(id: String)
    case createRequest(element: Zone)
}

struct ZonesIntent {

    private var listState = PassthroughSubject<ZonesIntentState,Never>()

    func addListObserver(viewModel: ZonesViewModel){
        self.listState.subscribe(viewModel)
    }

    func intentDeleteRequest(id: String) async -> Result<Bool,APIError> {
        let data = await API.zoneDAO().delete(zoneId: id)
        switch data {
            case .success(_):
                self.listState.send(input: .deleteRequest(id: id))
                return data
            case .failure(_):
                return data
        }
    }

    func intentCreateRequest(element: Zone) {
        self.listState.send(input: .createRequest(element: element))
    }
}