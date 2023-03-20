import Foundation
import Combine
import SwiftUI

enum FestivalIntentState {
    case ready
    case testValidation(Festival)
    case updateModel
}

enum FestivalsIntentState {
    case upToDate
    case listUpdated
    case deleteRequest(id: Int)
    case createRequest(element: Festival)
}

struct FestivalIntent {

    private var state = PassthroughSubject<FestivalIntentState,Never>()
    private var listState = PassthroughSubject<FestivalsIntentState,Never>()

    func addObserver(viewModel: FestivalViewModel){
        self.state.subscribe(viewModel)
    }

    func intentTestValidation(festival: Festival){
        self.state.send(.testValidation(festival))
    }

    func intentValidation(festival: Festival) async -> Result<Bool,APIError> {
        let data = await API.festivalDAO().update(festival: festival)
        switch data {
            case .success(_):
                self.state.send(.updateModel)
                return .success(true)
            case .failure(let err):
                return .failure(err)
        }
    }

    func addListObserver(viewModel: FestivalsViewModel){
        self.listState.subscribe(viewModel)
    }

    func intentDeleteRequest(id: Int) async -> Result<Bool,APIError> {
        let data = await API.festivalDAO().delete(id: id)
        switch data {
            case .success(_):
                self.listState.send(.deleteRequest(id: id))
                return data
            case .failure(_):
                return data
        }
    }

    func intentCreateRequest(element: Festival) {
        self.listState.send(.createRequest(element: element))
    }
}