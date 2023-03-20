import Foundation
import Combine

class JourViewModel: Subscriber, ObservableObject, JourObserver {

    private var model: Jour
    var copyModel: Jour
    var id: Int
    @Published var name: String
    @Published var debut: String
    @Published var fin: String
    @Published var date: String
    @Published var error : INPUTError = .noError
    
    init(model: Jour){
        self.copyModel = model.copy()
        self.id = copyModel.id
        self.name = copyModel.name
        self.debut = copyModel.debut
        self.fin = copyModel.fin
        self.date = copyModel.date
        self.model = model
        self.copyModel.observer = self  
    }

    func change(name: String) {
        self.name = name
    }

    func change(debut: String) {
        self.debut = debut
    }

    func change(fin: String) {
        self.fin = fin
    }

    func change(date: String) {
        self.date = date
    }
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(_ input: JourIntentState) -> Subscribers.Demand {
        switch(input){
            case .ready:
                break
            case .updateModel:
                self.model.paste(jour: self.copyModel)
            case .testValidation(let jour):
                self.copyModel.name = jour.name
                self.copyModel.debut = jour.debut
                self.copyModel.fin = jour.fin
                self.copyModel.date = jour.date
        }
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }

    func getJourFromViewModel() -> Jour {
        return Jour(name: name, debut: debut, fin: fin, date: date, id: id)
    }
}