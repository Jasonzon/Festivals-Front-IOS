import Foundation
import Combine

class ZonesViewModel: ObservableObject, Subscriber {

    @Published var zones: [Zone]
    @Published var alert = false
    @Published var textAlert = ""
    
    init(zones: [Zone]){
        self.zones = zones
    }

    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(_ input: ZonesIntentState) -> Subscribers.Demand {
        switch(input){
            case .upToDate:
                break
            case .listUpdated:
                self.objectWillChange.send()
            case .deleteRequest(let id):
                self.zones.removeAll(where: {
                    element in
                    return element.id == id
                })
                self.textAlert = "Zone supprimée"
                self.alert = true  
            case .createRequest(let zone):
                self.zones.append(zone)
                self.textAlert = "Zone créée"
                self.alert = true
        }
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
}