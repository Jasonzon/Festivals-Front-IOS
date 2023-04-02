import Foundation

protocol CreneauObserver {
    func change(debut: String)
    func change(fin: String)
}

class Creneau {

    var observer : CreneauObserver?
    var id: Int
    var jour: Int

    var debut: String {
        didSet {
            if debut != oldValue {
                if isDebutValid() {
                    self.observer?.change(debut: self.debut)
                }
                else {
                    self.debut = oldValue
                }
            }
        }
    }

    var fin: String {
        didSet {
            if fin != oldValue {
                if isFinValid() {
                    self.observer?.change(fin: self.fin)
                }
                else {
                    self.fin = oldValue
                }
            }
        }
    }

    init(debut: String, fin: String, id: Int, jour: Int) {
        self.debut = debut
        self.fin = fin
        self.id = id
        self.jour = jour
    }

    init(creneauDTO: CreneauDTO) {
        self.debut = creneauDTO.debut
        self.fin = creneauDTO.fin
        self.id = creneauDTO.id
        self.jour = creneauDTO.jour
    }

    func isDebutValid() -> Bool {
        return true //Pour l'instant, à changer
    }

    func isFinValid() -> Bool {
        return true //Pour l'instant, à changer
    }

    func copy() -> Creneau {
        return Creneau(debut: self.debut, fin: self.fin, id: self.id, jour: self.jour)
    }

    func paste(creneau: Creneau) {
        self.debut = creneau.debut
        self.fin = creneau.fin
        self.id = creneau.id
        self.jour = creneau.jour
    }
}