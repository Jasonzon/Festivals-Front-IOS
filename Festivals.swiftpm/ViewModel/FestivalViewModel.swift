import Foundation
import Combine

class FestivalViewModel: Subscriber, ObservableObject, FestivalObserver {

    private var model: Festival
    var copyModel: Festival
    var id: Int
    @Published var name: String
    @Published var year: String
    @Published var opened: Bool
    @Published var error : INPUTError = .noError
    
    init(model: Festival){
        self.copyModel = model.copy()
        self.id = copyModel.id
        self.name = copyModel.name
        self.year = copyModel.year
        self.opened = copyModel.opened
        self.model = model
        self.copyModel.observer = self  
    }

    func change(name: String) {
        self.name = name
    }

    func change(year: String) {
        self.year = year
    }
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(_ input: FestivalIntentState) -> Subscribers.Demand {
        switch(input){
            case .ready:
                break
            case .updateModel:
                self.model.paste(festival: self.copyModel)
            case .testValidation(let festival):
                self.copyModel.name = festival.name
                self.copyModel.year = festival.year
                self.copyModel.opened = festival.opened
        }
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }

    func getFestivalFromViewModel() -> Festival {
        return Festival(name: name, year: year, opened: opened, id: id)
    }
}