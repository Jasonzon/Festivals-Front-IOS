import Foundation

protocol JourObserver {
    func change(name: String)
    func change(debut: String)
    func change(fin: String)
    func change(date: String)
}

class Jour {

    var observer : JourObserver?
    var id: Int

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

    var debut: String {
        didSet {
            if debut != oldValue {
                self.observer?.change(debut: self.debut)
            }
        }
    }

    var fin: String {
        didSet {
            if fin != oldValue {
                self.observer?.change(fin: self.fin)
            }
        }
    }

    var date: String {
        didSet {
            if fin != oldValue {
                self.observer?.change(date: self.date)
            }
        }
    }

    init(name: String, debut: String, fin: String, date: String, id: Int) {
        self.name = name
        self.debut = debut
        self.fin = fin
        self.date = date
        self.id = id
    }

    init(jourDTO: JourDTO) {
        self.name = jourDTO.name
        self.debut = jourDTO.debut
        self.fin = jourDTO.fin
        self.date = jourDTO.date
        self.id = jourDTO.id
    }

    func copy() -> Jour {
        return Jour(name: self.name, debut: self.debut, fin: self.fin, date: self.date, id: self.id)
    }

    func paste(jour: Jour) {
        self.name = jour.name
        self.debut = jour.debut
        self.fin = jour.fin
        self.date = jour.date
        self.id = jour.id
    }
}