import Foundation

protocol CreneauObserver {
    func changed(debut: String)
    func changed(fin: String)
}

class Creneau : ObservableObject {

    var observer : CreneauObserver?
    var id : String = UUID().uuidString

    var debut : String {
        didSet {
            if debut != oldValue {
                if isDebutValid() {
                    self.observer?.changed(debut: self.debut)
                }
                else {
                    self.debut = oldValue
                }
            }
        }
    }

    var fin : String {
        didSet {
            if fin != oldValue {
                if isFinValid() {
                    self.observer?.changed(fin: self.fin)
                }
                else {
                    self.fin = oldValue
                }
            }
        }
    }

    init(debut: String, fin: String, id: String) {
        self.debut = debut
        self.fin = fin
        self.id = id
    }

    init(creneauDTO: CreneauDTO) {
        self.debut = creneauDTO.debut
        self.fin = creneauDTO.fin
        self.id = creneauDTO.id
    }

    func isDebutValid() -> Bool {
        return true //Pour l'instant, à changer
    }

    func isFinValid() -> Bool {
        return true //Pour l'instant, à changer
    }
}