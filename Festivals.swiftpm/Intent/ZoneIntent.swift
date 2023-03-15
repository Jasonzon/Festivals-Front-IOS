import Foundation
import Combine
import SwiftUI

enum ZoneIntentState {
    case ready
    case testValidation(Zone)
    case updateModel
}

struct ZoneIntent {

    private var state = PassthroughSubject<ZoneIntentState,Never>()

    func addObserver(viewModel: ZoneViewModel) {
        self.state.subscribe(viewModel)
    }

    func intentTestValidation(zone: Zone) {
        self.state.send(input: .testValidation(zone))
    }

    func intentValidation(zone: Zone) async -> Result<Bool,APIError> {
        let data = await API.zoneDAO().update(zone: ZoneDTO(zone: zone))
        switch data {
            case .success(_):
                self.state.send(input: .updateModel)
                return .success(true)
            case .failure(let err):
                return .failure(err)
        }
    }
}