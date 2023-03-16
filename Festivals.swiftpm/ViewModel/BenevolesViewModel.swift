import Foundation
import Combine

class BenevolesViewModel: ObservableObject, Subscriber {

    @Published var benevoles: [Benevole]
    @Published var alert = false
    @Published var textAlert = ""
    
    init(benevoles: [Benevole]){
        self.benevoles = benevoles
    }

    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(_ input: BenevolesIntentState) -> Subscribers.Demand {
        switch(input){
            case .upToDate:
                break
            case .listUpdated:
                self.objectWillChange.send()
            case .deleteRequest(let id):
                self.benevoles.removeAll(where: {
                    element in
                    return element.id == id
                })
                self.textAlert = "Benevole supprimé"
                self.alert = true  
            case .createRequest(let benevole):
                self.benevoles.append(benevole)
                self.textAlert = "Benevole créé"
                self.alert = true
        }
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
}