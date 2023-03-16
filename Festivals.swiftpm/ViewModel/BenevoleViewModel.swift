import Foundation
import Combine

class BenevoleViewModel: Subscriber, ObservableObject, BenevoleObserver {

    private var model: Benevole
    var copyModel: Benevole
    var id: String
    @Published var nom: String
    @Published var prenom: String
    @Published var mail: String
    @Published var error : INPUTError = .noError
    
    init(model: Benevole){
        self.copyModel = model.copy()
        self.id = copyModel.id
        self.nom = copyModel.nom
        self.prenom = copyModel.prenom
        self.mail = copyModel.mail
        self.model = model
        self.copyModel.observer = self  
    }

    func change(nom: String) {
        self.nom = nom
    }

    func change(prenom: String) {
        self.prenom = prenom
    }

    func change(mail: String) {
        self.mail = mail
    }
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(_: BenevoleIntentState) -> Subscribers.Demand {
        switch(input){
            case .ready:
                break
            case .updateModel:
                self.model.paste(benevole: self.copyModel)
            case .testValidation(let benevole):
                self.copyModel.nom = benevole.nom
                self.copyModel.prenom = benevole.prenom
                self.copyModel.mail = benevole.mail
        }
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }

    func getBenevoleFromViewModel() -> Benevole {
        return Benevole(id: id, nom: nom, prenom: prenom, mail: mail)
    }
}