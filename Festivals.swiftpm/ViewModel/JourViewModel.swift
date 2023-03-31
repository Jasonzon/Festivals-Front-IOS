import Foundation
import Combine

class JourViewModel: Subscriber, ObservableObject, JourObserver {

    private var model: Jour
    var copyModel: Jour
    var id: Int
    var festival: Int
    @Published var name: String
    @Published var debut: Date
    @Published var fin: Date
    @Published var date: Date
    @Published var error : INPUTError = .noError
    
    init(model: Jour){
        self.copyModel = model.copy()
        self.festival = copyModel.festival
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

    func change(debut: Date) {
        self.debut = debut
    }

    func change(fin: Date) {
        self.fin = fin
    }

    func change(date: Date) {
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
        return Jour(name: name, debut: debut, fin: fin, date: date, id: id, festival: festival)
    }
}