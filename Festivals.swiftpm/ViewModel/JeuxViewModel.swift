import Foundation
import Combine

class JeuxViewModel: ObservableObject, Subscriber {

    @Published var jeux: [Jeu]
    @Published var jeuTypes: [JeuType] = []
    @Published var alert = false
    @Published var textAlert = ""
    
    init(jeux: [Jeu]){
        self.jeux = jeux
    }

    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(input: JeuxIntentState) -> Subscribers.Demand {
        switch(input){
            case .upToDate:
                break
            case .listUpdated:
                self.objectWillChange.send()
            case .deleteRequest(let id):
                self.jeux.removeAll(where: {
                    element in
                    return element.id == id
                })
                self.textAlert = "Jeu supprimé"
                self.alert = true  
            case .createRequest(let jeu):
                self.jeux.append(jeu)
                self.textAlert = "Jeu créé"
                self.alert = true
        }
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
}