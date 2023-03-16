import Foundation

protocol JeuObserver {
    func change(name: String)
    func change(type: JeuType)
}

enum JeuType : String, CaseIterable, Identifiable, Codable {
    case Enfant, Famille, Initie, Avance, Expert
    var id: Self {self}
}

class Jeu {

    var observer : JeuObserver?
    var id: String

    var name: String {
        didSet {
            if name != oldValue {
                if name.count >= 1 {
                    self.observer?.change(name: self.name)
                }
                else {
                    self.name = oldValue
                }
            }
        }
    }

    var type: JeuType {
        didSet {
            if type != oldValue {
                self.observer?.change(type : self.type)
            }
        }
    }

    init(name: String, type: JeuType, id: String) {
        self.name = name
        self.type = type
        self.id = id
    }

    init(jeuDTO: JeuDTO) {
        self.name = jeuDTO.name
        self.type = jeuDTO.type
        self.id = jeuDTO.id
    }

    func copy() -> Jeu {
        return Jeu(name: self.name, type: self.type, id: self.id)
    }

    func paste(jeu: Jeu) {
        self.name = jeu.name
        self.type = jeu.type
        self.id = jeu.id
    }
}