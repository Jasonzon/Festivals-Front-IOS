import Foundation
import Combine

class FestivalsViewModel: ObservableObject, Subscriber {

    @Published var festivals: [Festival]
    @Published var alert = false
    @Published var textAlert = ""
    
    init(festivals: [Festival]){
        self.festivals = festivals
    }

    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(_ input: FestivalsIntentState) -> Subscribers.Demand {
        switch(input){
            case .upToDate:
                break
            case .listUpdated:
                self.objectWillChange.send()
            case .deleteRequest(let id):
                self.festivals.removeAll(where: {
                    element in
                    return element.id == id
                })
                self.textAlert = "Festival supprimé"
                self.alert = true  
            case .createRequest(let festival):
                self.festivals.append(festival)
                self.textAlert = "Festival créé"
                self.alert = true
        }
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
}