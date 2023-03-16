import Foundation
import Combine

class ZoneViewModel: Subscriber, ObservableObject, ZoneObserver {

    private var model: Zone
    var copyModel: Zone
    var id: String
    @Published var name: String
    @Published var error : INPUTError = .noError
    
    init(model: Zone){
        self.copyModel = model.copy()
        self.id = copyModel.id
        self.name = copyModel.name
        self.model = model
        self.copyModel.observer = self  
    }

    func change(name: String) {
        self.name = name
    }
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(input: ZoneIntentState) -> Subscribers.Demand {
        switch(input){
            case .ready:
                break
            case .updateModel:
                self.model.paste(zone: self.copyModel)
            case .testValidation(let zone):
                self.copyModel.name = zone.name
        }
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }

    func getZoneFromViewModel() -> Zone {
        return Zone(id: id, name: name)
    }
}