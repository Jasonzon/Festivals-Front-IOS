import Foundation
import Combine
import SwiftUI

enum ZoneIntentState {
    case ready
    case testValidation(Zone)
    case updateModel
}

enum ZonesIntentState {
    case upToDate
    case listUpdated
    case deleteRequest(id: Int)
    case createRequest(element: Zone)
}

struct ZoneIntent {

    private var state = PassthroughSubject<ZoneIntentState,Never>()
    private var listState = PassthroughSubject<ZonesIntentState,Never>()

    func addObserver(viewModel: ZoneViewModel) {
        self.state.subscribe(viewModel)
    }

    func intentTestValidation(zone: Zone) {
        self.state.send(.testValidation(zone))
    }

    func intentValidation(zone: Zone) async -> Result<Bool,APIError> {
        let data = await API.zoneDAO().update(zone: zone)
        switch data {
            case .success(_):
                self.state.send(.updateModel)
                return .success(true)
            case .failure(let err):
                return .failure(err)
        }
    }

    func addListObserver(viewModel: ZonesViewModel){
        self.listState.subscribe(viewModel)
    }

    func intentDeleteRequest(id: Int) async -> Result<Bool,APIError> {
        let data = await API.zoneDAO().delete(id: id)
        switch data {
            case .success(_):
                self.listState.send(.deleteRequest(id: id))
                return data
            case .failure(_):
                return data
        }
    }

    func intentCreateRequest(element: Zone) {
        self.listState.send(.createRequest(element: element))
    }
}