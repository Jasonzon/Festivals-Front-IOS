import Foundation

protocol JourObserver {
    func change(name: String)
    func change(debut: Date)
    func change(fin: Date)
    func change(date: Date)
}

class Jour {

    var observer : JourObserver?
    var id: Int
    var festival: Int

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

    var debut: Date {
        didSet {
            if debut != oldValue {
                self.observer?.change(debut: self.debut)
            }
        }
    }

    var fin: Date {
        didSet {
            if fin != oldValue {
                self.observer?.change(fin: self.fin)
            }
        }
    }

    var date: Date {
        didSet {
            if fin != oldValue {
                self.observer?.change(date: self.date)
            }
        }
    }

    init(name: String, debut: Date, fin: Date, date: Date, id: Int, festival: Int) {
        self.name = name
        self.debut = debut
        self.fin = fin
        self.date = date
        self.id = id
        self.festival = festival
    }

    init(jourDTO: JourDTO) {
        self.name = jourDTO.name
        self.debut = jourDTO.debut
        self.fin = jourDTO.fin
        self.date = jourDTO.date
        self.id = jourDTO.id
        self.festival = jourDTO.festival
    }

    func copy() -> Jour {
        return Jour(name: self.name, debut: self.debut, fin: self.fin, date: self.date, id: self.id, festival: self.festival)
    }

    func paste(jour: Jour) {
        self.name = jour.name
        self.debut = jour.debut
        self.fin = jour.fin
        self.date = jour.date
        self.id = jour.id
        self.festival = jour.festival
    }
}