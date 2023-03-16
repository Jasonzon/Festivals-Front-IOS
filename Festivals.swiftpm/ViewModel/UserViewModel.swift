import Foundation
import Combine

class UserViewModel: Subscriber, ObservableObject, UserObserver {

    private var model: User
    var copyModel: User
    var id: String
    @Published var nom: String
    @Published var prenom: String
    @Published var role: UserRole
    @Published var mail: String
    @Published var password: String
    @Published var error : INPUTError = .noError
    
    init(model: User){
        self.copyModel = model.copy()
        self.id = copyModel.id
        self.nom = copyModel.nom
        self.prenom = copyModel.prenom
        self.role = copyModel.role
        self.mail = copyModel.mail
        self.password = copyModel.password
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

    func change(role: UserRole) {
        self.role = role
    }

    func change(password: String) {
        self.password = password
    }
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(_: UserIntentState) -> Subscribers.Demand {
        switch(input){
            case .ready:
                break
            case .updateModel:
                self.model.paste(user: self.copyModel)
            case .testValidation(let user):
                self.copyModel.nom = user.nom
                self.copyModel.prenom = user.prenom
                self.copyModel.role = user.role
                self.copyModel.mail = user.mail
                self.copyModel.password = user.password
        }
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }

    func getUserFromViewModel() -> User {
        return User(id: id, nom: nom, prenom: prenom, role: role, mail: mail, password: password)
    }
}