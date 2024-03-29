import Foundation
import Combine

class ZoneViewModel: Subscriber, ObservableObject, ZoneObserver {

    private var model: Zone
    var copyModel: Zone
    var id: Int
    var festival: Int
    @Published var name: String
    @Published var benevoles: Int
    @Published var error : INPUTError = .noError
    
    init(model: Zone){
        self.copyModel = model.copy()
        self.festival = copyModel.festival
        self.benevoles = copyModel.benevoles
        self.id = copyModel.id
        self.name = copyModel.name
        self.model = model
        self.copyModel.observer = self  
    }

    func change(name: String) {
        self.name = name
    }

    func change(benevoles: Int) {
        self.benevoles = benevoles
    }
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(_ input: ZoneIntentState) -> Subscribers.Demand {
        switch(input){
            case .ready:
                break
            case .updateModel:
                self.model.paste(zone: self.copyModel)
            case .testValidation(let zone):
                self.copyModel.name = zone.name
                self.copyModel.benevoles = zone.benevoles
        }
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }

    func getZoneFromViewModel() -> Zone {
        return Zone(name: name, id: id, benevoles: benevoles, festival: festival)
    }
}