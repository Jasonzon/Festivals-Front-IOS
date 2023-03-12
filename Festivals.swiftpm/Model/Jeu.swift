import Foundation

protocol JeuObserver {
    func changed(name: String)
    func changed(type: JeuType)
}

enum JeuType : String, CaseIterable, Identifiable {
    case Enfant, Famille, Initie, Avance, Expert
    var id: Self {self}
}

class Jeu : ObservableObject {

    var observer : JeuObserver?
    var id : String = UUID().uuidString

    var name : String {
        didSet {
            if name != oldValue {
                if name.count >= 1 {
                    self.observer?.changed(name: self.name)
                }
                else {
                    self.name = oldValue
                }
            }
        }
    }

    var type : JeuType {
        didSet {
            if type != oldValue {
                self.observer?.changed(type : self.type)
            }
        }
    }

    init(name: String, type: JeuType, id: String) {
        self.name = name
        self.type = type
        self.id = id
    }
}