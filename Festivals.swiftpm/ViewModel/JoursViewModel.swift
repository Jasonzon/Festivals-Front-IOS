import Foundation
import Combine

class JoursViewModel: ObservableObject, Subscriber {

    @Published var jours: [Jour]
    @Published var alert = false
    @Published var textAlert = ""
    
    init(jours: [Jour]){
        self.jours = jours
    }

    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(_ input: JoursIntentState) -> Subscribers.Demand {
        switch(input){
            case .upToDate:
                break
            case .listUpdated:
                self.objectWillChange.send()
            case .deleteRequest(let id):
                self.jours.removeAll(where: {
                    element in
                    return element.id == id
                })
                self.textAlert = "Jour supprimé"
                self.alert = true  
            case .createRequest(let jour):
                self.jours.append(jour)
                self.textAlert = "Jour créé"
                self.alert = true
        }
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
}