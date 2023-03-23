import Foundation
import Combine

class BenevoleViewModel: Subscriber, ObservableObject, BenevoleObserver {

    private var model: Benevole
    var copyModel: Benevole
    var id: Int
    @Published var nom: String
    @Published var prenom: String
    @Published var mail: String
    @Published var role: UserRole
    @Published var password: String
    @Published var error : INPUTError = .noError
    
    init(model: Benevole){
        self.copyModel = model.copy()
        self.id = copyModel.id
        self.nom = copyModel.nom
        self.prenom = copyModel.prenom
        self.mail = copyModel.mail
        self.model = model
        self.role = copyModel.role
        self.password = copyModel.password
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

    func change(role: UserRole) {
        self.role = role
    }

    func change(password: String) {
        self.password = password
    }
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(_ input: BenevoleIntentState) -> Subscribers.Demand {
        switch(input){
            case .ready:
                break
            case .updateModel:
                self.model.paste(benevole: self.copyModel)
            case .testValidation(let benevole):
                self.copyModel.nom = benevole.nom
                self.copyModel.prenom = benevole.prenom
                self.copyModel.mail = benevole.mail
                self.copyModel.password = benevole.password
        }
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }

    func getBenevoleFromViewModel() -> Benevole {
        return Benevole(mail: mail, nom: nom, prenom: prenom, id: id, role: role, password: password)
    }
}