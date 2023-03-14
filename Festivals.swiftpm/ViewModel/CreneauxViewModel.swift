import Foundation
import Combine

class CreneauxViewModel: ObservableObject, Subscriber {

    @Published var creneaux: [Creneau]
    @Published var alert = false
    @Published var textAlert = ""
    
    init(creneaux: [Creneau]){
        self.creneaux = creneaux
    }

    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(input: CreneauxIntentState) -> Subscribers.Demand {
        switch(input){
            case .upToDate:
                break
            case .listUpdated:
                self.objectWillChange.send()
            case .deleteRequest(let id):
                self.creneaux.removeAll(where: {
                    element in
                    return element.id == id
                })
                self.textAlert = "Creneau supprimé"
                self.alert = true  
            case .createRequest(let creneau):
                self.creneaux.append(creneau)
                self.textAlert = "Creneau créé"
                self.alert = true
        }
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
}