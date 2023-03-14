import Foundation
import Combine

class JeuViewModel: Subscriber, ObservableObject, JeuObserver {

    private var model: Jeu
    var copyModel: Jeu
    var id: String
    @Published var name: String
    @Published var type: JeuType
    @Published var error : INPUTError = .noError
    
    init(model: Jeu){
        self.copyModel = model.copy()
        self.id = copyModel.id
        self.name = copyModel.name
        self.type = copyModel.type
        self.model = model
        self.copyModel.observer = self  
    }

    func change(name: String) {
        self.name = name
    }

    func change(type: JeuType) {
        self.type = type
    }
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(input: JeuIntentState) -> Subscribers.Demand {
        switch(input){
            case .ready:
                break
            case .updateModel:
                self.model.paste(self.copyModel)
            case .testValidation(let jeu):
                self.copyModel.name = jeu.name
                self.copyModel.type = jeu.type
        }
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }

    func getJeuFromViewModel() -> Jeu {
        return Jeu(id: id, name: name, type: type)
    }
}